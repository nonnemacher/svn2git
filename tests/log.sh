#!/bin/bash

# @autor carlos.nonnemacher

## Variables

declare green="\e[32m"
declare white="\e[0m"
declare red="\e[31m"

## Functions

# Log 
function log {
    declare color=${green}
    if [[ $1 == 'ERROR' ]]
    then 
        color=${red}
    fi 
    echo -e "${color}`date '+%Y-%m-%d %H:%M:%S'` - ${1} - ${2}${white}"
}

if [[ ! -z ${1} && ! -z ${2} ]]
then 
    log ${1} ${2}
fi 

 