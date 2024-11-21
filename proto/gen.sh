#!/bin/bash

buf generate --include-imports --include-wkt
protoc-go-inject-tag -input="../server/internal/proto/api/file/*.pb.go"
protoc-go-inject-tag -input="../server/internal/proto/api/task/*.pb.go"
protoc-go-inject-tag -input="../server/internal/proto/api/setting/*.pb.go"