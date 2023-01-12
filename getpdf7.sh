#!/bin/bash

# Full name and student number

# Check if any invalid flags were provided
for flag in "$@"
do
    if [ "$flag" != "-z" ]
    then
        echo "Error: Invalid flag '$flag' provided."
        exit 3
    fi
done

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
    echo "No PDFs found at this URL - exiting.."
    rm index.html pdf_links.txt
    exit 2
fi

# Create a unique directory to store the PDF files
dir_name=$(date +"pdf_files_%Y_%m_%d_%H_%M_%S")
mkdir $dir_name
#Set the number of spaces to use
spaces=" "

# Read each PDF link and download the PDF file
pdf_count=0
printf "Downloading$spaces"

while read line; do
    wget -P $dir_name -q $line
    pdf_count=$((pdf_count+1))
    printf ".$spaces"
done < pdf_links.txt
if [ $pdf_count -gt 0 ]
then
    printf " %d PDF files have been downloaded to %s\n" $pdf_count $dir_name
fi

# Remove the temporary files
rm index.html pdf_links.txt

# Provide a tabulated summary of the downloaded PDF files
echo "Filename                Size"
echo "------------------------ -----" | sed 's/-/|/g'
for file in $dir_name/*; do
    size=$(stat -c %s "$file")
    size_in_kb=$(awk "BEGIN {printf \"%.3f\", $size/1024}")
    size_in_mb=$(awk "BEGIN {printf \"%.3f\", $size/1024/1024}")
    if [ $size -lt 1024 ]
    then
        printf "%-23s %5d bytes\n" $(basename "$file") $size
    elif [ $size -lt 1048576 ]
    then
        printf "%-23s %5.3f kb\n" $(basename "$file") $size_in_kb
    else
        printf "%-23s %5.3f mb\n" $(basename "$file") $size_in_mb
    fi
done

# Check if the -z option was provided
if [ $# -eq 1 ] && [ "$1" == "-z" ]
then
    # Create a zip archive with the same name as the directory
    zip -r $dir_name.zip $dir_name
    # Remove the directory
    rm -r $dir_name
    echo "PDF files have been added to a zip archive called $dir_name.zip."
else
    # If no flags were provided or an invalid flag was provided, exit with
    exit 0
fi
