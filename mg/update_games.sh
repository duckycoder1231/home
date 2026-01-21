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

# Replace the games array block in index.html
sed -i "/const games = \[/,/];/c\\
const games = [
$games_list
];" index.html

echo "Games array updated in index.html with titles extracted from files."