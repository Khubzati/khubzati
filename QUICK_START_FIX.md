# 🚀 Quick Fix - Get Your Login Working in 2 Minutes

## The Problem
Your app has **PLACEHOLDER** values in GoogleService-Info.plist, which causes Firebase authentication to fail.

## The Solution (AUTOMATED)

I've created an automated script that will:
1. ✅ Open Firebase Console for you
2. ✅ Guide you to download the correct file
3. ✅ Verify it's correct (no placeholders)
4. ✅ Install it in the right location
5. ✅ Clean and rebuild your project

## Run This Command

```bash
cd /Users/user/Documents/khubzati_flutter_project/khubzati
./fix_firebase_config.sh
```

## What to Do

1. **Run the script** (command above)

2. **Choose option 1** (STAGE - since you're testing with stage flavor)

3. **Firebase Console will open** automatically
   - Find your iOS app in "Your apps" section
   - Bundle ID: `com.khubzati.app.stage`
   - Click "GoogleService-Info.plist" button to download

4. **Press ENTER** after downloading
   - Script will automatically verify and install it

5. **Say YES** when asked to clean and rebuild

6. **Run the app:**
   ```bash
   flutter run --flavor stage -t lib/main_stage.dart
   ```

7. **Test login:**
   - Enter phone: +962777777777
   - Press login
   - You should receive SMS! 🎉

## That's It!

Total time: **~2 minutes**

The script handles everything automatically. Just download the file when prompted!

---

## Manual Alternative (If Script Doesn't Work)

If the script has issues, you can do it manually:

1. Go to: https://console.firebase.google.com/project/khubzati-stage-269cf/settings/general
2. Find iOS app with bundle ID: com.khubzati.app.stage
3. Click "GoogleService-Info.plist" to download
4. Replace file:
   ```bash
   cp ~/Downloads/GoogleService-Info.plist \
      /Users/user/Documents/khubzati_flutter_project/khubzati/ios/config/stage/GoogleService-Info.plist
   ```
5. Clean and rebuild:
   ```bash
   flutter clean
   cd ios && pod install && cd ..
   flutter run --flavor stage -t lib/main_stage.dart
   ```

---

## Expected Result

**Before Fix:**
```
[Login Screen]
❌ Error: Firebase configuration error...
```

**After Fix:**
```
[Login Screen]
✅ OTP sent! Check your messages
→ [OTP Screen]
```

---

**Ready? Run this now:**
```bash
cd /Users/user/Documents/khubzati_flutter_project/khubzati
./fix_firebase_config.sh
```


