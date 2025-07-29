#!/bin/bash

# Directory containing Markdown files
TARGET_DIR="./content/posts"

# Loop through all .md files in the directory
find "$TARGET_DIR" -type f -name "*.md" | while read -r file; do
  # Check if the file starts with TOML front matter block
  if head -n 1 "$file" | grep -Fxq "+++" && head -n 10 "$file" | grep -m2 -Fxq "+++"; then
    echo "✅ Front matter already present: $file"
  else
    echo "➕ Adding TOML front matter to: $file"
    tmpfile=$(mktemp)
    cat <<EOF > "$tmpfile"
+++
title = "$(basename "$file" .md | sed 's/-/ /g' | sed 's/_/ /g')"
date = "$(date +%Y-%m-%d)"
draft = false
+++
EOF
    cat "$file" >> "$tmpfile"
    mv "$tmpfile" "$file"
  fi
done
