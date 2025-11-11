# Enable SMS Verification for Jordan (+962) in Firebase Console

This guide explains how to enable SMS phone authentication for Jordan in Firebase Console.

## Problem

When trying to verify phone numbers from Jordan (+962), you may encounter this error:
```
operation-not-allowed - SMS unable to be sent until this region enabled by the app developer.
```

## Solution: Enable Jordan in Firebase Console

### Step 1: Access Firebase Console

1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Select your project (e.g., `khubzati-dev-131af` for dev, `khubzati-2e760` for prod)

### Step 2: Navigate to Authentication Settings

1. Click on **Authentication** in the left sidebar
2. Click on the **Settings** tab (gear icon)
3. Scroll down to find **Phone numbers** section

### Step 3: Enable Jordan (+962)

1. In the **Phone numbers** section, look for **Allowed countries/regions**
2. Click on **Add country/region** or **Edit** if countries are already listed
3. Search for **Jordan** or **+962**
4. Check the box next to **Jordan (+962)**
5. Click **Save** or **Done**

### Step 4: Verify Configuration

1. The country should now appear in your allowed list
2. Wait a few minutes for changes to propagate
3. Try verifying a Jordan phone number again

## Alternative: Use Test Phone Numbers (Development Only)

For development and testing, you can use Firebase test phone numbers that work without region enablement:

### Test Phone Numbers
- Format: `+1 650-555-XXXX` (any XXXX)
- Examples:
  - `+16505553434`
  - `+16505551234`
  - `+16505559999`

### Test Verification Code
- **Always use**: `123456` for any test phone number

### How to Use Test Numbers

1. Enter any test phone number (e.g., `+16505553434`)
2. Request OTP
3. Enter the code: `123456`
4. Verification will succeed without sending actual SMS

**Note**: Test numbers only work in development/test environments, not in production.

## Project-Specific Configuration

### Development Environment
- **Project ID**: `khubzati-dev-131af`
- **Firebase Console**: [khubzati-dev-131af](https://console.firebase.google.com/project/khubzati-dev-131af)

### Staging Environment
- **Project ID**: `khubzati-staging` (check your Firebase Console)
- Configure similarly to dev

### Production Environment
- **Project ID**: `khubzati-2e760`
- **Firebase Console**: [khubzati-2e760](https://console.firebase.google.com/project/khubzati-2e760)
- **Important**: Enable Jordan in production before going live

## Troubleshooting

### Issue: Changes not taking effect
- **Solution**: Wait 5-10 minutes for Firebase to propagate changes
- Clear app cache and try again

### Issue: Still getting "operation-not-allowed"
- **Solution**: 
  1. Double-check that Jordan is enabled in the correct Firebase project
  2. Verify you're using the correct Firebase configuration for your flavor (dev/stage/prod)
  3. Check that the phone number is in correct E.164 format: `+9627XXXXXXXX`

### Issue: SMS not being received
- **Solution**:
  1. Verify the phone number format is correct
  2. Check Firebase Console → Authentication → Usage tab for quota limits
  3. Ensure you haven't exceeded daily SMS limits

## Code Implementation

The app now includes:
- ✅ Automatic phone number formatting for Jordan
- ✅ Support for Firebase test phone numbers
- ✅ User-friendly error messages with instructions
- ✅ Helper utility (`FirebasePhoneHelper`) for phone number handling

## Additional Resources

- [Firebase Phone Authentication Documentation](https://firebase.google.com/docs/auth/android/phone-auth)
- [Firebase Test Phone Numbers](https://firebase.google.com/docs/auth/android/phone-auth#test-with-phone-numbers)
- [Country Code Support](https://firebase.google.com/support/guides/phone-auth#country-support)

## Support

If you continue to experience issues after enabling Jordan in Firebase Console:
1. Check Firebase Console → Authentication → Usage for any errors
2. Verify your Firebase project billing is active (required for SMS)
3. Contact Firebase support if the issue persists

