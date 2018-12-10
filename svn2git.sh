#!/bin/bash

# @autor carlos.nonnemacher

## Variables
declare green="\e[32m"
declare white="\e[0m"
declare red="\e[31m"

declare svn_authors_file="/tmp/svn_authors.txt"
declare branch_prefix="origin/tags"

declare svn_domain="abcdef.com"  
declare svn_host="https://192.168.0.1:8080/svn"

# Set defaults
if [[ ! -z ${SVN_DEFAULT_HOST} ]]
then 
    svn_host=${SVN_DEFAULT_HOST}
fi 
if [[ ! -z ${SVN_DEFAULT_DOMAIN} ]]
then 
    svn_domain=${SVN_DEFAULT_DOMAIN}
fi 

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

## Get all authors of commits in SVN and put in file to after read, ${1} this is project dir in SVN
function authors { 
    log "INFO" "Init authors to ${1}"
    log "INFO" "Runnnig \n> svn log ${svn_host}/${1} --quiet | grep -E \"r[0-9]+ \| .+ \|\" | cut -d'|' -f2 | sed 's/ //g' | sort | uniq"
    for author in `svn log ${svn_host}/${1} --quiet | grep -E "r[0-9]+ \| .+ \|" | cut -d'|' -f2 | sed 's/ //g' | sort | uniq`
    do 
        echo "${author} = ${author} <${author}@${svn_domain}>" >> ${svn_authors_file}
    done 
    log "INFO" "End authors to ${1}"
} 

## Clone SVN repository in Git structure, ${1} this is project dir in SVN
function clone {
    log "INFO" "Init clone repository ${1}"
    log "INFO" "Runnnig \n> git svn clone --stdlayout --authors-file=${svn_authors_file} ${svn_host}/${1} ${1}"
    git svn clone --stdlayout --authors-file=${svn_authors_file} ${svn_host}/${1} ${1}
    # log "INFO" "Runnnig \n> git svn clone --trunk=trunk --branches=branches --tags=tags --authors-file=${svn_authors_file} ${svn_host}/${1} ${1}"
    # git svn clone --trunk=trunk --branches=branches --tags=tags --authors-file=${svn_authors_file} ${svn_host}/${1} ${1}
    log "INFO" "End clone repository ${1}"
}

## This is a function used to create a tag of branch
function create_tag {
    declare branch=${2} 
    if [[ ${branch} == *${branch_prefix}* ]]
    then 
        declare tag_name=$(echo ${branch} | sed 's/^origin\/tags\/\(.*\)$/\1/')
        
        log "INFO" "Create TAG - ${tag_name} "
        git checkout ${branch}
        git tag ${tag_name}
        log "INFO" "Tag ${tag_name} successfully created"

        return 0
    fi 
    log "ERROR" "${branch} not contains \"${branch_prefix}\""
    return 1
}

## This is a function of create local branch after clone svn  
function create_branch {
    log "INFO" "Create branches"
    log "INFO" "Running \n> git branch --remote"
    for branch in `git branch --remote`
    do 
        log "INFO" "branch ${branch}"
        if [[ ${branch} == *${branch_prefix}* ]]
        then
            create_tag ${1} ${branch}
        else 
            log "INFO" "create local branch $(echo ${branch} | sed 's/^origin\/\(.*\)$/\1/')"
            log "INFO" "Running \n> git branch --remote"
            git checkout ${branch} -b $(echo ${branch} | sed 's/^origin\/\(.*\)$/\1/')
        fi 
    done      
}

## Init
function init {
    log "INFO" "Init process to ${1}"
    authors ${1}
    clone ${1}
    cd ${1}
    create_branch ${1}
    log "INFO" "End process to ${1}"
}

# Run with endpoint http        
if [[ -z ${1} ]]
then 
    declare svn_repo=""
    read -p "Please input svn repository: " svn_repo
    if [[ ! -z ${svn_repo} ]] 
    then
        init ${svn_repo} 
    else 
        log "ERROR" "SVN Repository required"
    fi 
else 
    init ${1}
fi 



