@echo off
call flutter create --project-name zakat_sadqa --org com.zakat --platforms android .
call flutter pub get
call dart run flutter_launcher_icons
powershell -Command "(Get-Content android\app\src\main\AndroidManifest.xml) -replace 'android:label=\"[^\"]*\"','android:label=\"Zakat Sadqa\"' | Set-Content android\app\src\main\AndroidManifest.xml"
call flutter build apk --release
echo APK: build\app\outputs\flutter-apk\app-release.apk
pause
