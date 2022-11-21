if "%1"=="" (set /p remote="Enter Remote URL: ") else (set remote=%1)


::https://github.com/ii6uu99/vscode-dev-manjaro.git

git init
git add .
git commit -m "first commit"
git branch -M main
git remote add origin %remote%
git push -u origin main