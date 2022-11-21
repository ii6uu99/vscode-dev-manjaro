@echo off
if not exist .git\ (git init)
if "%1"=="" (if exist .git/config (for /F "tokens=3 delims= " %%A in ('find "url" .git/config') do (if %%A NEQ "" (set remote=%%A) else (set /p remote="Enter Remote URL: "))) else (set /p remote="Enter Remote URL: ")) else (set remote=%1)
set isgit=%remote:~-4%
if "%isgit%" NEQ ".git" (set remote=%remote%.git && set url=%remote%) else (set url=%remote:.git=%)

git remote add origin %remote%
git add .
git commit -m "git2"
git branch -M main
git push -u origin main


start %url%