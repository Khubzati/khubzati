# Firebase Phone Authentication Setup Guide

Firebase Phone Authentication has been **restored and enabled** in the app. You will receive **real SMS messages** on your phone.

## ✅ What's Already Done

1. **Firebase Configuration** - Added for iOS, Android, and Web
2. **iOS URL Schemes** - Configured in `ios/Runner/Info.plist`
3. **Authentication Flow** - Uses Firebase Phone Auth for SMS OTP

## 📱 For iOS (Current Platform)

### Issue: APNs Configuration Required

Firebase Phone Auth on iOS requires **APNs (Apple Push Notification Service)** setup. This is causing the "internal-error" you're seeing.

### Quick Fix Options:

#### Option 1: Test on Android Instead
Android doesn't require APNs - it uses FCM which is easier to set up.

```bash
flutter run -d [your-android-device]
```

#### Option 2: Set Up APNs for iOS (Production)

Follow these steps in Firebase Console:

1. Go to **Firebase Console** → Your Project → **Project Settings**
2. Select **Cloud Messaging** tab
3. Scroll to **Apple app configuration**
4. Upload your **APNs Authentication Key** or **APNs Certificate**

To get APNs credentials:
1. Go to **Apple Developer Account** → **Certificates, Identifiers & Profiles**
2. Create an **APNs Key** or **Certificate**
3. Download and upload to Firebase

**Note**: This requires an Apple Developer account ($99/year)

#### Option 3: Development Workaround (iOS Simulator)

For iOS Simulator testing, you can skip APNs by using **Firebase Test Mode**:

1. In Firebase Console → **Authentication** → **Sign-in method** → **Phone**
2. Add **test phone numbers** with fixed OTP codes
3. Example:
   - Phone: `+1 650-555-3434`
   - Code: `123456`

Then use these test numbers in your app - no SMS will be sent.

## 🌐 For Web Support

### Setup Required:

1. **Enable Web Support**:
```bash
flutter create . --platforms=web
```

2. **Add reCAPTCHA Container** in `web/index.html`:
```html
<body>
  <div id="recaptcha-container"></div>
  <script src="main.dart.js" type="application/javascript"></script>
</body>
```

3. **Initialize reCAPTCHA** in login screen before calling `verifyPhoneNumber`:
```dart
// Add this before FirebaseAuth.instance.verifyPhoneNumber
if (kIsWeb) {
  await FirebaseAuth.instance.setSettings(
    appVerificationDisabledForTesting: false,
  );
}
```

4. **Configure Domain** in Firebase Console:
   - Go to **Authentication** → **Settings** → **Authorized domains**
   - Add `localhost` for development

## 🤖 For Android

Android should work out of the box! Just run:

```bash
flutter run -d [your-android-device]
```

Make sure:
1. Google Play Services is installed on device
2. SHA-1/SHA-256 fingerprints are added to Firebase Console

To get SHA keys:
```bash
cd android
./gradlew signingReport
```

## 📋 Current Configuration Status

| Platform | Status | SMS Delivery | Notes |
|----------|--------|--------------|-------|
| **iOS** | ⚠️ Needs APNs | ✅ Real SMS | Requires Apple Developer account |
| **Android** | ✅ Ready | ✅ Real SMS | Should work immediately |
| **Web** | ⚠️ Not configured | ✅ Real SMS | Needs reCAPTCHA setup |

## 🧪 Testing

### Test Phone Numbers (Free - No SMS)

In Firebase Console, add test numbers for development:

1. **Firebase Console** → **Authentication** → **Phone**
2. Click **Phone numbers for testing**
3. Add:
   ```
   +1 650-555-3434 → 123456
   +962 7 7777 7777 → 123456
   ```

### Real Phone Numbers

Use your actual Jordanian phone numbers:
- Format: `+962 7X XXX XXXX`
- Example: `+962 777777777`

You'll receive real SMS from Firebase!

## 🔍 Debug Tips

Check terminal logs for:
```
DEBUG: Login - Formatted phone number for Firebase: +962XXXXXXXXX
DEBUG: Firebase verification failed: [error-code] - [error-message]
```

Common errors:
- `internal-error`: APNs not configured (iOS)
- `invalid-phone-number`: Wrong format
- `quota-exceeded`: Too many SMS sent
- `app-not-authorized`: Firebase configuration issue

## 💡 Recommended Next Steps

1. **For Quick Testing**: Use Android device or iOS test numbers
2. **For Production**: Set up APNs certificates
3. **For Web**: Add web platform and reCAPTCHA

## 📞 Need Help?

- [Firebase Phone Auth Docs](https://firebase.google.com/docs/auth/flutter/phone-auth)
- [APNs Setup Guide](https://firebase.google.com/docs/cloud-messaging/ios/client#upload_your_apns_authentication_key)
