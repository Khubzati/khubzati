#!/bin/bash

# Remove Firebase Swift Package Manager dependencies
# This fixes the "redefinition of module 'Firebase'" error

set -e

PROJECT_FILE="Runner.xcodeproj/project.pbxproj"

if [ ! -f "$PROJECT_FILE" ]; then
    echo "❌ Error: $PROJECT_FILE not found"
    exit 1
fi

echo "🔧 Removing Firebase Swift Package Manager dependencies..."
echo ""

# Create backup
cp "$PROJECT_FILE" "${PROJECT_FILE}.backup"
echo "✅ Backup created: ${PROJECT_FILE}.backup"

# Remove Firebase SPM references using a Python script for safety
python3 << 'PYTHON_SCRIPT'
import re

file_path = "Runner.xcodeproj/project.pbxproj"

with open(file_path, 'r') as f:
    content = f.read()

# Remove Firebase PBXBuildFile entries (lines 19-29)
content = re.sub(r'\t\tCED71C9[0-9A-F]+.*Firebase.*Frameworks.*\n', '', content)

# Remove package reference from packageReferences section
content = re.sub(r'\t\t\t\tCED71C972EBC22C4001C42D6.*XCRemoteSwiftPackageReference.*firebase-ios-sdk.*,\n', '', content)

# Remove entire XCRemoteSwiftPackageReference section for Firebase
content = re.sub(r'\t\tCED71C972EBC22C4001C42D6 /\* XCRemoteSwiftPackageReference "firebase-ios-sdk" \*/ = \{[^}]+\};\n', '', content)

# Remove all XCSwiftPackageProductDependency entries for Firebase
content = re.sub(r'\t\tCED71C9[0-9A-F]+ /\* [^*/]+ \*/ = \{[^}]+\};\n', '', content)

# Remove Firebase package product dependencies from frameworks sections
content = re.sub(r'\t\t\t\t\t\tCED71C9[0-9A-F]+ /\* [^*/]+ in Frameworks \*/\;\n', '', content)

# Clean up empty packageReferences section if it becomes empty
content = re.sub(r'\t\t\tpackageReferences = \(\s*\);\n', '\t\t\tpackageReferences = (\n\t\t\t);\n', content)

with open(file_path, 'w') as f:
    f.write(content)

print("✅ Removed Firebase SPM dependencies")
PYTHON_SCRIPT

if [ $? -eq 0 ]; then
    echo "✅ Firebase SPM dependencies removed successfully!"
    echo ""
    echo "📋 Next steps:"
    echo "   1. Clean and reinstall pods:"
    echo "      cd ios && rm -rf Pods Podfile.lock && pod install && cd .."
    echo "   2. Clean Flutter:"
    echo "      flutter clean"
    echo "   3. Rebuild:"
    echo "      flutter run --flavor dev -t lib/main_dev.dart"
else
    echo "❌ Error removing dependencies. Restoring backup..."
    cp "${PROJECT_FILE}.backup" "$PROJECT_FILE"
    exit 1
fi

