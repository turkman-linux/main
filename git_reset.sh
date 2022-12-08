URL=$(git remote get-url origin)
rm -rf .git
git init
git add .
git commit -m "reset"
git remote add origin "$URL"
git push -u origin master --force