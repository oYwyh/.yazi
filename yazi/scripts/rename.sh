# ~/.config/yazi/scripts/rename.sh
#!/bin/bash
file_path="$1"
echo "Enter new name for $(basename "$file_path"):"
read new_name
mv "$file_path" "$(dirname "$file_path")/$new_name"
