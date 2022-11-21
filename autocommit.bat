::https://github.com/Aaryan-kapur/commit-regularly

@echo off

rem utf-8，避免cmd乱码
chcp 65001

rem --------------------------------

if not exist .git\ (git init)
if "%1"=="" (if exist .git/config (for /F "tokens=3 delims= " %%A in ('find "url" .git/config') do (if %%A NEQ "" (set remote=%%A) else (set /p remote="Enter Remote URL: "))) else (set /p remote="Enter Remote URL: ")) else (set remote=%1)
set isgit=%remote:~-4%
if "%isgit%" NEQ ".git" (set remote=%remote%.git && set url=%remote%) else (set url=%remote:.git=%)

rem --------------------------------


set count=0
:loop
set /a count=%count%+1

git remote add origin %remote%
git add .
git commit  -m "edit"
git branch -M main
git push -u origin main

echo 循环了%count%次
echo 等待30秒

::确定两次提交之间的时间，目前是每 30 秒一次，您可以更改它！ 
TIMEOUT 30

goto loop
