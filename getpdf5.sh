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