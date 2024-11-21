package config

import (
	"os"
	"strings"
	"sync"

	"github.com/spf13/viper"
)

type Config struct {
	mu sync.RWMutex
	cf *viper.Viper
	L  *Logger
}

func fileExists(path string) bool {
	if _, err := os.Stat(path); os.IsExist(err) || err == nil {
		return true
	}
	return false
}

func (conf *Config) LoadFromFile(file string) error {
	conf.mu.Lock()
	defer conf.mu.Unlock()

	_, err := os.Stat(file)
	if os.IsExist(err) || err == nil {
		content, err := os.ReadFile(file)
		if err != nil {
			return err
		}
		conf.cf.SetConfigFile(file)
		return conf.cf.ReadConfig(strings.NewReader(os.ExpandEnv(string(content))))
	}
	conf.L.Errorf(err.Error())
	return nil
}

func (conf *Config) Map(keys []string) map[string]any {
	conf.mu.RLock()
	defer conf.mu.RUnlock()

	cf := viper.New()
	for _, key := range keys {
		cf.Set(key, conf.cf.Get(key))
	}
	return cf.AllSettings()
}

func (conf *Config) Sub(key string) *Config {
	conf.mu.RLock()
	defer conf.mu.RUnlock()

	cf := conf.cf.Sub(key)
	if cf == nil {
		return nil
	}
	return &Config{cf: cf}
}

func (conf *Config) IsSet(key string) bool {
	conf.mu.Lock()
	defer conf.mu.Unlock()

	return conf.cf.IsSet(key)
}

func (conf *Config) Set(key string, value any) {
	conf.mu.Lock()
	defer conf.mu.Unlock()

	conf.cf.Set(key, value)
}

func (conf *Config) SetDefault(key string, value any) {
	conf.mu.Lock()
	defer conf.mu.Unlock()

	conf.cf.SetDefault(key, value)
}

func (conf *Config) Get(key string) any {
	conf.mu.RLock()
	defer conf.mu.RUnlock()

	return conf.cf.Get(key)
}

func (conf *Config) GetUint(key string) uint {
	conf.mu.RLock()
	defer conf.mu.RUnlock()

	return conf.cf.GetUint(key)
}

func (conf *Config) GetInt(key string) int {
	conf.mu.RLock()
	defer conf.mu.RUnlock()

	return conf.cf.GetInt(key)
}

func (conf *Config) GetInt32(key string) int32 {
	conf.mu.RLock()
	defer conf.mu.RUnlock()

	return conf.cf.GetInt32(key)
}

func (conf *Config) GetInt64(key string) int64 {
	conf.mu.RLock()
	defer conf.mu.RUnlock()

	return conf.cf.GetInt64(key)
}

func (conf *Config) GetBool(key string) bool {
	conf.mu.RLock()
	defer conf.mu.RUnlock()

	return conf.cf.GetBool(key)
}

func (conf *Config) GetString(key string) string {
	conf.mu.RLock()
	defer conf.mu.RUnlock()

	return conf.cf.GetString(key)
}

func (conf *Config) GetStringMap(key string) map[string]any {
	conf.mu.RLock()
	defer conf.mu.RUnlock()

	return conf.cf.GetStringMap(key)
}

func (conf *Config) GetStringSlice(key string) []string {
	conf.mu.RLock()
	defer conf.mu.RUnlock()

	return conf.cf.GetStringSlice(key)
}

func (conf *Config) AllKeys() []string {
	conf.mu.RLock()
	defer conf.mu.RUnlock()

	return conf.cf.AllKeys()
}

func (conf *Config) AllSettings() map[string]any {
	conf.mu.RLock()
	defer conf.mu.RUnlock()

	return conf.cf.AllSettings()
}

func (conf *Config) Clone() *Config {
	conf.mu.RLock()
	defer conf.mu.RUnlock()

	newcf := viper.New()
	for _, key := range conf.cf.AllKeys() {
		newcf.Set(key, conf.cf.Get(key))
	}
	return &Config{cf: newcf, L: conf.L}
}

func New() *Config {
	conf := &Config{
		cf: viper.New(),
	}
	configs := []map[string]any{
		defaultConfig,
	}
	for _, config := range configs {
		for k, v := range config {
			conf.SetDefault(k, v)
		}
	}

	conf.L = NewLogger(conf)
	return conf
}
