package serializer

import (
	"context"
	"fmt"
	"reflect"
	"time"

	// "google.golang.org/protobuf/ptypes"
	"google.golang.org/protobuf/proto"
	"google.golang.org/protobuf/types/known/anypb"
	"google.golang.org/protobuf/types/known/wrapperspb"
	"gorm.io/gorm/schema"
	// "google.golang.org/grpc/encoding/proto"
)

type ProtobufAny struct{}

// func ConvertInterfaceToAny(v interface{}) (*anypb.Any, error) {
//	bytes, _ := json.Marshal(v)
//	bytesValue := &wrapperspb.BytesValue{
//		Value: bytes,
//	}
//	anyValue := &anypb.Any{}
//	err := anypb.MarshalFrom(anyValue, bytesValue, proto.MarshalOptions{})
//	return anyValue, err
// }

// func ConvertAnyToInterface(anyValue *anypb.Any) (interface{}, error) {
//	var value interface{}
//	bytesValue := &wrapperspb.BytesValue{}
//	err := anypb.UnmarshalTo(anyValue, bytesValue, proto.UnmarshalOptions{})
//	if err != nil {
//		return value, err
//	}
//	uErr := json.Unmarshal(bytesValue.Value, &value)
//	if uErr != nil {
//		return value, uErr
//	}
//	return value, nil
// }

func (ProtobufAny) Scan(ctx context.Context, field *schema.Field, dst reflect.Value, dbValue interface{}) error {
	if dbValue != nil {
		var b []byte

		switch v := dbValue.(type) {
		case []byte:
			b = v
		case string:
			b = []byte(v)
		default:
			return fmt.Errorf("failed to scan TIMESTAMP value: %#v", dbValue)
		}

		var (
			value  anypb.Any
			bvalue wrapperspb.BytesValue
		)

		bvalue.Value = b

		if err := anypb.MarshalFrom(&value, &bvalue, proto.MarshalOptions{}); err != nil {
			return err
		}
		field.Set(ctx, dst, &value)
	}
	return nil
}

func (ProtobufAny) Value(_ context.Context, _ *schema.Field, _ reflect.Value, fieldValue interface{}) (interface{}, error) {
	rv := reflect.ValueOf(fieldValue)
	if rv.IsNil() || rv.IsZero() {
		return time.Now(), nil
	}

	if v, ok := fieldValue.(*anypb.Any); ok {
		var (
			bvalue wrapperspb.BytesValue
		)

		if err := anypb.UnmarshalTo(v, &bvalue, proto.UnmarshalOptions{}); err != nil {
			return nil, err
		}
		return bvalue.Value, nil
	}
	return nil, fmt.Errorf("invalid field type %#v for TimestampSerializer", fieldValue)
}
