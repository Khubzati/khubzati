#!/bin/bash

# Complete fix for Firebase Module Redefinition Error
# This script removes Firebase Swift Package Manager dependencies
# and reinstalls CocoaPods to fix the conflict

set -e

echo "🔧 Fixing Firebase Module Redefinition Error"
echo "=============================================="
echo ""

PROJECT_DIR="$(pwd)"
IOS_DIR="$PROJECT_DIR/ios"
PROJECT_FILE="$IOS_DIR/Runner.xcodeproj/project.pbxproj"

if [ ! -f "$PROJECT_FILE" ]; then
    echo "❌ Error: $PROJECT_FILE not found"
    echo "   Make sure you're running this from the project root"
    exit 1
fi

echo "📁 Project directory: $PROJECT_DIR"
echo ""

# Step 1: Backup
echo "💾 Step 1: Creating backup..."
cp "$PROJECT_FILE" "${PROJECT_FILE}.backup.$(date +%Y%m%d_%H%M%S)"
echo "✅ Backup created"
echo ""

# Step 2: Remove Firebase SPM references using sed
echo "🗑️  Step 2: Removing Firebase Swift Package Manager references..."
cd "$IOS_DIR"

# Remove Firebase package reference line
sed -i '' '/CED71C972EBC22C4001C42D6.*firebase-ios-sdk/d' "$PROJECT_FILE"

# Remove Firebase PBXBuildFile entries
sed -i '' '/CED71C9.*Firebase.*Frameworks/d' "$PROJECT_FILE"

# Remove Firebase from frameworks list (lines with CED71C9 followed by /* Firebase)
sed -i '' '/CED71C9[0-9A-F]*.*\/\* Firebase/d' "$PROJECT_FILE"

# Remove XCRemoteSwiftPackageReference section for Firebase
sed -i '' '/CED71C972EBC22C4001C42D6.*XCRemoteSwiftPackageReference.*firebase-ios-sdk/,/};/d' "$PROJECT_FILE"

# Remove XCSwiftPackageProductDependency sections for Firebase
sed -i '' '/CED71C9[0-9A-F]*.*\/\* Firebase/,/};/d' "$PROJECT_FILE"

echo "✅ Firebase SPM references removed"
echo ""

# Step 3: Clean everything
echo "🧹 Step 3: Cleaning build artifacts..."
cd "$PROJECT_DIR"
flutter clean
cd "$IOS_DIR"
rm -rf Pods Podfile.lock .symlinks
rm -rf ~/Library/Developer/Xcode/DerivedData/Runner-*
echo "✅ Cleaned"
echo ""

# Step 4: Get Flutter dependencies
echo "📦 Step 4: Getting Flutter dependencies..."
cd "$PROJECT_DIR"
flutter pub get
echo "✅ Dependencies fetched"
echo ""

# Step 5: Reinstall pods
echo "📦 Step 5: Reinstalling CocoaPods..."
cd "$IOS_DIR"
export LANG=en_US.UTF-8
pod install --repo-update
echo "✅ Pods installed"
echo ""

echo "🎉 Fix complete!"
echo ""
echo "📋 Next steps:"
echo "   1. Try building your app:"
echo "      flutter run --flavor dev -t lib/main_dev.dart"
echo ""
echo "   2. If you still see errors, open Xcode and manually remove:"
echo "      - File > Packages > Reset Package Caches"
echo "      - Remove any Firebase entries from Package Dependencies"
echo ""
echo "💾 Backup saved at: ${PROJECT_FILE}.backup.*"

