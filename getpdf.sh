#!/bin/bash

# Full name and student number
# John Doe (12345678)

# Check if the user provided a URL
read -p "Enter a URL: " url
if [ -z "$url" ]
then
    echo "Error: No URL provided."
    exit 1
fi

# Download the HTML page at the provided URL
wget -q $url

# Extract all the PDF links from the HTML page
grep -o 'href=".*\.pdf"' index.html | sed 's/href=//g' | sed 's/"//g' > pdf_links.txt

# Check if there are any PDF links
if ! [ -s pdf_links.txt ]
then
    echo "No PDF files found at the provided URL."
    rm index.html pdf_links.txt
    exit 2
fi

# Create a unique directory to store the PDF files
dir_name=$(date +"pdf_files_%Y%m%d_%H%M%S")
mkdir $dir_name

# Read each PDF link and download the PDF file
while read line; do
    wget -P $dir_name -q $line
done < pdf_links.txt

# Remove the temporary files
rm index.html pdf_links.txt

# Print the number of PDF files downloaded and the directory name
pdf_count=$(ls -1 $dir_name | wc -l)
echo "$pdf_count PDF files have been downloaded to $dir_name."

# Print a tabulated summary of the PDF files
echo "Filename                Size"
echo "------------------------ -----"
for file in $dir_


