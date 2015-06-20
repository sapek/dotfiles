@echo off

cd %USERPROFILE%

REM Apply the Chef recipe bootstrap
chef-client --local-mode --runlist 'recipe[bootstrap]'
