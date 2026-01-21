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
    # Add to list
    games_list+="{ name: \"$title\", desc: \"Description\", file: \"$file\" },"
done

# Remove trailing comma
games_list=${games_list%,}

# Replace the games array in index.html (assumes it's on one line)
sed -i "s/const games = \[.*\];/const games = [$games_list];/" index.html

echo "Games array updated in index.html with titles extracted from files."