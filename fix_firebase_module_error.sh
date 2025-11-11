#!/bin/bash

# Fix Firebase Module Redefinition Error
# Run this script from your project root directory

set -e

echo "🔧 Fixing Firebase Module Redefinition Error"
echo "=============================================="
echo ""

# Get the project directory from the error path or current directory
PROJECT_DIR="${1:-/Users/user/Documents/khubzati_flutter_project/khubzati}"

if [ ! -d "$PROJECT_DIR" ]; then
    echo "❌ Project directory not found: $PROJECT_DIR"
    echo "   Usage: $0 [project-path]"
    echo "   Or run from project root: ./fix_firebase_module_error.sh"
    exit 1
fi

cd "$PROJECT_DIR"

echo "📁 Working in: $(pwd)"
echo ""

# Step 1: Clean Flutter
echo "🧹 Step 1: Cleaning Flutter build cache..."
flutter clean
echo "✅ Flutter cleaned"
echo ""

# Step 2: Clean iOS
echo "🧹 Step 2: Cleaning iOS pods and caches..."
cd ios
rm -rf Pods Podfile.lock .symlinks
rm -rf ~/Library/Developer/Xcode/DerivedData
echo "✅ iOS cleaned"
echo ""

# Step 3: Clean Xcode DerivedData
echo "🧹 Step 3: Cleaning Xcode DerivedData..."
rm -rf ~/Library/Developer/Xcode/DerivedData/Runner-*
echo "✅ Xcode DerivedData cleaned"
echo ""

# Step 4: Get Flutter dependencies
echo "📦 Step 4: Getting Flutter dependencies..."
cd ..
flutter pub get
echo "✅ Dependencies fetched"
echo ""

# Step 5: Reinstall pods with UTF-8 encoding
echo "📦 Step 5: Reinstalling CocoaPods..."
cd ios
export LANG=en_US.UTF-8
pod install --repo-update
echo "✅ Pods installed"
echo ""

# Step 6: Verify installation
echo "✅ Verification:"
if [ -d "Pods/Firebase" ]; then
    echo "   ✅ Firebase pods installed"
else
    echo "   ⚠️  Firebase pods not found - may need manual installation"
fi

echo ""
echo "🎉 Done! Try building your app now:"
echo "   flutter run --flavor dev -t lib/main_dev.dart"
echo ""

