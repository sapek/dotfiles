@echo off

cd %USERPROFILE%

choco feature enable -n allowEmptyChecksums

REM Apply the Chef recipe bootstrap
chef-client --local-mode --runlist 'recipe[bootstrap]'
