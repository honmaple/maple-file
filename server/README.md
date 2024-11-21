
## Android
```
gomobile bind -ldflags="-w -s" -o ../app/android/app/libs/server.aar -target=android -androidapi 21 -javapkg="com.honmaple.maple_file" github.com/honmaple/maple-file/server/cmd/mobile
```

## MacOS
```
go build -ldflags="-w -s" -buildmode=c-shared -o _tmp/output/libserver.dylib github.com/honmaple/maple-file/server/cmd/desktop
cp _tmp/output/libserver.h ../app/include/
cp _tmp/output/libserver.dylib ../app/macos/Frameworks/
```

## Linux
```
go build -tags nosqlite -ldflags="-w -s" -buildmode=c-shared -o libserver.so github.com/honmaple/maple-file/server/cmd/desktop
```



