package app

import (
	"context"

	"errors"
	"google.golang.org/grpc"
	// "google.golang.org/grpc/metadata"
)

var (
	errInvalidToken    = errors.New("invalid token")
	errMissingMetadata = errors.New("miss metadata")
)

func (app *App) unaryInterceptor(ctx context.Context, req any, info *grpc.UnaryServerInfo, handler grpc.UnaryHandler) (any, error) {
	// md, ok := metadata.FromIncomingContext(ctx)
	// if !ok {
	//	return nil, errMissingMetadata
	// }

	// if values := md.Get("Authorization"); len(values) > 0 {
	//	if values[0] == "AAA" {
	//		return handler(ctx, req)
	//	}
	// }
	// return nil, errInvalidToken
	return handler(ctx, req)
}

func (app *App) streamInterceptor(srv any, stream grpc.ServerStream, info *grpc.StreamServerInfo, handler grpc.StreamHandler) error {
	// authentication (token verification)
	// md, ok := metadata.FromIncomingContext(stream.Context())
	// if !ok {
	//	return errMissingMetadata
	// }
	// if values := md.Get("Authorization"); len(values) > 0 {
	//	if values[0] == "AAA" {
	//		return handler(ctx, req)
	//	}
	// }
	// err := handler(srv, newWrappedStream(ss))
	// if err != nil {
	//	logger("RPC failed with error: %v", err)
	// }
	// return err
	return handler(srv, stream)
}
