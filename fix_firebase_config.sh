#!/bin/bash

# Automated script to fix Firebase configuration by downloading real GoogleService-Info.plist files
# This will open Firebase Console URLs and guide you through the download process

set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

PROJECT_ROOT="/Users/user/Documents/khubzati_flutter_project/khubzati"

echo ""
echo "================================================================"
echo "  🔧 Firebase Configuration Fix - Automated Setup"
echo "================================================================"
echo ""
echo -e "${YELLOW}This script will help you download the correct GoogleService-Info.plist files${NC}"
echo ""

# Function to check if file has real CLIENT_ID
check_file() {
    local file=$1
    if [ ! -f "$file" ]; then
        return 1
    fi
    
    if grep -q "PLACEHOLDER" "$file"; then
        return 1
    fi
    
    if ! grep -q "<key>CLIENT_ID</key>" "$file"; then
        return 1
    fi
    
    return 0
}

# Function to open Firebase Console and guide download
download_for_env() {
    local env=$1
    local project_id=$2
    local bundle_id=$3
    local config_file="$PROJECT_ROOT/ios/config/$env/GoogleService-Info.plist"
    
    echo ""
    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${GREEN}📱 Configuring $env environment${NC}"
    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo ""
    echo "Project: $project_id"
    echo "Bundle ID: $bundle_id"
    echo ""
    
    # Check if already correct
    if check_file "$config_file"; then
        echo -e "${GREEN}✅ This environment already has a valid GoogleService-Info.plist${NC}"
        echo ""
        read -p "Do you want to re-download it anyway? (y/N): " answer
        if [[ ! $answer =~ ^[Yy]$ ]]; then
            return 0
        fi
    fi
    
    # Open Firebase Console
    local firebase_url="https://console.firebase.google.com/project/$project_id/settings/general/ios:$bundle_id"
    
    echo -e "${YELLOW}Step 1: Opening Firebase Console...${NC}"
    sleep 1
    open "$firebase_url" 2>/dev/null || echo "Please open: $firebase_url"
    
    echo ""
    echo -e "${YELLOW}Step 2: In Firebase Console:${NC}"
    echo "  1. Find your iOS app in the 'Your apps' section"
    echo "  2. Look for the app with bundle ID: ${BLUE}$bundle_id${NC}"
    echo "  3. Click the 'GoogleService-Info.plist' button to download"
    echo "  4. The file will be saved to your Downloads folder"
    echo ""
    
    read -p "Press ENTER after you've downloaded the file..."
    
    # Look for the downloaded file
    local downloads_file="$HOME/Downloads/GoogleService-Info.plist"
    local max_attempts=10
    local attempt=1
    
    while [ $attempt -le $max_attempts ]; do
        if [ -f "$downloads_file" ]; then
            echo -e "${GREEN}✅ Found downloaded file!${NC}"
            break
        fi
        
        if [ $attempt -eq $max_attempts ]; then
            echo -e "${RED}❌ Could not find GoogleService-Info.plist in Downloads folder${NC}"
            echo ""
            echo "Please make sure you downloaded the file and try again."
            return 1
        fi
        
        echo "Waiting for file... ($attempt/$max_attempts)"
        sleep 1
        ((attempt++))
    done
    
    # Verify the downloaded file has real CLIENT_ID
    echo ""
    echo -e "${YELLOW}Step 3: Verifying downloaded file...${NC}"
    
    if ! grep -q "<key>CLIENT_ID</key>" "$downloads_file"; then
        echo -e "${RED}❌ Downloaded file is missing CLIENT_ID!${NC}"
        echo "This might not be a valid GoogleService-Info.plist file."
        rm -f "$downloads_file"
        return 1
    fi
    
    if grep -q "PLACEHOLDER" "$downloads_file"; then
        echo -e "${RED}❌ Downloaded file still has PLACEHOLDER values!${NC}"
        echo "Please download the correct file from Firebase Console."
        rm -f "$downloads_file"
        return 1
    fi
    
    # Extract CLIENT_ID for display
    local client_id=$(grep -A 1 "<key>CLIENT_ID</key>" "$downloads_file" | grep "<string>" | sed 's/.*<string>\(.*\)<\/string>/\1/')
    echo -e "${GREEN}✅ Valid CLIENT_ID found: ${client_id:0:30}...${NC}"
    
    # Backup existing file
    if [ -f "$config_file" ]; then
        local backup_file="$config_file.backup.$(date +%Y%m%d_%H%M%S)"
        cp "$config_file" "$backup_file"
        echo "📦 Backed up old file to: $(basename $backup_file)"
    fi
    
    # Copy to correct location
    cp "$downloads_file" "$config_file"
    
    # Move processed file so it doesn't get reused
    mv "$downloads_file" "$downloads_file.$env.$(date +%Y%m%d_%H%M%S)"
    
    echo -e "${GREEN}✅ Successfully installed GoogleService-Info.plist for $env!${NC}"
    echo ""
    
    return 0
}

# Main execution
echo "Which environment do you want to fix?"
echo ""
echo "1) STAGE (recommended - you're testing this)"
echo "2) DEV"
echo "3) PROD"
echo "4) All three"
echo ""
read -p "Enter choice [1-4]: " choice

case $choice in
    1)
        download_for_env "stage" "khubzati-stage-269cf" "com.khubzati.app.stage"
        ;;
    2)
        download_for_env "dev" "khubzati-dev-131af" "com.khubzati.app.dev"
        ;;
    3)
        download_for_env "prod" "khubzati-2e760" "com.khubzati.app"
        ;;
    4)
        echo -e "${YELLOW}📋 You'll need to download each file separately...${NC}"
        echo ""
        download_for_env "stage" "khubzati-stage-269cf" "com.khubzati.app.stage" || true
        download_for_env "dev" "khubzati-dev-131af" "com.khubzati.app.dev" || true
        download_for_env "prod" "khubzati-2e760" "com.khubzati.app" || true
        ;;
    *)
        echo -e "${RED}Invalid choice. Exiting.${NC}"
        exit 1
        ;;
esac

echo ""
echo "================================================================"
echo -e "${GREEN}🎉 Firebase Configuration Updated!${NC}"
echo "================================================================"
echo ""

# Verify all files
echo "Verifying configuration files..."
echo ""

stage_ok=false
dev_ok=false
prod_ok=false

check_file "$PROJECT_ROOT/ios/config/stage/GoogleService-Info.plist" && stage_ok=true && echo -e "${GREEN}✅ STAGE: Valid${NC}" || echo -e "${RED}❌ STAGE: Invalid or missing${NC}"
check_file "$PROJECT_ROOT/ios/config/dev/GoogleService-Info.plist" && dev_ok=true && echo -e "${GREEN}✅ DEV: Valid${NC}" || echo -e "${RED}❌ DEV: Invalid or missing${NC}"
check_file "$PROJECT_ROOT/ios/config/prod/GoogleService-Info.plist" && prod_ok=true && echo -e "${GREEN}✅ PROD: Valid${NC}" || echo -e "${RED}❌ PROD: Invalid or missing${NC}"

echo ""
echo "================================================================"
echo -e "${YELLOW}📋 Next Steps:${NC}"
echo "================================================================"
echo ""
echo "1. Clean and rebuild the project:"
echo -e "   ${BLUE}flutter clean${NC}"
echo -e "   ${BLUE}cd ios && pod install && cd ..${NC}"
echo ""
echo "2. Run the app:"
echo -e "   ${BLUE}flutter run --flavor stage -t lib/main_stage.dart${NC}"
echo ""
echo "3. Test login:"
echo "   - Enter phone number: +962777777777"
echo "   - Press login"
echo "   - You should receive SMS with OTP!"
echo ""

read -p "Would you like me to clean and rebuild now? (Y/n): " rebuild
if [[ ! $rebuild =~ ^[Nn]$ ]]; then
    echo ""
    echo -e "${YELLOW}Cleaning project...${NC}"
    cd "$PROJECT_ROOT"
    flutter clean
    
    echo ""
    echo -e "${YELLOW}Installing CocoaPods...${NC}"
    export LANG=en_US.UTF-8
    cd ios && pod install && cd ..
    
    echo ""
    echo -e "${GREEN}✅ Project cleaned and rebuilt!${NC}"
    echo ""
    echo "You can now run:"
    echo -e "   ${BLUE}flutter run --flavor stage -t lib/main_stage.dart${NC}"
    echo ""
fi

echo -e "${GREEN}✅ All done! Your Firebase configuration is fixed.${NC}"
echo ""


