#!/bin/bash

# Check if cwebp is installed
if ! command -v cwebp &> /dev/null; then
    echo "cwebp could not be found. Please install it using 'sudo apt install webp'."
    exit 1
fi

# Check if directory parameter is provided
if [ -z "$1" ]; then
    echo "Usage: $0 <directory>"
    exit 1
fi

# Directory to search for PNG files
DIRECTORY="$1"

# Check if the provided directory exists
if [ ! -d "$DIRECTORY" ]; then
    echo "Directory $DIRECTORY does not exist."
    exit 1
fi

# Create the 'webp' directory at the root of the provided directory
WEBP_DIR="$DIRECTORY/webp"
mkdir -p "$WEBP_DIR"

# Find all PNG files in the directory
find "$DIRECTORY" -type f -name "*.png" | while read -r png_file; do
    # Define the output file name by replacing the directory path with the 'webp' directory and changing the extension to .webp
    webp_file="$WEBP_DIR/$(basename "${png_file%.png}.webp")"
    
    # Convert PNG to WEBP
    cwebp -q 60 "$png_file" -o "$webp_file"
    
    # Check if conversion was successful
    if [ $? -eq 0 ]; then
        echo "Successfully converted: $png_file -> $webp_file"
    else
        echo "Failed to convert: $png_file"
    fi
done

