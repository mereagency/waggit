require 'shellwords'

escaped_command = Shellwords.escape(
'git checkout master
git branch -D wagon-branch
git branch -D local-branch
git stash

git checkout -b wagon-branch
wagon pull production
# nasty way of deleting all css files
find public/stylesheets/ -name "*.css" -exec rm -rf {} \;
#TODO: Be able to detect if any files were deleted remotely and delete them locally
#TODO: Remove css files that have an scss equivalent
#TODO: Checkout: http://stackoverflow.com/questions/3515597/git-add-only-non-whitespace-changes
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
git add -A .
echo "Enter a git commit comment:"
read -e comment
git commit -m "${comment}"
git rebase master local-branch
git checkout master
git merge local-branch

git branch -D wagon-branch
git branch -D local-branch

git pull
git push
wagon push production')

system "bash -c #{escaped_command}"
