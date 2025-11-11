# 🚀 Quick Start - Firebase Phone Auth

## ✅ What's Working Now

Your app should now build successfully! The Firebase module conflict has been fixed.

---

## ⚡ Setup Required (10 Minutes)

### For iOS (Test Numbers Only)

1. Open: https://console.firebase.google.com/
2. Select: **khubzati-dev-131af**
3. Go to: **Authentication** → **Sign-in method** → **Phone**
4. Scroll to: **"Phone numbers for testing"**
5. Add:
   ```
   Phone: +16505553434
   Code: 123456
   ```
6. Click **Save**

### For Android (Real SMS)

Add your SHA-1 fingerprint to Firebase:

#### Your SHA-1:
```
D8:E8:F8:0B:81:87:30:31:12:BF:8D:C2:3A:A9:04:B7:D5:C0:C7:14
```

#### Steps:
1. Go to: https://console.firebase.google.com/
2. Select: **khubzati-dev-131af**
3. Click gear icon → **Project Settings**
4. Scroll to: **Your apps** → Android app (`com.khubzati.app.dev`)
5. Scroll to: **"SHA certificate fingerprints"**
6. Click: **"Add fingerprint"**
7. Paste the SHA-1 above
8. Click **Save**

**Full guide:** `ANDROID_SHA_FINGERPRINTS.md`

---

## 🧪 Test Your Setup

### On iOS (Test Number)
```bash
flutter run --flavor dev -t lib/main_dev.dart
```

- Enter: `+16505553434`
- OTP: `123456`
- ✅ Authentication succeeds!

### On Android (Real Phone)
```bash
# List devices
flutter devices

# Run on Android
flutter run --flavor dev -t lib/main_dev.dart -d <android-device-id>
```

- Enter your real phone number (e.g., `+962777777777`)
- You'll receive a real SMS with OTP code
- Enter the code
- ✅ Authentication succeeds!

---

## 📱 Platform Status

| Platform | Build Status | Auth Status | Setup Required |
|----------|--------------|-------------|----------------|
| **iOS** | ✅ Fixed | ⚠️ Use test numbers | Add test number in Firebase |
| **Android** | ✅ Ready | ⚠️ Pending | Add SHA-1 fingerprint |

---

## 🔧 Common Commands

### Run on iOS
```bash
flutter run --flavor dev -t lib/main_dev.dart
```

### Run on Android
```bash
flutter run --flavor dev -t lib/main_dev.dart -d <android-device-id>
```

### List Available Devices
```bash
flutter devices
```

### Clean Build
```bash
flutter clean && flutter pub get
cd ios && export LANG=en_US.UTF-8 && pod install && cd ..
```

### Get Android SHA Fingerprints
```bash
keytool -list -v -keystore ~/.android/debug.keystore -alias androiddebugkey -storepass android -keypass android | grep -E "(SHA1|SHA256)"
```

---

## 📚 Documentation Files

### Setup Guides
- **ANDROID_SHA_FINGERPRINTS.md** - Android SHA-1 setup (NEW!)
- **README_FIREBASE_AUTH.md** - Complete overview
- **FIREBASE_AUTH_SETUP_COMPLETE.md** - Detailed troubleshooting

### Helper Scripts
- **verify_firebase_config.sh** - Check Firebase config
- **install_firebase_config.sh** - Install config files

---

## 🆘 Quick Troubleshooting

### iOS: "internal-error"
**Fix:** Add test phone number in Firebase Console (see above)

### Android: "app-not-authorized"  
**Fix:** Add SHA-1 fingerprint to Firebase Console (see above)

### Build Errors
```bash
flutter clean
cd ios && rm -rf Pods Podfile.lock && cd ..
flutter pub get
cd ios && export LANG=en_US.UTF-8 && pod install && cd ..
```

---

## ✅ Checklist

- [x] App builds successfully
- [ ] **iOS:** Test phone number added in Firebase
- [ ] **Android:** SHA-1 fingerprint added in Firebase
- [ ] Authentication tested and working
- [ ] Ready to develop!

---

**Complete both setups above and you're ready to go!** 🎉

