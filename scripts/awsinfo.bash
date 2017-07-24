#!/bin/bash

function control_c {
    echo -e "\nAwsinfo interrupted, waiting for subprocesses to finish..."
    wait
    exit 1
}

trap control_c SIGINT
trap control_c SIGTERM
trap control_c INT

set -eumo pipefail

if [[ -v AWSINFO_DEBUG ]]
then
    set -x
fi

DIR="$(dirname "$(readlink -f "$0")")"

if [[ "$#" -gt 0 ]]
then
    command=$1
    shift
else
    echo -e "Please choose one of the available commands:\n"
    command=commands
fi

# Include Files from other helpers
source $DIR/helpers/awscli.bash
source $DIR/helpers/arguments.bash
source $DIR/helpers/functions.bash
source $DIR/helpers/filters.bash
source $DIR/helpers/common.bash
source $DIR/helpers/colors.bash

COMMANDS_DIR=$DIR/commands
CURRENT_COMMAND_DIR=$COMMANDS_DIR/$command
if [[ -d "$CURRENT_COMMAND_DIR" ]]
then
    if [[ "$#" -gt 0 && "$1" != "index" && -f "$CURRENT_COMMAND_DIR/$1.bash" ]]
    then
        subcommand=$1
        shift
    else
        if [[ -f "$CURRENT_COMMAND_DIR/index.bash" ]];
        then
            subcommand=index
        else
            echo "Command not available: $command $1"
            exit 1
        fi
    fi
else
    echo "Service not supported: $command"
    exit 1
fi

if [[ -z "$HELP" ]]
then
    source $CURRENT_COMMAND_DIR/$subcommand.bash
else
    cat $DIR/header.txt
    echo -e "\n"
    cat $CURRENT_COMMAND_DIR/$subcommand.md
    echo -e "\n"
fi