# Flutter iOS Flavor Setup Instructions

## Problem
The error "The Xcode project does not define custom schemes. You cannot use the --flavor option" occurs because your Flutter project has flavors configured but the Xcode project doesn't have the corresponding custom schemes and build configurations.

## Solution
You need to manually set up the build configurations and schemes in Xcode. Here's how:

### Step 1: Open Xcode
```bash
open ios/Runner.xcworkspace
```

### Step 2: Create Build Configurations
1. In Xcode, select the **Runner** project (not the target) in the project navigator
2. Go to the **Info** tab
3. Under **Configurations**, you'll see Debug, Release, and Profile
4. For each flavor (dev, stage, prod), duplicate the configurations:
   - Duplicate **Debug** and rename to **Debug-dev**
   - Duplicate **Debug** and rename to **Debug-stage** 
   - Duplicate **Debug** and rename to **Debug-prod**
   - Duplicate **Release** and rename to **Release-dev**
   - Duplicate **Release** and rename to **Release-stage**
   - Duplicate **Release** and rename to **Release-prod**
   - Duplicate **Profile** and rename to **Profile-dev**
   - Duplicate **Profile** and rename to **Profile-stage**
   - Duplicate **Profile** and rename to **Profile-prod**

### Step 3: Configure Bundle Identifiers
1. Select the **Runner** target (not project)
2. Go to **Build Settings** tab
3. Search for "Product Bundle Identifier"
4. For each configuration, set different bundle identifiers:
   - Debug-dev: `com.example.khubzati.dev`
   - Debug-stage: `com.example.khubzati.stage`
   - Debug-prod: `com.example.khubzati`
   - Release-dev: `com.example.khubzati.dev`
   - Release-stage: `com.example.khubzati.stage`
   - Release-prod: `com.example.khubzati`
   - Profile-dev: `com.example.khubzati.dev`
   - Profile-stage: `com.example.khubzati.stage`
   - Profile-prod: `com.example.khubzati`

### Step 4: Create Custom Schemes
1. Go to **Product** → **Scheme** → **Manage Schemes...**
2. Duplicate the existing **Runner** scheme for each flavor:
   - Duplicate and rename to **dev**
   - Duplicate and rename to **stage**
   - Duplicate and rename to **prod**
3. For each scheme, configure the build configurations:
   - **dev** scheme: Use Debug-dev, Release-dev, Profile-dev
   - **stage** scheme: Use Debug-stage, Release-stage, Profile-stage
   - **prod** scheme: Use Debug-prod, Release-prod, Profile-prod
4. Make sure to check **Shared** for each scheme

### Step 5: Test the Setup
After completing the above steps, you should be able to run:

```bash
# Development flavor
flutter run --flavor dev --target lib/main_dev.dart

# Staging flavor  
flutter run --flavor stage --target lib/main_stage.dart

# Production flavor
flutter run --flavor prod --target lib/main.dart
```

## Alternative: Use Xcode Build Script
If you prefer to automate this process, you can use the provided `setup_flavors.sh` script, but it requires manual completion of the Xcode configuration steps.

## Troubleshooting
- Make sure you're selecting the **project** (not target) when creating build configurations
- Ensure all schemes are marked as **Shared**
- Verify that bundle identifiers are unique for each flavor
- Clean and rebuild after making changes: `flutter clean && flutter pub get`

## Files Created
- Custom scheme files: `ios/Runner.xcodeproj/xcshareddata/xcschemes/dev.xcscheme`, `stage.xcscheme`, `prod.xcscheme`
- Setup script: `setup_flavors.sh`
- This instruction file: `FLAVOR_SETUP_INSTRUCTIONS.md`
