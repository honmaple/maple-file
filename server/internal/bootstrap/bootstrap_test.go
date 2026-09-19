package bootstrap

import (
	"encoding/json"
	"testing"
)

func TestStartReturnsConnectionResult(t *testing.T) {
	t.Cleanup(Stop)

	result, err := Start(`{"path":"` + t.TempDir() + `"}`)
	if err != nil {
		t.Fatal(err)
	}
	if result == "" {
		t.Fatal("Start returned an empty result")
	}

	var value struct {
		Addr  string `json:"addr"`
		Token string `json:"token"`
	}
	if err := json.Unmarshal([]byte(result), &value); err != nil {
		t.Fatal(err)
	}
	if value.Addr == "" || value.Token == "" {
		t.Fatalf("unexpected start result: %s", result)
	}
}
