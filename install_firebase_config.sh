#!/bin/bash

# Firebase Configuration Installation Script
# This script copies Firebase config files to the correct locations

set -e

echo "📦 Firebase Configuration Installer"
echo "===================================="
echo ""

# File paths
DOWNLOADS_PLIST="/Users/user/Downloads/GoogleService-Info.plist"
DOWNLOADS_JSON="/Users/user/Downloads/google-services.json"
PROJECT_ROOT="/Users/user/.cursor/worktrees/khubzati/EBrqV"

# Check if files exist
if [ ! -f "$DOWNLOADS_PLIST" ]; then
    echo "❌ GoogleService-Info.plist not found in Downloads"
    echo "   Please download it from Firebase Console first"
    exit 1
fi

if [ ! -f "$DOWNLOADS_JSON" ]; then
    echo "❌ google-services.json not found in Downloads"
    echo "   Please download it from Firebase Console first"
    exit 1
fi

echo "✅ Found Firebase config files in Downloads"
echo ""

# Verify iOS config is complete
echo "🔍 Verifying iOS configuration..."
if ! grep -q "<key>CLIENT_ID</key>" "$DOWNLOADS_PLIST"; then
    echo "❌ CLIENT_ID missing from GoogleService-Info.plist"
    echo "   This file is incomplete. Please check GET_COMPLETE_IOS_CONFIG.md"
    exit 1
fi

if grep -q "PLACEHOLDER" "$DOWNLOADS_PLIST"; then
    echo "⚠️  WARNING: File contains PLACEHOLDER values"
    echo "   The configuration may not work properly"
    read -p "   Continue anyway? (y/n) " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        exit 1
    fi
fi

echo "✅ iOS config looks good"
echo ""

# Create directories if they don't exist
mkdir -p "$PROJECT_ROOT/ios/config/dev"
mkdir -p "$PROJECT_ROOT/ios/config/stage"
mkdir -p "$PROJECT_ROOT/ios/config/prod"
mkdir -p "$PROJECT_ROOT/ios/Runner"
mkdir -p "$PROJECT_ROOT/android/app"

# Install iOS files
echo "📱 Installing iOS configuration..."
cp "$DOWNLOADS_PLIST" "$PROJECT_ROOT/ios/config/dev/GoogleService-Info.plist"
cp "$DOWNLOADS_PLIST" "$PROJECT_ROOT/ios/Runner/GoogleService-Info.plist"
echo "   ✅ Copied to ios/config/dev/"
echo "   ✅ Copied to ios/Runner/"
echo ""

# Install Android file
echo "🤖 Installing Android configuration..."
cp "$DOWNLOADS_JSON" "$PROJECT_ROOT/android/app/google-services.json"
echo "   ✅ Copied to android/app/"
echo ""

echo "🎉 Installation complete!"
echo ""
echo "📋 Next steps:"
echo ""
echo "1️⃣  Clean and rebuild:"
echo "   flutter clean"
echo "   flutter pub get"
echo "   cd ios && pod install && cd .."
echo ""
echo "2️⃣  Run the app:"
echo "   flutter run --flavor dev -t lib/main_dev.dart"
echo ""
echo "3️⃣  For stage and prod flavors:"
echo "   - Download their respective GoogleService-Info.plist files"
echo "   - Copy to ios/config/stage/ and ios/config/prod/"
echo ""
echo "💡 Tip: If you still get 'internal-error', use Firebase test phone numbers:"
echo "   Firebase Console → Authentication → Phone → Test phone numbers"
echo "   Add: +16505553434 with code: 123456"
echo ""

