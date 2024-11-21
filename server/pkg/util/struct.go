package util

import (
	"fmt"
	"github.com/spf13/viper"
	"reflect"
	"strings"
)

type Filter struct {
	*viper.Viper
}

func NewFilter(m map[string]string) *Filter {
	cf := viper.New()
	for k, v := range m {
		cf.Set(k, v)
	}
	return &Filter{cf}
}

type DynamicModel[T any] struct {
	newModel any
	oldModel T
	isset    bool
	values   map[string]reflect.Value
}

func (m *DynamicModel[T]) Model() T {
	if m.isset {
		return m.oldModel
	}
	v := reflect.ValueOf(m.newModel)
	for v.Kind() == reflect.Ptr {
		v = v.Elem()
	}

	t := v.Type()
	for i := 0; i < t.NumField(); i++ {
		field := t.Field(i)
		if !field.IsExported() {
			continue
		}
		if oldVal, ok := m.values[field.Name]; ok {
			oldVal.Set(v.Field(i))
		}
	}
	m.isset = true
	return m.oldModel
}

func (m *DynamicModel[T]) NewModel() any {
	return m.newModel
}

func NewDynamicModel[T any](oldModel T, tagName string, replacer map[string]string) *DynamicModel[T] {
	m := &DynamicModel[T]{oldModel: oldModel, values: make(map[string]reflect.Value)}

	v := reflect.ValueOf(oldModel)
	for v.Kind() == reflect.Ptr {
		v = v.Elem()
	}
	fields := make([]reflect.StructField, 0)

	t := v.Type()
	for i := 0; i < t.NumField(); i++ {
		field := t.Field(i)

		tag := field.Tag.Get(tagName)
		if tag == "-" {
			newTag := ""
			if replacer != nil {
				newTag = replacer[field.Name]
			}
			field.Tag = reflect.StructTag(strings.ReplaceAll(string(field.Tag), fmt.Sprintf(`%s:"-"`, tagName), newTag))
		}
		fields = append(fields, field)

		m.values[field.Name] = v.Field(i)
	}
	m.newModel = reflect.New(reflect.StructOf(fields)).Interface()
	return m
}
