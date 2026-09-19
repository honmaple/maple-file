#!/bin/bash

buf generate --include-imports --include-wkt
protoc-go-inject-tag -input="../server/internal/proto/api/file/*.pb.go"
protoc-go-inject-tag -input="../server/internal/proto/api/base/*.pb.go"
protoc-go-inject-tag -input="../server/internal/proto/api/syncing/*.pb.go"
