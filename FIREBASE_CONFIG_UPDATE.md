# Firebase Configuration Update - December 2024

## ✅ What Was Updated

### iOS Configuration (Production)
- **File**: `ios/config/prod/GoogleService-Info.plist`
- **Updated**: API_KEY, GCM_SENDER_ID, GOOGLE_APP_ID, and other values from the new configuration
- **Status**: ✅ Updated with new values

### Android Configuration (Production)
- **File**: `packages/bakery_app/android/app/src/prod/google-services.json`
- **Updated**: Complete configuration with new API key and project settings
- **Status**: ✅ Updated with new values

---

## ⚠️ Critical Issue: Missing OAuth Client IDs

### The Problem

The `GoogleService-Info.plist` file you provided is **missing OAuth Client IDs**, which are **required** for Firebase Phone Authentication on iOS. The file currently has placeholder values:

```xml
<key>CLIENT_ID</key>
<string>730976050706-PLACEHOLDER.apps.googleusercontent.com</string>
<key>REVERSED_CLIENT_ID</key>
<string>com.googleusercontent.apps.730976050706-PLACEHOLDER</string>
```

**This is why you're still getting the `internal-error`** when trying to use phone authentication.

---

## 🔧 How to Fix the Internal Error

### Option 1: Use Test Phone Numbers (Quick Fix - Recommended for Development)

**No configuration changes needed!** Just use Firebase test phone numbers:

1. **Go to Firebase Console:**
   - https://console.firebase.google.com/
   - Select project: **khubzati-2e760**

2. **Add Test Phone Number:**
   - Navigate to: **Authentication** → **Sign-in method** → **Phone**
   - Scroll to: **"Phone numbers for testing"**
   - Click **"Add phone number"**
   - Add:
     ```
     Phone: +16505553434
     Code: 123456
     ```
   - Click **Save**

3. **Test in Your App:**
   - Run: `flutter run --flavor prod -t lib/main.dart`
   - Enter phone: `+16505553434`
   - Enter OTP: `123456`
   - ✅ **No SMS will be sent** - it will authenticate instantly!
   - ✅ **No APNs setup needed** for test numbers!

**Pros:**
- ✅ Works immediately (5 minutes to set up)
- ✅ Free - no SMS costs
- ✅ No Apple Developer account needed
- ✅ No APNs/OAuth setup required
- ✅ Perfect for development

---

### Option 2: Complete Production Setup (For Real Phone Numbers)

To fix the `internal-error` for real phone numbers, you need to:

#### Step 1: Create OAuth 2.0 Client ID

1. **Go to Google Cloud Console:**
   - https://console.cloud.google.com/
   - Select project: **khubzati-2e760**

2. **Navigate to APIs & Services → Credentials**

3. **Create OAuth 2.0 Client ID:**
   - Click **"Create Credentials"** → **"OAuth client ID"**
   - Application type: **iOS**
   - Name: `Khubzati iOS Client`
   - Bundle ID: `com.khubzati.app`
   - Click **Create**

4. **Copy the Client ID** (it will look like: `730976050706-xxxxxxxxxxxx.apps.googleusercontent.com`)

#### Step 2: Update GoogleService-Info.plist

1. **Download the complete plist from Firebase Console:**
   - Go to Firebase Console → Project Settings
   - Select your iOS app
   - Click **"Download GoogleService-Info.plist"**
   - This should now include the real OAuth Client IDs

2. **Replace the file:**
   ```bash
   cp ~/Downloads/GoogleService-Info.plist ios/config/prod/GoogleService-Info.plist
   ```

3. **Verify it has real CLIENT_ID values** (not PLACEHOLDER)

#### Step 3: Set Up APNs (Apple Push Notification Service)

Firebase Phone Auth on iOS requires APNs for SMS delivery:

1. **Get APNs Key from Apple Developer:**
   - Go to: https://developer.apple.com/account/resources/authkeys/list
   - Click **"+"** to create a new key
   - Name: `Firebase APNs Key`
   - Enable **Apple Push Notifications service (APNs)**
   - Click **Continue** → **Register**
   - **Download the .p8 file** (you can only download it once!)

2. **Upload to Firebase:**
   - Go to Firebase Console → Project Settings → **Cloud Messaging** tab
   - Scroll to **"Apple app configuration"**
   - Under **APNs Authentication Key**, click **Upload**
   - Upload your `.p8` file
   - Enter the **Key ID** (from Apple Developer)
   - Enter your **Team ID** (from Apple Developer)

**Note**: This requires an Apple Developer account ($99/year)

---

## 📋 Current Configuration Status

| Platform | Config File | Status | OAuth IDs | APNs | Phone Auth |
|----------|-------------|--------|-----------|------|------------|
| **iOS (prod)** | `ios/config/prod/GoogleService-Info.plist` | ✅ Updated | ⚠️ Placeholder | ❌ Not set | ⚠️ Test numbers only |
| **Android (prod)** | `packages/bakery_app/android/app/src/prod/google-services.json` | ✅ Updated | N/A | N/A | ✅ Should work |

---

## 🧪 Testing

### Test with Test Phone Number (Works Now)
```bash
flutter run --flavor prod -t lib/main.dart
```
- Use: `+16505553434` with code `123456`
- ✅ Works immediately

### Test with Real Phone Number (Needs OAuth Setup)
```bash
flutter run --flavor prod -t lib/main.dart
```
- Use: `+962777777777` (your real number)
- ❌ Will fail with `internal-error` until OAuth IDs are configured

---

## 📝 Next Steps

1. **For immediate testing**: Use test phone numbers (Option 1 above)
2. **For production**: Complete OAuth and APNs setup (Option 2 above)
3. **After OAuth setup**: Download the complete `GoogleService-Info.plist` from Firebase Console and replace the current file

---

## 🔍 Verification

To verify your configuration is complete:

1. **Check iOS plist:**
   ```bash
   grep CLIENT_ID ios/config/prod/GoogleService-Info.plist
   ```
   - Should show real values (not PLACEHOLDER)

2. **Check Firebase Console:**
   - Project Settings → Cloud Messaging → APNs should show your key

3. **Test with real phone number:**
   - Should receive SMS (not fail with internal-error)

---

## 📚 Related Documentation

- `FIREBASE_CONFIG_STATUS.md` - Previous configuration status
- `FIREBASE_PHONE_AUTH_SETUP.md` - Phone auth setup guide
- `HOW_TO_DOWNLOAD_COMPLETE_GOOGLESERVICE_PLIST.md` - How to get complete plist

