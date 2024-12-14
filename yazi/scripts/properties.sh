#!/bin/bash

# Function to convert bytes to MB/GB
convert_size() {
    local size=$1
    if [ "$size" -lt 1048576 ]; then
        echo "$((size / 1024)) KB"
    elif [ "$size" -lt 1073741824 ]; then
        echo "$((size / 1048576)) MB"
    else
        echo "$((size / 1073741824)) GB"
    fi
}

# Function to copy text to clipboard using xclip
copy_to_clipboard() {
    echo "$1" | xclip -selection clipboard
}

# Check if any arguments are provided
if [ "$#" -eq 0 ]; then
    echo "No files or directories provided."
    exit 1
fi

# Create a temporary file to store the properties
temp_file=$(mktemp)

# Loop through each provided file or directory
for item in "$@"; do
    name=$(basename "$item")
    path=$(realpath "$item")

    if [ -d "$item" ]; then
        # Directory properties
        num_files=$(find "$item" -type f | wc -l)
        num_dirs=$(find "$item" -type d | wc -l)
        total_size=$(du -sb "$item" | cut -f1)
        size=$(convert_size "$total_size")
        echo -e "Name: $name\nPath: $path\nType: Directory\nContains: $num_files files and $((num_dirs - 1)) folders\nTotal Size: $size\n" >> "$temp_file"
    elif [ -f "$item" ]; then
        # File properties
        file_type=$(file --mime-type -b "$item")
        file_size=$(stat -c%s "$item")
        size=$(convert_size "$file_size")
        echo -e "Name: $name\nPath: $path\nType: $file_type\nSize: $size\n" >> "$temp_file"
    else
        echo "Error: $item is not a valid file or directory." >> "$temp_file"
    fi
    echo >> "$temp_file"
done

# Use rofi to display options and handle user selection
selection=$(rofi -dmenu -p "File Properties" < "$temp_file")

# Handle the selection (if the selection starts with "Name: ", "Path: ", or "Size: ")
if [[ $selection == Name:* ]]; then
    copy_to_clipboard "${selection#Name: }"
elif [[ $selection == Path:* ]]; then
    copy_to_clipboard "${selection#Path: }"
elif [[ $selection == Size:* ]]; then
    copy_to_clipboard "${selection#Size: }"
fi

# Clean up the temporary file
rm "$temp_file"