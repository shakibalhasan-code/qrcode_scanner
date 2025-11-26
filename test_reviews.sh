#!/bin/bash

# Test script to check product details API and debug review display

echo "🧪 Testing Product Details Review Display"
echo "========================================="
echo ""

# Navigate to project directory
cd /Users/shakib/Projects/qrcode_scanner

# Kill any existing flutter processes
echo "🔄 Cleaning up..."
pkill -f flutter

# Run flutter with filtered output
echo "🚀 Starting Flutter app..."
echo "📊 Watching for debug logs..."
echo ""

flutter run 2>&1 | grep --line-buffered -E "(📦|📊|⭐|📝|✅|⚠️|🎨|🔢)"
