#!/bin/bash

# This script sets up a subtree merge in a git repository.
# You can supply two arguments, the directory into which to
# store the subtree and the git url of the subtree.
# If you do not supply these arguments, you will be prompted. 

# First we test to see if we're in a git repo and bail if not.
git status > /dev/null 2>&1
test $? == 128 && echo "You must execute this script from within a git repository!" && exit 1

# If there are not two arguments supplied, prompt for the info:
if [[ "$1" == "" || "$2" == "" ]] ; then
    echo "Enter the url of the git repository to merge in as a subtree:"
    read SUBTREE
    echo "Enter the directory in which to store this subtree:"
    read NAME
else 
    NAME=$1
    SUBTREE=$2
fi

# See if they're serious about this:
echo "Really setup subtree merge of $SUBTREE into $NAME? (y/n)"
read foo

if [[ $foo == "y" || $foo == "yes" || $foo == "Y" || $foo == "YES" ]] ; then
    
    # If they're serious, then set things up:
    git remote add -f $NAME $SUBTREE
    git merge -s ours --no-commit $NAME/master >> /dev/null 2>&1
    git read-tree --prefix=$NAME/ -u $NAME/master
    chmod -R a-w $NAME
    git commit -m "Merge $SUBTREE into $NAME" 

    echo "chmod -R a+w $NAME && git pull -s subtree $NAME master && chmod -R a-w $NAME" >> update-subtree.sh
    test $? == 0 || echo "Create update-subtree.sh" && exit 1
    chmod +x update-subtree.sh

    echo "Subtree to $SUBTREE set up in $name. Use update-subtree.sh to refresh"
    echo "Pro-tip: In oXygen, select Options -> Preferences, click Editor. "
    echo "         Clear the check box by 'Can edit read only files'"
    echo "         This will make it impossible to accidentally edit"
    echo "         any merged in files. "

    exit 0

else
    echo "Subtree merge aborted"
    exit 0
fi
