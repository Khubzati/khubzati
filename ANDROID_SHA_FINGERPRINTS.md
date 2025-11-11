# Android SHA Fingerprints for Firebase

## 🔑 Your Debug Keystore Fingerprints

### SHA-1 (Required for Phone Auth)
```
D8:E8:F8:0B:81:87:30:31:12:BF:8D:C2:3A:A9:04:B7:D5:C0:C7:14
```

### SHA-256 (Recommended)
```
84:1F:C4:C1:65:D0:54:56:56:E7:51:A5:43:A1:D4:CE:02:05:16:A2:8F:CE:55:5D:ED:26:A4:2A:47:07:37:1E
```

---

## 📱 How to Add to Firebase Console

### Step 1: Open Firebase Console

1. Go to: https://console.firebase.google.com/
2. Select project: **khubzati-dev-131af**
3. Click the gear icon (⚙️) → **Project settings**

### Step 2: Find Your Android App

1. Scroll down to **"Your apps"** section
2. Find your Android app with package name: `com.khubzati.app.dev`
3. If it doesn't exist, click **"Add app"** → **Android** to register it

### Step 3: Add SHA Fingerprints

1. In your Android app card, scroll to **"SHA certificate fingerprints"**
2. Click **"Add fingerprint"**
3. Paste your **SHA-1** fingerprint:
   ```
   D8:E8:F8:0B:81:87:30:31:12:BF:8D:C2:3A:A9:04:B7:D5:C0:C7:14
   ```
4. Click **"Save"**
5. Click **"Add fingerprint"** again
6. Paste your **SHA-256** fingerprint:
   ```
   84:1F:C4:C1:65:D0:54:56:56:E7:51:A5:43:A1:D4:CE:02:05:16:A2:8F:CE:55:5D:ED:26:A4:2A:47:07:37:1E
   ```
7. Click **"Save"**

### Step 4: Download Updated Config (Important!)

After adding the fingerprints:
1. Click **"Download google-services.json"** in your Android app card
2. The file should now be updated with OAuth credentials
3. **Replace** the existing file:
   ```bash
   cp ~/Downloads/google-services.json /Users/user/.cursor/worktrees/khubzati/EBrqV/android/app/google-services.json
   ```

### Step 5: Rebuild Your App

```bash
cd /Users/user/.cursor/worktrees/khubzati/EBrqV
flutter clean
flutter pub get
flutter run --flavor dev -t lib/main_dev.dart -d <android-device-id>
```

---

## 🏗️ For Production/Release Build

When you're ready to release your app, you'll need to add the **release keystore** fingerprints too.

### Generate Release Keystore (if you don't have one)

```bash
keytool -genkey -v -keystore ~/android-release-key.jks -keyalg RSA -keysize 2048 -validity 10000 -alias khubzati-release
```

### Get Release Fingerprints

```bash
keytool -list -v -keystore ~/android-release-key.jks -alias khubzati-release
```

Then add those fingerprints to Firebase Console the same way.

---

## 📋 Quick Command Reference

### Get Debug Fingerprints (Current)
```bash
keytool -list -v -keystore ~/.android/debug.keystore -alias androiddebugkey -storepass android -keypass android | grep -E "(SHA1|SHA256)"
```

### Get Release Fingerprints (Future)
```bash
keytool -list -v -keystore ~/path/to/your-release-key.jks -alias your-alias
```

---

## ✅ Verification

After adding the SHA fingerprints to Firebase:

1. The warning in Firebase Console should disappear
2. Phone authentication should work on Android devices
3. You should be able to receive real SMS messages

---

## 🆘 Troubleshooting

### "Phone authentication not working on Android"
**Check:**
1. SHA-1 fingerprint added to Firebase Console
2. google-services.json downloaded after adding SHA fingerprints
3. App rebuilt after updating google-services.json

### "Different SHA fingerprint on CI/CD"
**Solution:** Each build machine has its own debug keystore
- Get SHA fingerprints from your CI/CD environment
- Add all SHA fingerprints to Firebase Console
- Or use a shared release keystore

---

## 📚 References

- [Get SHA Certificate Fingerprint](https://developers.google.com/android/guides/client-auth)
- [Firebase Phone Auth - Android](https://firebase.google.com/docs/auth/android/phone-auth)
- [App Signing - Android](https://developer.android.com/studio/publish/app-signing)

---

**Your SHA fingerprints are ready to be added to Firebase!** 🎉

Follow the steps above to complete the Android setup.

