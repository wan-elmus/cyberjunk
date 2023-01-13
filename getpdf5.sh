
#Just simple Tests



OPTERR="Invalid option error. Only -z for zip file is valid - exiting.."

if [[ $# -gt 0 ]]; then
    while getopts "z" opt; do
    case $opt in
        z) zipit=true;;
        *) echo -e "$OPTERR" && exit 1;;
        esac
    done
fi

for flag in "$@"
do
    if [ "$flag" != "-z" ]
    then
        tput setaf 1
        echo "Invalid option error. Only -z for zip PDFs is valid - exiting.."
        tput sgr0
        exit 3
    fi
done

....



if [ "$zipit" = true ]; then
    # Create a zip archive with the same name as the directory
    zip -r $dir_name.zip $dir_name
    # Remove the directory
    rm -r $dir_name
    echo "PDFs archived to $dir_name.zip in the $dir_name directory."
else
    # If no flags were provided or an invalid flag was provided, exit with
    exit 0
fi
