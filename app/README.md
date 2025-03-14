# maple_file

- ffi
  ```
  dart run ffigen
  ```

- freezed
  ```
  dart run build_runner build
  ```

- launcher icon
  ```
  dart run flutter_launcher_icons && rm -r android/app/src/main/res/mipmap-anydpi-v26
  ```

- launcher screen
  ```
  dart run flutter_native_splash:create
  ```

- build
  ```
  flutter build apk --no-tree-shake-icons --split-per-abi
  ```
  
- i18n
  ```
  dart run _script/extract_tr.dart 
  ```