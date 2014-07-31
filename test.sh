#!/bin/bash
git checkout master
git branch -D wagon-branch
git branch -D local-branch
git stash

git checkout -b wagon-branch
wagon pull production
#TODO: Be able to detect if any files were deleted remotely and delete them locally
#TODO: Remove css files that have an scc equivalent
if [[ -n $(git ls-files -m) ]]; then
    git add -A .
    git commit -m "merge wagon pull"
fi
git checkout master
git rebase master wagon-branch
git checkout master
git merge wagon-branch

git checkout -b local-branch
git stash pop
#TODO: force local file deletions up to the server...somehow
git add -A .
echo "Enter a git commit comment:"
read comment
git commit -m "${comment}"
git rebase master local-branch
git checkout master
git merge local-branch

git pull
git push
wagon push production
