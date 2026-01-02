#!/bin/bash

# Image Optimization Script for Flutter Web Portfolio
# This script converts PNG images to WebP format for better web performance

echo "🖼️  Starting image optimization for Flutter web..."
echo ""

# Check if cwebp is installed
if ! command -v cwebp &> /dev/null; then
    echo "❌ cwebp is not installed!"
    echo "📦 Installing webp tools..."
    
    # Check OS and install accordingly
    if [[ "$OSTYPE" == "darwin"* ]]; then
        # macOS
        if command -v brew &> /dev/null; then
            brew install webp
        else
            echo "Please install Homebrew first: https://brew.sh"
            exit 1
        fi
    elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
        # Linux
        sudo apt-get update && sudo apt-get install -y webp
    else
        echo "Please install webp tools manually: https://developers.google.com/speed/webp/download"
        exit 1
    fi
fi

echo "✅ WebP tools are installed"
echo ""

# Create backup directory
BACKUP_DIR="assets/project_mockup_backup_$(date +%Y%m%d_%H%M%S)"
echo "📁 Creating backup at: $BACKUP_DIR"
cp -r assets/project_mockup "$BACKUP_DIR"
echo "✅ Backup created"
echo ""

# Convert PNG to WebP
echo "🔄 Converting PNG images to WebP..."
echo ""

total_original_size=0
total_webp_size=0
file_count=0

# Find all PNG files and convert them
while IFS= read -r -d '' png_file; do
    # Get file size before conversion
    original_size=$(stat -f%z "$png_file" 2>/dev/null || stat -c%s "$png_file" 2>/dev/null)
    total_original_size=$((total_original_size + original_size))
    
    # Generate WebP filename
    webp_file="${png_file%.png}.webp"
    
    # Convert to WebP with quality 85 (good balance between quality and size)
    cwebp -q 85 "$png_file" -o "$webp_file" > /dev/null 2>&1
    
    if [ $? -eq 0 ]; then
        # Get WebP file size
        webp_size=$(stat -f%z "$webp_file" 2>/dev/null || stat -c%s "$webp_file" 2>/dev/null)
        total_webp_size=$((total_webp_size + webp_size))
        
        # Calculate savings
        savings=$((100 - (webp_size * 100 / original_size)))
        
        echo "✓ $(basename "$png_file") → $(basename "$webp_file") (${savings}% smaller)"
        
        # Remove original PNG
        rm "$png_file"
        
        file_count=$((file_count + 1))
    else
        echo "✗ Failed to convert: $png_file"
    fi
done < <(find assets/project_mockup -type f -name "*.png" -print0)

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "📊 Optimization Summary"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "Files converted: $file_count"
echo "Original size: $(numfmt --to=iec $total_original_size 2>/dev/null || echo "$((total_original_size / 1024 / 1024)) MB")"
echo "WebP size: $(numfmt --to=iec $total_webp_size 2>/dev/null || echo "$((total_webp_size / 1024 / 1024)) MB")"
echo "Total savings: $((100 - (total_webp_size * 100 / total_original_size)))%"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "✅ Optimization complete!"
echo "📦 Backup saved at: $BACKUP_DIR"
echo ""
echo "⚠️  Next steps:"
echo "1. Update your Dart code to use .webp extensions instead of .png"
echo "2. Run: flutter clean && flutter build web"
echo "3. Test your website to ensure images load correctly"
echo ""
