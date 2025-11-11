# Firebase Phone Auth - Temporarily Disabled

## ✅ Changes Made

Firebase phone authentication has been **commented out** temporarily because APNs (Apple Push Notification Service) key is not purchased yet.

## 🔄 Current Implementation

### Login Flow (Using Backend OTP)
1. User enters phone number
2. App calls backend `/auth/login` endpoint (without OTP)
3. Backend generates OTP and logs it to console
4. User sees OTP in backend console logs
5. User enters OTP in app
6. App calls backend `/auth/login` endpoint (with OTP)
7. Backend verifies OTP and returns JWT token
8. User is logged in ✅

### Signup Flow (Direct Registration)
1. User fills signup form
2. App calls backend `/auth/register` endpoint directly
3. Backend creates user account
4. User is registered ✅

**Note:** Signup doesn't use OTP - it registers directly.

## 📋 Files Modified

1. **`lib/features/auth/presentation/screens/signup_screen.dart`**
   - Firebase phone auth commented out
   - Now uses direct backend registration

2. **`lib/features/auth/presentation/screens/login_screen.dart`**
   - Firebase phone auth commented out
   - Now uses backend OTP flow

3. **`lib/features/auth/presentation/screens/otp_verification_screen.dart`**
   - Firebase OTP verification commented out
   - Now uses backend OTP verification

## 🔍 How to Get OTP Code

### For Login:
1. Enter phone number in app
2. Check your **backend server console** for the OTP code
3. Look for this log:
   ```
   🔐 BACKEND OTP GENERATED
   🔑 OTP CODE: 123456
   ```
4. Enter the OTP code in the app

### For Signup:
- No OTP needed - registration happens directly

## 🔄 To Re-enable Firebase (When APNs Key is Purchased)

1. **Uncomment Firebase code** in:
   - `signup_screen.dart` (lines ~99-134)
   - `login_screen.dart` (lines ~246-394)
   - `otp_verification_screen.dart` (lines ~78-86)

2. **Comment out backend OTP code** in the same files

3. **Set up APNs:**
   - Get Apple Developer account
   - Create APNs key in Apple Developer Portal
   - Upload to Firebase Console → Project Settings → Cloud Messaging

4. **Test with real phone numbers**

## 📝 Notes

- All Firebase code is preserved in comments
- Easy to re-enable when APNs is configured
- Backend OTP works immediately (no setup needed)
- OTP is logged to backend console in development mode

## ✅ Current Status

- ✅ Login: Uses backend OTP (OTP in console)
- ✅ Signup: Direct registration (no OTP)
- ⏸️ Firebase: Commented out (waiting for APNs)

