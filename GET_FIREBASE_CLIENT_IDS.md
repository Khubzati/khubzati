# How to Get Firebase OAuth Client IDs

## Problem
Firebase Phone Authentication on iOS requires the OAuth `CLIENT_ID` and `REVERSED_CLIENT_ID` to be configured in your `GoogleService-Info.plist` files.

## Current Status
I've added placeholder values to your GoogleService-Info.plist files:
- `ios/config/dev/GoogleService-Info.plist`
- `ios/config/stage/GoogleService-Info.plist`
- `ios/config/prod/GoogleService-Info.plist`

## How to Get the Correct Values

### Option 1: Firebase Console (Easiest)

1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Select your project (khubzati-dev-131af, khubzati-stage-269cf, or khubzati-2e760)
3. Click on the gear icon ⚙️ → Project Settings
4. Scroll down to "Your apps" section
5. Click on your iOS app
6. Download the `GoogleService-Info.plist` file
7. Open the downloaded file and copy the `CLIENT_ID` and `REVERSED_CLIENT_ID` values

### Option 2: Google Cloud Console

1. Go to [Google Cloud Console](https://console.cloud.google.com/)
2. Select your Firebase project
3. Go to "APIs & Services" → "Credentials"
4. Look for "iOS client" (auto created by Google Service)
5. The Client ID will be in format: `XXXXX-YYYYYY.apps.googleusercontent.com`
6. The REVERSED_CLIENT_ID is: `com.googleusercontent.apps.XXXXX-YYYYYY`

### Update the Files

For each environment (dev, stage, prod), replace:
```xml
<key>CLIENT_ID</key>
<string>XXXXX-PLACEHOLDER.apps.googleusercontent.com</string>
<key>REVERSED_CLIENT_ID</key>
<string>com.googleusercontent.apps.XXXXX-PLACEHOLDER</string>
```

With the actual values from Firebase Console.

## Alternative: Re-download Using FlutterFire CLI

The easiest way is to use the FlutterFire CLI to regenerate all Firebase configuration files:

```bash
# Install FlutterFire CLI
dart pub global activate flutterfire_cli

# Configure Firebase for your project
flutterfire configure --project=khubzati-dev-131af --out=ios/config/dev/GoogleService-Info.plist --platforms=ios --ios-bundle-id=com.khubzati.app.dev

flutterfire configure --project=khubzati-stage-269cf --out=ios/config/stage/GoogleService-Info.plist --platforms=ios --ios-bundle-id=com.khubzati.app.stage

flutterfire configure --project=khubzati-2e760 --out=ios/config/prod/GoogleService-Info.plist --platforms=ios --ios-bundle-id=com.khubzati.app
```

## After Getting the Correct Values

1. Update the three GoogleService-Info.plist files with the correct CLIENT_ID values
2. Clean your build: `make clean-ios` or `flutter clean`
3. Rebuild the app: `make run-stage-ios` or `flutter run --flavor stage`

## Additional Requirement: APNs Configuration

Firebase Phone Authentication on iOS also requires Apple Push Notification service (APNs) to be configured:

1. Go to [Apple Developer Portal](https://developer.apple.com/account/)
2. Create an APNs Key or Certificate for your app
3. Upload it to Firebase Console:
   - Project Settings → Cloud Messaging → iOS app configuration
   - Upload your APNs Authentication Key (.p8 file) or APNs Certificate (.p12 file)

Without proper APNs configuration, phone authentication will fail on physical devices (it might work on simulator).

