package runner

import (
	"bytes"
	"context"
	"errors"
	"sync"
	"time"

	"github.com/google/uuid"
)

type State int32

const (
	STATE_PENDING State = iota
	STATE_RUNNING
	STATE_SUCCEEDED
	STATE_CANCELING
	STATE_CANCELED
	STATE_FAILED
)

var (
	StateName = map[State]string{
		0: "PENDING",
		1: "RUNNING",
		2: "SUCCEEDED",
		3: "CANCELING",
		4: "CANCELED",
		5: "FAILED",
	}
	StateValue = map[string]State{
		"PENDING":   0,
		"RUNNING":   1,
		"SUCCEEDED": 2,
		"CANCELING": 3,
		"CANCELED":  4,
		"FAILED":    5,
	}
)

type Task interface {
	Id() string
	Name() string
	Err() error
	Log() string
	State() State
	Progress() float64
	ProgressState() string
	Children() []Task
	StartTime() time.Time
	EndTime() time.Time

	DryRun() bool

	Done() <-chan struct{}
	Running() bool
	Context() context.Context
	Logger() Logger
	Run()
	Cancel()
	SetName(string)
	SetState(State)
	SetProgress(float64)
	SetProgressState(string)
}

type memoryTask struct {
	id            string
	name          string
	log           string
	state         State
	progress      float64
	progressState string
	startTime     time.Time
	endTime       time.Time
	err           error
	children      []Task
	subTask       Runner

	mu       sync.RWMutex
	buf      *bytes.Buffer
	ctx      context.Context
	cancel   context.CancelFunc
	logger   Logger
	runner   Runner
	taskFunc func(Task) error
	donec    chan struct{}
}

func (t *memoryTask) DryRun() bool {
	return true
}

func (t *memoryTask) Id() string {
	t.mu.RLock()
	defer t.mu.RUnlock()
	return t.id
}

func (t *memoryTask) Name() string {
	t.mu.RLock()
	defer t.mu.RUnlock()
	return t.name
}

func (t *memoryTask) Context() context.Context {
	t.mu.RLock()
	defer t.mu.RUnlock()
	return t.ctx
}

func (t *memoryTask) Logger() Logger {
	t.mu.RLock()
	defer t.mu.RUnlock()
	return t.logger
}

func (t *memoryTask) Err() error {
	t.mu.RLock()
	defer t.mu.RUnlock()
	return t.err
}

func (t *memoryTask) Log() string {
	t.mu.RLock()
	defer t.mu.RUnlock()
	return t.buf.String()
}

func (t *memoryTask) State() State {
	t.mu.RLock()
	defer t.mu.RUnlock()
	return t.state
}

func (t *memoryTask) Progress() float64 {
	t.mu.RLock()
	defer t.mu.RUnlock()
	return t.progress
}

func (t *memoryTask) ProgressState() string {
	t.mu.RLock()
	defer t.mu.RUnlock()
	return t.progressState
}

func (t *memoryTask) StartTime() time.Time {
	t.mu.RLock()
	defer t.mu.RUnlock()
	return t.startTime
}

func (t *memoryTask) EndTime() time.Time {
	t.mu.RLock()
	defer t.mu.RUnlock()
	return t.endTime
}

func (t *memoryTask) Children() []Task {
	t.mu.RLock()
	defer t.mu.RUnlock()
	return t.children
}

func (t *memoryTask) Done() <-chan struct{} {
	return t.donec
}

func (t *memoryTask) Running() bool {
	t.mu.RLock()
	defer t.mu.RUnlock()
	return t.state == STATE_RUNNING || t.state == STATE_CANCELING
}

func (t *memoryTask) Cancel() {
	t.mu.Lock()
	defer t.mu.Unlock()

	t.state = STATE_CANCELING
	t.cancel()
}

func (t *memoryTask) SetName(name string) {
	t.mu.Lock()
	defer t.mu.Unlock()
	t.name = name
}

func (t *memoryTask) SetState(state State) {
	t.mu.Lock()
	defer t.mu.Unlock()
	t.state = state
}

func (t *memoryTask) SetProgress(p float64) {
	t.mu.Lock()
	defer t.mu.Unlock()
	t.progress = p
}

func (t *memoryTask) SetProgressState(p string) {
	t.mu.Lock()
	defer t.mu.Unlock()
	t.progressState = p
}

func (t *memoryTask) Run() {
	t.startTime = time.Now()
	t.state = STATE_RUNNING
	defer close(t.donec)

	select {
	case <-t.ctx.Done():
		t.mu.Lock()
		defer t.mu.Unlock()

		t.state = STATE_CANCELED
	default:
		err := t.taskFunc(t)

		t.mu.Lock()
		defer t.mu.Unlock()

		if err != nil {
			if errors.Is(err, context.Canceled) {
				t.state = STATE_CANCELED
			} else {
				t.state = STATE_FAILED
			}
			t.err = err
		} else {
			t.state = STATE_SUCCEEDED
		}
	}
	if t.err != nil {
		t.logger.Errorf("任务执行失败: %s", t.err.Error())
		t.progressState = t.err.Error()
	} else {
		t.progress = 1.0
	}

	// 等待子任务完成
	for _, child := range t.children {
		<-child.Done()
	}
	t.endTime = time.Now()
}

func GenerateUUID() string {
	id, _ := uuid.NewUUID()
	return id.String()
}

type taskOption func(task *memoryTask)

func WithID(id string) taskOption {
	return func(task *memoryTask) {
		task.id = id
	}
}

func WithName(name string) taskOption {
	return func(task *memoryTask) {
		task.name = name
	}
}

func WithLogger(logger Logger) taskOption {
	return func(task *memoryTask) {
		task.logger = logger
	}
}

func NewTask(ctx context.Context, name string, fn func(Task) error, taskOpts ...taskOption) Task {
	task := &memoryTask{
		id:       GenerateUUID(),
		state:    STATE_PENDING,
		donec:    make(chan struct{}),
		buf:      bytes.NewBuffer(nil),
		name:     name,
		taskFunc: fn,
	}
	for _, opt := range taskOpts {
		opt(task)
	}
	if task.logger == nil {
		task.logger = NewLogger(task.buf)
	}

	task.ctx, task.cancel = context.WithCancel(ctx)
	return task
}
