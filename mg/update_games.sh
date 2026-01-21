#!/bin/bash
# filepath: /workspaces/home/mg/update_games.sh

# Initialize empty list
games_list=""

# Loop through each .html file in Game/
for file in $(find Game -name "*.html" -type f | sort); do
    # Extract title from <title> tag
    title=$(grep -o '<title>.*</title>' "$file" | sed 's/<title>//;s/<\/title>//' | head -1)
    # If no title, use filename
    if [ -z "$title" ]; then
        title=$(basename "$file" .html)
    fi
    # Add to list with newline
    games_list+="{ name: \"$title\", desc: \"Description\", file: \"$file\" },\n"
done

# Remove trailing comma and newline
games_list=$(echo -e "$games_list" | sed '$ s/,$//')

# Create temp file with new array
tempfile=$(mktemp)
echo "const games = [" > "$tempfile"
echo -n "$games_list" >> "$tempfile"
echo "" >> "$tempfile"
echo "];" >> "$tempfile"

# Use awk to replace the array block, passing tempfile as variable
awk -v tf="$tempfile" '
BEGIN { in_block = 0 }
/const games = \[/ { in_block = 1; next }
/];/ { if (in_block) { system("cat " tf); in_block = 0 } else print; next }
in_block { next }
{ print }
' index.html > temp_index.html && mv temp_index.html index.html

# Clean up
rm "$tempfile"

echo "Games array updated in index.html with titles extracted from files."