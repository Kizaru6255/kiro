#!/bin/bash
# Script to generate Freezed files for all modules

echo "🚀 Generating Freezed files for all modules..."
echo ""

cd "$(dirname "$0")/.."

for module_dir in modules/*/; do
    module_name=$(basename "$module_dir")
    echo "📦 Generating files for: $module_name"
    cd "$module_dir"
    flutter pub run build_runner build --delete-conflicting-outputs > /dev/null 2>&1
    if [ $? -eq 0 ]; then
        echo "  ✅ $module_name - Done"
    else
        echo "  ❌ $module_name - Failed"
    fi
    cd - > /dev/null
done

echo ""
echo "✨ All modules processed!"

