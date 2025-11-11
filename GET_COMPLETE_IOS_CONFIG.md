# How to Get Complete iOS Firebase Configuration

## 🚨 Current Problem

Your `GoogleService-Info.plist` is **incomplete** and missing critical OAuth client credentials needed for Firebase Phone Authentication on iOS.

### Missing Fields:
- ❌ `CLIENT_ID` (currently has PLACEHOLDER value)
- ❌ `REVERSED_CLIENT_ID` (currently has PLACEHOLDER value)

This is causing the `internal-error` you're seeing.

---

## 📋 Solution: Download Complete Config File

### Option A: Download from Firebase Console (Quickest)

1. **Go to Firebase Console:**
   - Open: https://console.firebase.google.com/
   - Select project: **khubzati-dev-131af**

2. **Navigate to Project Settings:**
   - Click the gear icon (⚙️) next to "Project Overview"
   - Click **"Project settings"**

3. **Find Your iOS App:**
   - Scroll down to **"Your apps"** section
   - Find app with bundle ID: `com.khubzati.app.dev`
   - If the app doesn't exist, click **"Add app"** → **iOS** and register it

4. **Download the Config File:**
   - Click the **"GoogleService-Info.plist"** download button
   - Save it to your Downloads folder

5. **Verify the File is Complete:**
   - Open the downloaded file in a text editor
   - Check for these keys (they MUST have real values, not PLACEHOLDER):
     ```xml
     <key>CLIENT_ID</key>
     <string>19603541521-XXXXXX.apps.googleusercontent.com</string>
     <key>REVERSED_CLIENT_ID</key>
     <string>com.googleusercontent.apps.19603541521-XXXXXX</string>
     ```

---

### Option B: If CLIENT_ID is Still Missing

If the downloaded file still doesn't have `CLIENT_ID`, you need to create OAuth credentials:

1. **Go to Google Cloud Console:**
   - Open: https://console.cloud.google.com/
   - Make sure **khubzati-dev-131af** project is selected

2. **Navigate to API Credentials:**
   - Menu → **APIs & Services** → **Credentials**
   - Or direct link: https://console.cloud.google.com/apis/credentials

3. **Create OAuth 2.0 Client ID:**
   - Click **"+ CREATE CREDENTIALS"** → **"OAuth client ID"**
   - Application type: **iOS**
   - Name: `Khubzati iOS Dev`
   - Bundle ID: `com.khubzati.app.dev`
   - Click **"CREATE"**

4. **Download Updated Config:**
   - Go back to Firebase Console
   - Download the `GoogleService-Info.plist` again (it should now include CLIENT_ID)

---

## 📱 After Getting the Complete File

Once you have the complete `GoogleService-Info.plist` with real CLIENT_ID values:

### Run this command to check if it's complete:

```bash
# Check if the file has the required fields
grep -E "(CLIENT_ID|REVERSED_CLIENT_ID)" /Users/user/Downloads/GoogleService-Info.plist
```

If you see actual values (not PLACEHOLDER), then run:

```bash
# Copy to dev flavor directory
cp /Users/user/Downloads/GoogleService-Info.plist /Users/user/.cursor/worktrees/khubzati/EBrqV/ios/config/dev/GoogleService-Info.plist

# Also copy to Runner directory for Xcode
cp /Users/user/Downloads/GoogleService-Info.plist /Users/user/.cursor/worktrees/khubzati/EBrqV/ios/Runner/GoogleService-Info.plist
```

---

## 🧪 Alternative: Use Test Phone Numbers (No APNs Needed)

If you just want to test quickly without fixing the OAuth issue, use Firebase test phone numbers:

1. **Go to Firebase Console** → **Authentication** → **Sign-in method** → **Phone**
2. Scroll to **"Phone numbers for testing"**
3. Add a test number:
   ```
   Phone: +16505553434
   Code: 123456
   ```
4. In your app, use this test number - you'll always enter `123456` as OTP
5. **No real SMS will be sent** and **no APNs setup needed**

This is perfect for development!

---

## ✅ How to Verify It's Fixed

After updating the file, run your app again:

```bash
flutter clean
flutter pub get
cd ios && pod install && cd ..
flutter run --flavor dev -t lib/main_dev.dart
```

The `internal-error` should be gone! 🎉

---

## 📚 References

- [Firebase iOS Setup](https://firebase.google.com/docs/ios/setup)
- [Firebase Phone Auth iOS](https://firebase.google.com/docs/auth/flutter/phone-auth)
- [OAuth Client Setup](https://support.google.com/cloud/answer/6158849)

---

**Need help?** The complete `GoogleService-Info.plist` should be ~50-60 lines and include all these keys:
- ✅ API_KEY
- ✅ GCM_SENDER_ID
- ✅ BUNDLE_ID
- ✅ PROJECT_ID
- ✅ STORAGE_BUCKET
- ✅ GOOGLE_APP_ID
- ✅ **CLIENT_ID** ← This is crucial!
- ✅ **REVERSED_CLIENT_ID** ← This too!
- ✅ DATABASE_URL (if using Realtime Database)

