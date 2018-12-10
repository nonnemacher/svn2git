# SVN to GIT 

Script to migrate svn repository with structure "trunk/base" to git repository.

```
../trunk
../tags
../branches
```

## Pre-Requireds

#### On Windows - 
 - Svn, Git, Git Bash

#### On Linux - 
 - Svn, Bash and Git

## Run 

Set 2 environment variables before execute

> Svn host
```bash
# default abcdef.com
export SVN_DEFAULT_HOST="https://192.168.0.1:8080/svn"
```
> User domain, `user @ <domain>` for history
```bash
# default abcdef.com
export SVN_DEFAULT_DOMAIN="abcdef.com"
```

Ok we are done to start
```bash
# Run svn2git.sh
./svn2git.sh ${SVN_PATH}
```