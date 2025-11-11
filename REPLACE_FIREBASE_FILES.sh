#!/bin/bash

# Quick script to replace incomplete GoogleService-Info.plist files
# with complete ones downloaded from Firebase Console

set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo "================================================"
echo "Replace GoogleService-Info.plist Files"
echo "================================================"
echo ""

# Function to replace file
replace_file() {
    local env=$1
    local bundle_id=$2
    local project_id=$3
    local downloads_file="$HOME/Downloads/GoogleService-Info.plist"
    local target_file="/Users/user/Documents/khubzati_flutter_project/khubzati/ios/config/$env/GoogleService-Info.plist"
    
    echo -e "${YELLOW}Processing $env environment...${NC}"
    
    # Check if file exists in Downloads
    if [ ! -f "$downloads_file" ]; then
        echo -e "${RED}❌ GoogleService-Info.plist not found in Downloads folder${NC}"
        echo ""
        echo "Please download it first:"
        echo "1. Go to: https://console.firebase.google.com/project/$project_id/settings/general"
        echo "2. Find iOS app with bundle ID: $bundle_id"
        echo "3. Click 'Download GoogleService-Info.plist'"
        echo "4. Save to Downloads folder"
        echo "5. Run this script again"
        echo ""
        return 1
    fi
    
    # Verify it has CLIENT_ID
    if ! grep -q "<key>CLIENT_ID</key>" "$downloads_file"; then
        echo -e "${RED}❌ Downloaded file is missing CLIENT_ID!${NC}"
        echo "This might not be the complete file from Firebase."
        return 1
    fi
    
    # Verify it has REVERSED_CLIENT_ID
    if ! grep -q "<key>REVERSED_CLIENT_ID</key>" "$downloads_file"; then
        echo -e "${RED}❌ Downloaded file is missing REVERSED_CLIENT_ID!${NC}"
        echo "This might not be the complete file from Firebase."
        return 1
    fi
    
    # Check if it has PLACEHOLDER (shouldn't have it)
    if grep -q "PLACEHOLDER" "$downloads_file"; then
        echo -e "${RED}❌ Downloaded file still has PLACEHOLDER values!${NC}"
        echo "Please download the correct file from Firebase Console."
        return 1
    fi
    
    # Backup existing file
    if [ -f "$target_file" ]; then
        cp "$target_file" "$target_file.backup"
        echo "📦 Backed up existing file to: $target_file.backup"
    fi
    
    # Copy the new file
    cp "$downloads_file" "$target_file"
    
    echo -e "${GREEN}✅ Successfully replaced $env GoogleService-Info.plist${NC}"
    echo ""
    
    # Move processed file so it doesn't get reused
    mv "$downloads_file" "$downloads_file.$env.$(date +%Y%m%d_%H%M%S)"
    echo "Moved processed file to prevent accidental reuse"
    echo ""
    
    return 0
}

# Main menu
echo "Which environment do you want to update?"
echo ""
echo "1) STAGE (khubzati-stage-269cf) - bundle: com.khubzati.app.stage"
echo "2) DEV (khubzati-dev-131af) - bundle: com.khubzati.app.dev"
echo "3) PROD (khubzati-2e760) - bundle: com.khubzati.app"
echo "4) All three (you'll need to download each one separately)"
echo ""
read -p "Enter choice [1-4]: " choice

case $choice in
    1)
        replace_file "stage" "com.khubzati.app.stage" "khubzati-stage-269cf"
        ;;
    2)
        replace_file "dev" "com.khubzati.app.dev" "khubzati-dev-131af"
        ;;
    3)
        replace_file "prod" "com.khubzati.app" "khubzati-2e760"
        ;;
    4)
        echo ""
        echo "You'll need to download and replace each file one at a time:"
        echo ""
        echo "Step 1: Download STAGE file"
        echo "1. Go to: https://console.firebase.google.com/project/khubzati-stage-269cf/settings/general"
        echo "2. Download GoogleService-Info.plist for bundle: com.khubzati.app.stage"
        echo "3. Run this script and choose option 1"
        echo ""
        echo "Step 2: Download DEV file"  
        echo "1. Go to: https://console.firebase.google.com/project/khubzati-dev-131af/settings/general"
        echo "2. Download GoogleService-Info.plist for bundle: com.khubzati.app.dev"
        echo "3. Run this script and choose option 2"
        echo ""
        echo "Step 3: Download PROD file"
        echo "1. Go to: https://console.firebase.google.com/project/khubzati-2e760/settings/general"
        echo "2. Download GoogleService-Info.plist for bundle: com.khubzati.app"
        echo "3. Run this script and choose option 3"
        ;;
    *)
        echo "Invalid choice. Exiting."
        exit 1
        ;;
esac

echo ""
echo "================================================"
echo "Next steps:"
echo "================================================"
echo "1. Verify the file is correct:"
echo "   ./download_firebase_configs.sh"
echo ""
echo "2. Clean and rebuild:"
echo "   flutter clean"
echo "   cd ios && pod install && cd .."
echo ""
echo "3. Run the app:"
echo "   flutter run --flavor stage -t lib/main_stage.dart"
echo ""
echo "4. Test login - it should work now!"
echo "================================================"

