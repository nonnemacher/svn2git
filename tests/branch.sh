#!/bin/bash

# @autor carlos.nonnemacher

## Variables

declare branch_prefix="origin/tags"

## Functions 

source <(curl -s https://raw.githubusercontent.com/nonnemacher/svn2git/master/tests/tags.sh) 

## This is a function of create local branch after clone svn  
function create_branch {
    for branch in `git branch --remote`
    do 
        if [[ ${branch} == *${branch_prefix}* ]]
        then
            create_tag ${branch}
        else 
            declare local_branch=$(sed 's/^origin\/\(.*\)$/\1/')
            log "INFO" "create local branch ${local_branch}"
            git checkout ${branch} -b ${local_branch}
        fi 
    done      
}