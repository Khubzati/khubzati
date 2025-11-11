#!/bin/bash

# Script to help download and verify complete GoogleService-Info.plist files
# for Firebase Phone Authentication

set -e

PROJECT_ROOT="/Users/user/Documents/khubzati_flutter_project/khubzati"
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo "================================================"
echo "Firebase GoogleService-Info.plist Checker"
echo "================================================"
echo ""

# Function to check if file has required fields
check_plist_complete() {
    local file_path=$1
    local env_name=$2
    
    if [ ! -f "$file_path" ]; then
        echo -e "${RED}❌ $env_name: File not found at $file_path${NC}"
        return 1
    fi
    
    # Check for CLIENT_ID
    if grep -q "<key>CLIENT_ID</key>" "$file_path"; then
        # Check if it's a placeholder
        if grep -q "PLACEHOLDER" "$file_path"; then
            echo -e "${YELLOW}⚠️  $env_name: Has PLACEHOLDER CLIENT_ID (needs real value)${NC}"
            return 1
        else
            echo -e "${GREEN}✅ $env_name: Has CLIENT_ID${NC}"
        fi
    else
        echo -e "${RED}❌ $env_name: Missing CLIENT_ID${NC}"
        return 1
    fi
    
    # Check for REVERSED_CLIENT_ID
    if grep -q "<key>REVERSED_CLIENT_ID</key>" "$file_path"; then
        # Check if it's a placeholder
        if grep -q "PLACEHOLDER" "$file_path"; then
            echo -e "${YELLOW}⚠️  $env_name: Has PLACEHOLDER REVERSED_CLIENT_ID (needs real value)${NC}"
            return 1
        else
            echo -e "${GREEN}✅ $env_name: Has REVERSED_CLIENT_ID${NC}"
        fi
    else
        echo -e "${RED}❌ $env_name: Missing REVERSED_CLIENT_ID${NC}"
        return 1
    fi
    
    return 0
}

echo "Checking current GoogleService-Info.plist files..."
echo ""

# Check all three environments
dev_ok=false
stage_ok=false
prod_ok=false

check_plist_complete "$PROJECT_ROOT/ios/config/dev/GoogleService-Info.plist" "DEV" && dev_ok=true
check_plist_complete "$PROJECT_ROOT/ios/config/stage/GoogleService-Info.plist" "STAGE" && stage_ok=true
check_plist_complete "$PROJECT_ROOT/ios/config/prod/GoogleService-Info.plist" "PROD" && prod_ok=true

echo ""
echo "================================================"

if $dev_ok && $stage_ok && $prod_ok; then
    echo -e "${GREEN}✅ All GoogleService-Info.plist files are complete!${NC}"
    echo ""
    echo "You can now proceed to configure APNs:"
    echo "1. Go to https://developer.apple.com/account/"
    echo "2. Create APNs key"
    echo "3. Upload to Firebase Console"
    echo ""
    echo "See QUICK_FIX_CHECKLIST.md for details"
else
    echo -e "${RED}❌ Some GoogleService-Info.plist files are incomplete!${NC}"
    echo ""
    echo "How to fix:"
    echo ""
    echo "Option 1: Use FlutterFire CLI (RECOMMENDED)"
    echo "-------------------------------------------"
    echo "dart pub global activate flutterfire_cli"
    echo ""
    
    if ! $dev_ok; then
        echo "# Fix DEV:"
        echo "flutterfire configure --project=khubzati-dev-131af \\"
        echo "  --out=ios/config/dev/GoogleService-Info.plist \\"
        echo "  --platforms=ios --ios-bundle-id=com.khubzati.app.dev --yes"
        echo ""
    fi
    
    if ! $stage_ok; then
        echo "# Fix STAGE:"
        echo "flutterfire configure --project=khubzati-stage-269cf \\"
        echo "  --out=ios/config/stage/GoogleService-Info.plist \\"
        echo "  --platforms=ios --ios-bundle-id=com.khubzati.app.stage --yes"
        echo ""
    fi
    
    if ! $prod_ok; then
        echo "# Fix PROD:"
        echo "flutterfire configure --project=khubzati-2e760 \\"
        echo "  --out=ios/config/prod/GoogleService-Info.plist \\"
        echo "  --platforms=ios --ios-bundle-id=com.khubzati.app --yes"
        echo ""
    fi
    
    echo "Option 2: Download from Firebase Console"
    echo "----------------------------------------"
    echo "1. Go to: https://console.firebase.google.com/"
    echo "2. Select your project"
    echo "3. Project Settings → Your apps → iOS app"
    echo "4. Download GoogleService-Info.plist"
    echo "5. Replace the incomplete file"
    echo ""
    echo "See HOW_TO_DOWNLOAD_COMPLETE_GOOGLESERVICE_PLIST.md for details"
fi

echo "================================================"

