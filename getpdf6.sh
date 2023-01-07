#!/bin/bash

# Parse the command-line arguments to determine whether the -z option is present and whether any invalid flags were provided.
zip=false
while getopts ":z" opt; do
    case ${opt} in
    z)
        zip=true
        ;;
    \?)
        echo "Invalid flag: -$OPTARG"
        exit 1
        ;;
    esac
done

# Prompt the user for the URL.
read -p "Enter the URL: " url

# Use wget to download all of the .pdf files from the URL.
wget -r -A.pdf $url

# Create a new directory with a unique name to store the downloaded .pdf files.
dirname=$(date +%s)
mkdir $dirname

# Move the downloaded .pdf files into the new directory.
find . -name "*.pdf" -exec mv {} $dirname \;

# Inform the user of how many .pdf files were downloaded and the name and location of the directory where they were stored.
count=$(find $dirname -name "*.pdf" | wc -l)
echo "$count .pdf files were downloaded to $dirname"

# If the -z option was provided, create a zip archive with the same name as the directory and store it in the same location as the directory.
if $zip; then
  zip -r $dirname $dirname
fi

# Display a tabulated summary of the name and size of each downloaded .pdf file.
echo "Filename                      Size"
echo "--------                      ----"
for file in $dirname/*; do
  printf "%-30s %s\n" "$(basename "$file")" "$(stat -c%s "$file") bytes"
done

# Remove any files and directories that were created by the script.
rm -r $dirname
