
## Android
```
gomobile bind -ldflags="-w -s" -o ../app/android/app/libs/libserver.aar -target=android -androidapi 21 -javapkg="com.honmaple.maple_file" github.com/honmaple/maple-file/server/cmd/mobile
```

## IOS
```
gomobile bind -ldflags="-w -s" -o ../app/ios/Frameworks/libserver.xcframework -target=ios github.com/honmaple/maple-file/server/cmd/mobile
```

## MacOS
```
go build -ldflags="-w -s" -buildmode=c-shared -o ../app/macos/Frameworks/libserver.dylib github.com/honmaple/maple-file/server/cmd/desktop
```

## Windows
```
set CGO_ENABLED=1
go build -ldflags="-w -s" -buildmode=c-shared -o ../app/windows/libserver.dll github.com/honmaple/maple-file/server/cmd/desktop
```

## Linux
```
go build -ldflags="-w -s" -buildmode=c-shared -o ../app/linux/libserver.so github.com/honmaple/maple-file/server/cmd/desktop
```



