# Complete Flutter iOS Flavor Setup Guide

## Current Status
✅ **Completed:**
- Custom Xcode schemes created (dev, stage, prod)
- CocoaPods configuration files generated for all flavors
- Flutter flavor configuration in place
- Pod install completed successfully

❌ **Remaining Issue:**
The Xcode project file modifications for custom build configurations need to be completed manually in Xcode.

## Solution: Manual Setup in Xcode

Since the project.pbxproj file is complex and error-prone to edit manually, you need to complete the setup in Xcode:

### Step 1: Open Xcode
```bash
open ios/Runner.xcworkspace
```

### Step 2: Create Build Configurations
1. **Select the Runner PROJECT** (not target) in the project navigator
2. Go to the **Info** tab
3. Under **Configurations**, you'll see Debug, Release, and Profile
4. **Duplicate each configuration** for each flavor:

   **For Dev Flavor:**
   - Duplicate **Debug** → rename to **Debug-dev**
   - Duplicate **Release** → rename to **Release-dev**
   - Duplicate **Profile** → rename to **Profile-dev**

   **For Stage Flavor:**
   - Duplicate **Debug** → rename to **Debug-stage**
   - Duplicate **Release** → rename to **Release-stage**
   - Duplicate **Profile** → rename to **Profile-stage**

   **For Prod Flavor:**
   - Duplicate **Debug** → rename to **Debug-prod**
   - Duplicate **Release** → rename to **Release-prod**
   - Duplicate **Profile** → rename to **Profile-prod**

### Step 3: Configure Bundle Identifiers
1. Select the **Runner TARGET** (not project)
2. Go to **Build Settings** tab
3. Search for "Product Bundle Identifier"
4. Set different bundle identifiers for each configuration:

   | Configuration | Bundle Identifier |
   |---------------|-------------------|
   | Debug-dev | com.example.khubzati.dev |
   | Release-dev | com.example.khubzati.dev |
   | Profile-dev | com.example.khubzati.dev |
   | Debug-stage | com.example.khubzati.stage |
   | Release-stage | com.example.khubzati.stage |
   | Profile-stage | com.example.khubzati.stage |
   | Debug-prod | com.example.khubzati |
   | Release-prod | com.example.khubzati |
   | Profile-prod | com.example.khubzati |

### Step 4: Update Schemes (Already Done)
The custom schemes (dev, stage, prod) are already created and should be configured to use the corresponding build configurations.

### Step 5: Test the Setup
After completing the above steps, test with:

```bash
# Development flavor
flutter run --flavor dev --target lib/main_dev.dart

# Staging flavor  
flutter run --flavor stage --target lib/main_stage.dart

# Production flavor
flutter run --flavor prod --target lib/main.dart
```

## Alternative: Use Xcode Build Script
If you prefer to automate this, you can use the provided `setup_flavors.sh` script, but it requires manual completion of the Xcode configuration steps.

## Troubleshooting
- **Make sure you're selecting the PROJECT (not target)** when creating build configurations
- **Ensure all schemes are marked as Shared**
- **Verify that bundle identifiers are unique** for each flavor
- **Clean and rebuild** after making changes: `flutter clean && flutter pub get`

## Files Created/Modified
- ✅ Custom scheme files: `ios/Runner.xcodeproj/xcshareddata/xcschemes/dev.xcscheme`, `stage.xcscheme`, `prod.xcscheme`
- ✅ CocoaPods configuration files for all flavors
- ✅ Setup script: `setup_flavors.sh`
- ✅ Instruction files: `FLAVOR_SETUP_INSTRUCTIONS.md`, `COMPLETE_FLAVOR_SETUP.md`

## Expected Result
After completing the manual steps in Xcode, you should be able to run:
```bash
flutter run --flavor dev --target lib/main_dev.dart
```

And it should work without the "custom schemes" error.

## Next Steps
1. Complete the manual setup in Xcode as described above
2. Test each flavor to ensure they work correctly
3. Verify that each flavor uses the correct bundle identifier and configuration
