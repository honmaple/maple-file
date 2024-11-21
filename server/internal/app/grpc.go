package app

import (
	"context"
	"net"
	"os"
	"strings"

	"google.golang.org/grpc"
	// "github.com/honmaple/maple-file/server/internal/app/config"
)

type Grpc struct {
	app  *App
	opts []grpc.ServerOption
}

func unaryInterceptor(ctx context.Context, req any, info *grpc.UnaryServerInfo, handler grpc.UnaryHandler) (any, error) {
	// authentication (token verification)
	// md, ok := metadata.FromIncomingContext(ctx)
	// if !ok {
	//	return nil, errMissingMetadata
	// }
	// if !valid(md["authorization"]) {
	//	return nil, errInvalidToken
	// }
	return handler(ctx, req)
}

func streamInterceptor(srv any, stream grpc.ServerStream, info *grpc.StreamServerInfo, handler grpc.StreamHandler) error {
	// authentication (token verification)
	// md, ok := metadata.FromIncomingContext(ss.Context())
	// if !ok {
	//	return errMissingMetadata
	// }
	// if !valid(md["authorization"]) {
	//	return errInvalidToken
	// }

	// err := handler(srv, newWrappedStream(ss))
	// if err != nil {
	//	logger("RPC failed with error: %v", err)
	// }
	// return err
	return handler(srv, stream)
}

func (s *Grpc) listen(addr string) (net.Listener, error) {
	switch {
	case strings.HasPrefix(addr, "unix://"):
		sock := addr[7:]
		if _, err := os.Stat(sock); err == nil || os.IsExist(err) {
			if err := os.Remove(sock); err != nil {
				return nil, err
			}
		}
		return net.Listen("unix", sock)
	case strings.HasPrefix(addr, "tcp://"):
		return net.Listen("tcp", addr[6:])
	default:
		return net.Listen("tcp", addr)
	}
}

func (s *Grpc) Use(opts ...grpc.ServerOption) {
	s.opts = append(s.opts, opts...)
}
