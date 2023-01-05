#!/bin/bash

# Student name and Registration number

# Prompt user to enter URL using the read command 
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

# Create a unique directory based on current date and time to store the PDF files
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

# Provide a tabulated summary of the downloaded PDF files
echo "Filename                Size"
echo "------------------------ -----"
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
    # Check if any invalid flags were provided
    if [ $# -ne 0 ]
    then
        echo "Error: Invalid flag provided."
        exit 3
    fi
fi


:'Kindly delete this comment block before submitting.

**Explanation of what the script does.**

It prompts the user to enter a URL with the read command.

It then checks if the user provided a URL by using the -z option of the [ command. If the URL is empty, the script prints an error message and exits with an exit code of 1.

The wget command is used to download the HTML page at the provided URL.

It then uses the grep and sed commands to extract all the PDF links from the HTML page and save them to a file called pdf_links.txt.

Checks if there are any PDF links in the file by using the [ -s ] test. If the file is empty, the script prints an error message, removes the temporary files (index.html and pdf_links.txt), and exits with an exit code of 2.

creates a unique directory to store the PDF files by using the date and mkdir commands. The name of the directory is based on the current date and time.

Reads each PDF link from the file pdf_links.txt and uses the wget command to download the corresponding PDF file to the directory created in step 6.

Temporary files (index.html and pdf_links.txt) are removed .

Prints the number of PDF files downloaded and the name of the directory.

A tabulated summary of the PDF files, including their names and sizes is printed. The sizes are displayed in bytes, kilobytes, or megabytes, depending on the size of the file.

Checks if the -z option was provided as an argument. If it was, a zip archive with the same name as the directory is created and the PDF files added to it. 

After step 11, it removes the directory that was created in step 6 if the -z option was provided. The rm -r command is used to remove the directory and all its contents.

Checks for any invalid flags, if any were provided, an error message is printed and the script exits with an exit code of 3.
'