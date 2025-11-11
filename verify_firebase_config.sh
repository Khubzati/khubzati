#!/bin/bash

# Firebase Configuration Verification Script
# This script checks if your GoogleService-Info.plist has all required fields for Phone Auth

echo "🔍 Firebase iOS Configuration Verification"
echo "==========================================="
echo ""

# Check if file exists in Downloads
DOWNLOADS_FILE="/Users/user/Downloads/GoogleService-Info.plist"
DEV_FILE="/Users/user/.cursor/worktrees/khubzati/EBrqV/ios/config/dev/GoogleService-Info.plist"

if [ -f "$DOWNLOADS_FILE" ]; then
    echo "✅ Found GoogleService-Info.plist in Downloads"
    FILE_TO_CHECK="$DOWNLOADS_FILE"
elif [ -f "$DEV_FILE" ]; then
    echo "ℹ️  Checking existing dev configuration"
    FILE_TO_CHECK="$DEV_FILE"
else
    echo "❌ GoogleService-Info.plist not found!"
    echo "   Please download it from Firebase Console first."
    echo ""
    echo "📥 Download from: https://console.firebase.google.com/"
    echo "   → Select project: khubzati-dev-131af"
    echo "   → Project Settings → Your apps → iOS app"
    echo "   → Download GoogleService-Info.plist"
    exit 1
fi

echo "📄 Checking file: $FILE_TO_CHECK"
echo ""

# Required fields for Phone Authentication
REQUIRED_FIELDS=(
    "API_KEY"
    "GCM_SENDER_ID"
    "BUNDLE_ID"
    "PROJECT_ID"
    "GOOGLE_APP_ID"
    "CLIENT_ID"
    "REVERSED_CLIENT_ID"
)

MISSING_FIELDS=()
PLACEHOLDER_FIELDS=()

echo "🔎 Checking required fields:"
echo ""

for field in "${REQUIRED_FIELDS[@]}"; do
    if grep -q "<key>$field</key>" "$FILE_TO_CHECK"; then
        # Check if it's a placeholder
        if grep -A1 "<key>$field</key>" "$FILE_TO_CHECK" | grep -q "PLACEHOLDER"; then
            echo "⚠️  $field - Found but has PLACEHOLDER value"
            PLACEHOLDER_FIELDS+=("$field")
        else
            echo "✅ $field - OK"
        fi
    else
        echo "❌ $field - MISSING"
        MISSING_FIELDS+=("$field")
    fi
done

echo ""
echo "==========================================="
echo ""

# Summary
if [ ${#MISSING_FIELDS[@]} -eq 0 ] && [ ${#PLACEHOLDER_FIELDS[@]} -eq 0 ]; then
    echo "🎉 SUCCESS! Your GoogleService-Info.plist is complete!"
    echo ""
    echo "📋 Next steps:"
    echo "   1. Run: ./install_firebase_config.sh"
    echo "   2. Or manually copy to:"
    echo "      cp $FILE_TO_CHECK ios/config/dev/GoogleService-Info.plist"
    echo "      cp $FILE_TO_CHECK ios/Runner/GoogleService-Info.plist"
    echo ""
    exit 0
else
    echo "❌ INCOMPLETE CONFIGURATION"
    echo ""
    
    if [ ${#MISSING_FIELDS[@]} -gt 0 ]; then
        echo "Missing fields:"
        for field in "${MISSING_FIELDS[@]}"; do
            echo "  - $field"
        done
        echo ""
    fi
    
    if [ ${#PLACEHOLDER_FIELDS[@]} -gt 0 ]; then
        echo "Fields with PLACEHOLDER values:"
        for field in "${PLACEHOLDER_FIELDS[@]}"; do
            echo "  - $field"
        done
        echo ""
    fi
    
    echo "📚 To fix this:"
    echo ""
    echo "Option 1 - Use Test Phone Numbers (Quickest):"
    echo "  1. Go to Firebase Console → Authentication → Phone"
    echo "  2. Add test number: +16505553434 with code: 123456"
    echo "  3. Use this test number in your app (no SMS sent)"
    echo "  ✨ No OAuth setup needed for testing!"
    echo ""
    echo "Option 2 - Get Complete Config (For Production):"
    echo "  1. Go to: https://console.cloud.google.com/apis/credentials"
    echo "  2. Create OAuth 2.0 Client ID for iOS"
    echo "  3. Bundle ID: com.khubzati.app.dev"
    echo "  4. Download updated GoogleService-Info.plist from Firebase"
    echo ""
    echo "📖 Full guide: GET_COMPLETE_IOS_CONFIG.md"
    echo ""
    exit 1
fi

