package util

import (
	"errors"
	"sync"

	"github.com/go-playground/locales/en"
	"github.com/go-playground/locales/zh"
	"github.com/go-playground/universal-translator"
	"github.com/go-playground/validator/v10"
	zh_translations "github.com/go-playground/validator/v10/translations/zh"
)

var (
	uni      *ut.UniversalTranslator
	validate *validator.Validate
	once     sync.Once
)

func VerifyOption(value interface{}) error {
	once.Do(func() {
		en := en.New()
		uni = ut.New(en, en, zh.New())
		validate = validator.New(validator.WithRequiredStructEnabled())

		trans, _ := uni.GetTranslator("zh")
		zh_translations.RegisterDefaultTranslations(validate, trans)
	})

	trans, _ := uni.GetTranslator("zh")

	if err := validate.Struct(value); err != nil {
		if e, ok := err.(validator.ValidationErrors); ok && len(e) > 0 {
			return errors.New(e[0].Translate(trans))
		}
		return err
	}
	return nil
}
