#!/bin/bash

# Adds
# initCEFProcesses(argc, argv);
# to main function of main.cc

# Check if the correct number of arguments is passed
if [ $# -ne 1 ]; then
  echo "Usage: $0 <file-path>"
  exit 1
fi

# Assign file path argument
file="$1"

# Check if the file exists at the provided path
if [ ! -f "$file" ]; then
  # If not, construct a path in the parent directory with the same filename
  parent_dir_file=$(dirname "$(dirname $file)")/$(basename "$file")

  # Check if the file exists at the new path
  if [ -f "$parent_dir_file" ]; then
    file="$parent_dir_file" # Use the new path if it exists
  else
    # If neither path is valid, exit
    echo "File not found at '$original_path' or in its parent directory."
    exit 1
  fi
fi

# Check if the line initCEFProcesses(argc, argv); already exists in the file
if grep -q '^[[:space:]]*initCEFProcesses(argc, argv);' "$file"; then
  echo "The line 'initCEFProcesses(argc, argv);' already exists in the file."
else
  # Insert initCEFProcesses(argc, argv); before the first line starting with g_autoptr(
  awk '
    /^[[:space:]]*g_autoptr/ {
      print "  initCEFProcesses(argc, argv);";
    }
    { print }
  ' "$file" > "$file.tmp" && mv "$file.tmp" "$file"

  echo "Added 'initCEFProcesses(argc, argv);' before the first line starting with 'g_autoptr('."
fi
