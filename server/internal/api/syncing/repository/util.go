package repository

import "encoding/json"

func validJSONObject(value string) bool {
	var object map[string]json.RawMessage
	return json.Unmarshal([]byte(value), &object) == nil && object != nil
}
