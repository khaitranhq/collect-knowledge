#!/bin/bash
# Script to generate Table of Contents in markdown format
# from files in the notes folder recursively

# Initialize counter for total number of notes
total_notes=0

# Function to convert kebab-case to Title Case
convert_to_title_case() {
  local string=$1
  # Remove file extension if present
  string=${string%.*}
  # Replace hyphens with spaces
  string=${string//-/ }
  # Capitalize first letter of each word
  string=$(echo $string | awk '{for(i=1;i<=NF;i++)sub(/./,toupper(substr($i,1,1)),$i)}1')
  echo "$string"
}

# Function to generate markdown TOC recursively
generate_toc() {
  local dir=$1
  local level=$2

  # List directories and files, sort directories first
  for item in $(find "$dir" -mindepth 1 -maxdepth 1 | sort); do
    # Get the base name of the item
    base_name=$(basename "$item")

    # Skip hidden files and directories
    if [[ $base_name == .* ]]; then
      continue
    fi

    # Calculate indentation
    indent=""
    for ((i = 0; i < level; i++)); do
      indent="  $indent"
    done

    if [ -d "$item" ]; then
      # It's a directory
      title=$(convert_to_title_case "$base_name")
      echo "$indent- **$title**"

      # Recursively process subdirectories
      generate_toc "$item" $((level + 1))
    else
      # It's a file - check if it's markdown
      if [[ $base_name == *.md ]]; then
        title=$(convert_to_title_case "$base_name")
        relative_path=${item#./}
        echo "$indent- [$title]($relative_path)"
        # Increment the counter
        ((total_notes++))
      fi
    fi
  done
}

# Start with a header
echo "## Table of Contents"
echo ""

# Start the TOC generation from the notes directory
if [ -d "notes" ]; then
  generate_toc "notes" 0
  
  # Print the total number of notes
  echo ""
  echo "Total number of notes: $total_notes"
else
  echo "Error: 'notes' directory not found!" >&2
  exit 1
fi
