package util

import (
	"sync"
)

type Cache[K comparable, V any] interface {
	Load(K) (V, bool)
	Store(K, V)
	Delete(K)
	Reset()
	Range(func(K, V) bool)
	Len() int
}

type cache[K comparable, V any] struct {
	m *sync.Map
}

func (c *cache[K, V]) Load(key K) (value V, ok bool) {
	v, ok := c.m.Load(key)
	if !ok {
		return
	}
	value = v.(V)
	return
}

func (c *cache[K, V]) Store(key K, value V) {
	c.m.Store(key, value)
}

func (c *cache[K, V]) Delete(key K) {
	c.m.Delete(key)
}

func (c *cache[K, V]) Range(f func(K, V) bool) {
	c.m.Range(func(key, value any) bool {
		return f(key.(K), value.(V))
	})
}

func (c *cache[K, V]) Reset() {
	c.m.Range(func(key, value any) bool {
		c.m.Delete(key.(K))
		return true
	})
}

func (c *cache[K, V]) Len() int {
	len := 0
	c.m.Range(func(key, value any) bool {
		len++
		return true
	})
	return len
}

func NewCache[K comparable, V any]() Cache[K, V] {
	return &cache[K, V]{m: new(sync.Map)}
}