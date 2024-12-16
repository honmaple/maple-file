package runner

type FuncTask struct {
	Name string
	Func func(Task) error
}

func (opt *FuncTask) String() string {
	return opt.Name
}

func (opt *FuncTask) Execute(e Task) error {
	return opt.Func(e)
}

type (
	Option interface {
		String() string
		Execute(Task) error
	}
)
