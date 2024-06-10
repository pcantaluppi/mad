# Build and release Android app

Sign the app:

- Create an upload keystore

```Shell
keytool -genkey -v -keystore %userprofile%\upload-keystore.jks -storetype JKS -keyalg RSA -keysize 2048 -validity 10000 -alias upload
```

- Build the Release APK

```Shell
flutter build apk --split-per-abi
```

- Build the App Bundle

```Shell
flutter build appbundle --release
```
