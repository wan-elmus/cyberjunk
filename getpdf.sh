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


:'
The script begins by prompting the user to enter a URL.

The script checks if the user provided a URL. If no URL was provided, the script displays an error message and exits with an exit code of 1.

The script downloads the HTML page at the provided URL using the wget command.

The script extracts all the PDF links from the HTML page using the grep and sed commands, and saves them to a file called pdf_links.txt.

The script checks if there are any PDF links in the file. If the file is empty, the script displays a message indicating that no PDF files were found at the provided URL, removes the temporary files index.html and pdf_links.txt, and exits with an exit code of 2.

The script creates a unique directory to store the PDF files. The directory name is based on the current date and time, and is formatted as pdf_files_YYYYMMDD_HHMMSS.

The script reads each PDF link from the pdf_links.txt file and downloads the corresponding PDF file using the wget command. The PDF files are saved to the directory created in step 6.

The script removes the temporary files index.html and pdf_links.txt.

The script counts the number of PDF files in the directory and prints a message indicating how many PDF files were downloaded and the directory name.

The script prints a tabulated summary
'