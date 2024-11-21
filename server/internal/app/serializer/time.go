package serializer

import (
	"context"
	"fmt"
	"reflect"
	"time"

	"google.golang.org/protobuf/types/known/timestamppb"
	"gorm.io/gorm/schema"
)

type ProtobufTimestamp struct{}

func (ProtobufTimestamp) Scan(ctx context.Context, field *schema.Field, dst reflect.Value, dbValue interface{}) (err error) {
	// fmt.Println(reflect.TypeOf(dbValue).Name())
	if dbValue != nil {
		var t *timestamppb.Timestamp

		switch v := dbValue.(type) {
		case []byte:
			tm, err := time.Parse("2006-01-02 15:04:05+00:00", string(v))
			if err != nil {
				return err
			}
			t = timestamppb.New(tm)
		case string:
			tm, err := time.Parse("2006-01-02 15:04:05+00:00", v)
			if err != nil {
				return err
			}
			t = timestamppb.New(tm)
		case int64:
			t = timestamppb.New(time.Unix(v, 0))
		case time.Time:
			t = timestamppb.New(v)
		default:
			return fmt.Errorf("failed to scan TIMESTAMP value: %#v", dbValue)
		}
		field.Set(ctx, dst, t)
	}
	return
}

func (ProtobufTimestamp) Value(_ context.Context, _ *schema.Field, _ reflect.Value, fieldValue interface{}) (interface{}, error) {
	rv := reflect.ValueOf(fieldValue)
	if rv.IsNil() || rv.IsZero() {
		return time.Now(), nil
	}

	if t, ok := fieldValue.(time.Time); ok {
		return t, nil
	}

	if t, ok := fieldValue.(*timestamppb.Timestamp); ok {
		if err := t.CheckValid(); err != nil {
			return nil, err
		}
		return t.AsTime(), nil
	}
	return nil, fmt.Errorf("invalid field type %#v for TimestampSerializer", fieldValue)
}
