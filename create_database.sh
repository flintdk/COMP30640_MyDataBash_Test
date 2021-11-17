#!/bin/bash
# create_datebase.sh; Create a folder to contain all entities for a database

# First - check our arguments:
function usage() {
    # Function 'usage()'' expects two arguments.
    #   -> $1 the error status we will exit with
    #   -> $2 the error message to display

    # Formatting from: https://misc.flogisoft.com/bash/tip_colors_and_formatting
    #   echo -e "\e[1mbold\e[0m"
    #   echo -e "\e[3mitalic\e[0m"
    #   echo -e "\e[3m\e[1mbold italic\e[0m"
    #   echo -e "\e[4munderline\e[0m"
    #   echo -e "\e[9mstrikethrough\e[0m"
    echo -e "$2  \e[1mUsage\e[0m: \e[3m$0\e[0m \e[3mdatabase_name\e[0m"
    exit $1  # exit with error status
}
if [ -z "$1" ]; then
    usage 1 "ERROR You must supply a database name.";
elif [ $# -ne 1 ]; then
    usage 1 "ERROR The number of arguments is wrong.";
fi

# here the core of your script
database=$1
home_dir=$(pwd)  # TODO Consider putting all databases into 'data' subfolder?

# Create a lock at database level before checking/creating a database
"$home_dir/P.sh" "$database"
if [ -e "$home_dir/$database" ]; then
    echo -e "ERROR The database \e[1m$database\e[0m already exists!  Aborting..." >&2 # &2 is standard error output
    # If the db already exists, we need to exit.  Don't forget to release the lock!
    "$home_dir/V.sh" "$database"
    exit 2 # the exit code that shows the db already existed
else
    # at the end of the script an exit code 0 means everything went well
    mkdir "$home_dir/$database"
    # Db created - release the lock
    "$home_dir/V.sh" "$database"
    echo -e "Success! The database \e[1m$database\e[0m has been created"
    exit 0
fi