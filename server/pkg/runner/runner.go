package runner

import (
	"context"
	"errors"
	"sort"
)

type (
	Runner interface {
		Context() context.Context
		Execute(Task)
		Submit(string, func(Task) error, ...taskOption) Task
		SubmitByOption(FuncOption, ...taskOption) Task
		SubmitByTask(Task) Task
		Get(string) (Task, bool)
		GetAll(...func(Task) bool) []Task
		Retry(string) error
		RetryAll(...func(Task) bool)
		Cancel(string) error
		CancelAll(...func(Task) bool)
		Remove(string) error
		RemoveAll(...func(Task) bool)
	}
	TaskFilterFunc func(Task) bool
)

type runner struct {
	ctx    context.Context
	tasks  Cache[string, Task]
	worker chan struct{}
}

var _ Runner = (*runner)(nil)

func (m *runner) Context() context.Context {
	return m.ctx
}

func (m *runner) Execute(task Task) {
	select {
	case <-m.worker:
		task.Run()
	case <-task.Context().Done():
		return
	}
	m.worker <- struct{}{}
}

func (m *runner) Submit(name string, fn func(Task) error, taskOpts ...taskOption) Task {
	return m.SubmitByTask(NewTask(m.ctx, name, fn, taskOpts...))
}

func (m *runner) SubmitByOption(opt FuncOption, taskOpts ...taskOption) Task {
	return m.SubmitByTask(NewTask(m.ctx, opt.String(), opt.Execute, taskOpts...))
}

func (m *runner) SubmitByTask(task Task) Task {
	m.tasks.Store(task.Id(), task)

	go m.Execute(task)
	return task
}

func (m *runner) Get(id string) (Task, bool) {
	return m.tasks.Load(id)
}

func (m *runner) GetAll(filters ...func(Task) bool) []Task {
	tasks := make([]Task, 0)
	m.tasks.Range(func(id string, task Task) bool {
		match := true
		for _, filter := range filters {
			if !filter(task) {
				match = false
				break
			}
		}
		if match {
			tasks = append(tasks, task)
		}
		return true
	})
	sort.Slice(tasks, func(i, j int) bool {
		return tasks[i].StartTime().After(tasks[j].StartTime())
	})
	return tasks
}

func (m *runner) Retry(id string) error {
	task, ok := m.Get(id)
	if !ok {
		return errors.New("任务不存在")
	}

	if task.Running() {
		return errors.New("任务还在运行，请先取消任务或者稍后重试")
	}
	task.Reset(m.ctx)

	go m.Execute(task)
	return nil
}

func (m *runner) RetryAll(filters ...func(Task) bool) {
	m.tasks.Range(func(id string, task Task) bool {
		match := true
		for _, filter := range filters {
			if !filter(task) {
				match = false
				break
			}
		}
		if match {
			m.Retry(id)
		}
		return true
	})
}

func (m *runner) Cancel(id string) error {
	task, ok := m.Get(id)
	if !ok {
		return errors.New("任务未找到")
	}
	task.Cancel()
	return nil
}

func (m *runner) CancelAll(filters ...func(Task) bool) {
	m.tasks.Range(func(id string, task Task) bool {
		match := true
		for _, filter := range filters {
			if !filter(task) {
				match = false
				break
			}
		}
		if match {
			m.Cancel(id)
		}
		return true
	})
}

func (m *runner) Remove(id string) error {
	task, ok := m.Get(id)
	if ok && task.Running() {
		task.Cancel()
	}
	m.tasks.Delete(id)
	return nil
}

func (m *runner) RemoveAll(filters ...func(Task) bool) {
	m.tasks.Range(func(id string, task Task) bool {
		match := true
		for _, filter := range filters {
			if !filter(task) {
				match = false
				break
			}
		}
		if match {
			m.Remove(id)
		}
		return true
	})
}

func (m *runner) Count() map[string]int {
	count := make(map[string]int)

	m.tasks.Range(func(id string, task Task) bool {
		if task.Running() {
			count["running"]++
		} else if task.Err() != nil {
			count["failed"]++
		} else {
			count["finished"]++
		}
		return true
	})
	return count
}

func New(ctx context.Context, size int) Runner {
	m := &runner{
		ctx:   ctx,
		tasks: NewCache[string, Task](),
	}

	if size <= 0 {
		size = 10
	}

	m.worker = make(chan struct{}, size)
	for i := 0; i < size; i++ {
		m.worker <- struct{}{}
	}
	return m
}
