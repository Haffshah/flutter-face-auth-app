#!/bin/bash

# Quick script to check current image sizes and statistics

echo "📊 Current Image Statistics"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

# Count PNG files
png_count=$(find assets/project_mockup -type f -name "*.png" 2>/dev/null | wc -l | tr -d ' ')
echo "PNG files: $png_count"

# Count WebP files
webp_count=$(find assets/project_mockup -type f -name "*.webp" 2>/dev/null | wc -l | tr -d ' ')
echo "WebP files: $webp_count"

echo ""

# Total size of PNG files
if [ $png_count -gt 0 ]; then
    png_size=$(find assets/project_mockup -type f -name "*.png" -exec stat -f%z {} \; 2>/dev/null | awk '{s+=$1} END {print s}')
    if [ -z "$png_size" ]; then
        png_size=$(find assets/project_mockup -type f -name "*.png" -exec stat -c%s {} \; 2>/dev/null | awk '{s+=$1} END {print s}')
    fi
    png_size_mb=$((png_size / 1024 / 1024))
    echo "Total PNG size: ${png_size_mb}MB"
fi

# Total size of WebP files
if [ $webp_count -gt 0 ]; then
    webp_size=$(find assets/project_mockup -type f -name "*.webp" -exec stat -f%z {} \; 2>/dev/null | awk '{s+=$1} END {print s}')
    if [ -z "$webp_size" ]; then
        webp_size=$(find assets/project_mockup -type f -name "*.webp" -exec stat -c%s {} \; 2>/dev/null | awk '{s+=$1} END {print s}')
    fi
    webp_size_mb=$((webp_size / 1024 / 1024))
    echo "Total WebP size: ${webp_size_mb}MB"
fi

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

# Show largest files
echo ""
echo "🔍 Top 10 Largest Images:"
echo ""
find assets/project_mockup -type f \( -name "*.png" -o -name "*.webp" \) -exec ls -lh {} \; | \
    awk '{print $5, $9}' | \
    sort -hr | \
    head -10 | \
    nl

echo ""

# Recommendations
if [ $png_count -gt 0 ]; then
    echo "💡 Recommendation:"
    echo "   You have $png_count PNG files totaling ${png_size_mb}MB"
    echo "   Run './optimize_images.sh' to convert to WebP and reduce size by ~80%"
    echo ""
elif [ $webp_count -gt 0 ]; then
    echo "✅ Great! You're using WebP format."
    echo "   Total size: ${webp_size_mb}MB"
    echo ""
fi
