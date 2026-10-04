#!/bin/bash
flutter create --project-name zakat_sadqa --org com.zakat --platforms android . || exit 1
flutter pub get
dart run flutter_launcher_icons
sed -i 's/android:label="[^"]*"/android:label="Zakat Sadqa"/' android/app/src/main/AndroidManifest.xml
flutter build apk --release
echo "APK: build/app/outputs/flutter-apk/app-release.apk"
