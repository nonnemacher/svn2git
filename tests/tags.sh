#!/bin/bash

# @autor carlos.nonnemacher

## Variables

declare branch_prefix="origin/tags"

## Imports

#source log.sh
source <(curl -s https://raw.githubusercontent.com/nonnemacher/svn2git/master/tests/log.sh) 

## Functions

## This is a function used to create a tag of branch
function create_tag {
    declare branch=${1} 
    if [[ ${branch} == *${branch_prefix}* ]]
    then 
        declare tag_name=$(echo ${branch} | sed 's/^origin\/tags\/\(.*\)$/\1/')
        
        log "INFO" "Create TAG - ${tag_name} "
        git co ${branch}
        git tag ${tag_name}
        log "INFO" "Tag ${tag_name} successfully created"

        return 0
    fi 
    log "ERROR" "${branch} not contains \"${branch_prefix}\""
    return 1
}

if [[ ! -z ${1} ]]
then 
    create_tag ${1}
fi 
