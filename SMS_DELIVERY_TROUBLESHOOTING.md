# SMS Delivery Troubleshooting Guide

## 🔍 Issue: Verification ID Received But No SMS

If you're seeing a verification ID in the logs but not receiving SMS on your phone, this guide will help you troubleshoot.

---

## ✅ What's Working

- ✅ Firebase accepted your phone number
- ✅ Verification ID was generated
- ✅ Request was sent to Firebase

## ❌ What's Not Working

- ❌ SMS not delivered to your phone

---

## 📱 Platform-Specific Issues

### iOS (Most Common Issue)

**On iOS, Firebase Phone Auth uses APNs (Apple Push Notification Service) instead of SMS.**

#### If APNs is NOT configured:
- Firebase will attempt to send SMS as fallback
- SMS delivery is **unreliable** and often fails
- You may not receive the SMS at all

#### If APNs IS configured:
- Firebase uses **silent push notifications** to deliver the code
- The code is delivered via push notification (not SMS)
- You won't see an SMS, but the code should be received automatically
- Check your device's notification settings

#### Solution for iOS:

1. **Check APNs Configuration:**
   - Go to Firebase Console → Project Settings → Cloud Messaging
   - Check if APNs Authentication Key is uploaded
   - If not, see `FIREBASE_CONFIG_UPDATE.md` for setup instructions

2. **Check Notification Permissions:**
   - iOS Settings → Your App → Notifications
   - Ensure notifications are enabled

3. **Use Test Phone Numbers (Quick Fix):**
   - Go to Firebase Console → Authentication → Phone → "Phone numbers for testing"
   - Add: `+16505553434` with code `123456`
   - Use this number in your app (no SMS needed)

---

### Android

**On Android, Firebase sends SMS directly via carrier.**

#### Common Issues:

1. **SMS Quota Exceeded:**
   - Firebase has daily SMS limits
   - Check Firebase Console → Usage and Billing
   - Wait 24 hours or upgrade plan

2. **Carrier Blocking:**
   - Some carriers block automated SMS
   - Contact your carrier to whitelist Firebase numbers
   - Try a different carrier/network

3. **Phone Number Format:**
   - Ensure number is in E.164 format: `+962798913567`
   - Remove spaces, dashes, or parentheses

4. **Network Issues:**
   - Check signal strength
   - Try switching between WiFi and mobile data
   - Restart your device

5. **Jordan (+962) Not Enabled:**
   - Go to Firebase Console → Authentication → Settings
   - Check if Jordan is in allowed countries list
   - Enable it if not already enabled

---

## 🔧 Troubleshooting Steps

### Step 1: Verify Phone Number Format

Your phone number should be:
- ✅ Format: `+962798913567` (E.164 format)
- ❌ Wrong: `0798913567`, `962798913567`, `+962 798 913 567`

### Step 2: Check Firebase Console

1. **Go to Firebase Console:**
   - https://console.firebase.google.com/
   - Select project: **khubzati-2e760**

2. **Check Authentication Settings:**
   - Authentication → Settings → Phone numbers
   - Verify Jordan (+962) is enabled
   - Check SMS quota/usage

3. **Check Cloud Messaging (iOS):**
   - Project Settings → Cloud Messaging
   - Verify APNs is configured (for iOS)

### Step 3: Test with Test Phone Number

**Quick test without SMS:**

1. **Add Test Number in Firebase:**
   - Authentication → Phone → "Phone numbers for testing"
   - Add: `+16505553434` with code `123456`

2. **Use in App:**
   - Enter: `+16505553434`
   - Enter OTP: `123456`
   - ✅ Works immediately (no SMS sent)

### Step 4: Check Device Settings

**iOS:**
- Settings → Your App → Notifications → Enable
- Settings → Your App → Background App Refresh → Enable

**Android:**
- Settings → Apps → Your App → Notifications → Enable
- Settings → Apps → Your App → Permissions → SMS (if needed)

### Step 5: Try Resending

1. Click "Resend OTP" in the app
2. Wait 1-2 minutes
3. Check spam/junk folder (some carriers filter automated SMS)

### Step 6: Check Firebase Logs

1. **Firebase Console → Authentication → Users**
2. Check if verification attempts are logged
3. Look for error messages or blocked attempts

---

## 🚨 Common Error Codes

| Error Code | Meaning | Solution |
|------------|---------|----------|
| `quota-exceeded` | Daily SMS limit reached | Wait 24 hours or upgrade plan |
| `invalid-phone-number` | Wrong format | Use E.164 format: `+962798913567` |
| `operation-not-allowed` | Country not enabled | Enable Jordan in Firebase Console |
| `too-many-requests` | Too many attempts | Wait 15-30 minutes |
| `internal-error` | Configuration issue | Check APNs (iOS) or Firebase config |

---

## 💡 Quick Solutions

### Solution 1: Use Test Phone Number (Recommended for Development)

**No configuration needed!**

1. Add test number in Firebase Console
2. Use `+16505553434` with code `123456`
3. Works immediately, no SMS needed

### Solution 2: Check APNs (iOS Only)

1. Go to Firebase Console → Project Settings → Cloud Messaging
2. Upload APNs Authentication Key (see `FIREBASE_CONFIG_UPDATE.md`)
3. Rebuild app and try again

### Solution 3: Enable Jordan in Firebase

1. Firebase Console → Authentication → Settings
2. Phone numbers tab
3. Enable "Jordan (+962)"
4. Save and retry

### Solution 4: Wait and Retry

- SMS delivery can take 1-5 minutes
- Wait a few minutes before retrying
- Don't request multiple codes rapidly

---

## 📞 Still Not Working?

### Check These:

1. **Phone Number Correct?**
   - Double-check: `+962798913567`
   - Remove any spaces or dashes

2. **Device Has Signal?**
   - Check signal strength
   - Try different location

3. **Carrier Blocking?**
   - Some carriers block automated SMS
   - Contact carrier support

4. **Firebase Quota?**
   - Check Firebase Console → Usage
   - Free tier has limits

5. **APNs Configured? (iOS)**
   - Required for iOS phone auth
   - See `FIREBASE_CONFIG_UPDATE.md`

---

## 📚 Related Documentation

- `FIREBASE_CONFIG_UPDATE.md` - Complete Firebase setup guide
- `FIREBASE_PHONE_AUTH_SETUP.md` - Phone auth setup
- `FIREBASE_CONFIG_STATUS.md` - Configuration status

---

## 🎯 Next Steps

1. **For Development:** Use test phone numbers (works immediately)
2. **For Production:** Complete APNs setup (iOS) or verify carrier settings (Android)
3. **Check Firebase Console:** Verify all settings are correct
4. **Contact Support:** If issue persists after trying all steps

---

## ✅ Verification Checklist

- [ ] Phone number in E.164 format: `+962798913567`
- [ ] Jordan (+962) enabled in Firebase Console
- [ ] APNs configured (iOS) or carrier settings checked (Android)
- [ ] Test phone number added for quick testing
- [ ] Device has signal and notifications enabled
- [ ] Waited 1-2 minutes for SMS delivery
- [ ] Tried resending OTP code

