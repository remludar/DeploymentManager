@echo off

REM  Get User input for where to get files and deploy files
REM  Get User input for where to get files and deploy files
set /p buildnumber= Please provide build number?
set /p deletesql= Delete previous Sql Builds[Y/N]?
if /I "%deletesql%" EQU "Y" goto :delete
if /I "%deletesql%" EQU "N" goto :nodelete

:delete
echo Creating Deployment SQL...
set  Granscript = %~dp0 + "\DB - Database_Grants_20160616.sql"

rem for %f in ('dir /b %~dp0\SQLBuild.sql', Granscript ) do echo %f >> 'dir /b %~dp0\%buildnumber%.sql'

copy /b SQLBuild.sql+"DB - Database_Grants_20160616.sql" %buildnumber%.sql

echo Remove existing SQL files from deployment folder
del /F /Q "C:\RAProjects\Motiva\Deployment\MotivaDev\Builds\SQL\*.sql"

echo Copying Deployment SQL to Deployment folder...
XCOPY %buildnumber%.sql "C:\RAProjects\Motiva\Deployment\MotivaDev\Builds\SQL" /Y /R

:nodelete
echo Creating Deployment SQL...
set  Granscript = %~dp0 + "\DB - Database_Grants_20160616.sql"

rem for %f in ('dir /b %~dp0\SQLBuild.sql', Granscript ) do echo %f >> 'dir /b %~dp0\%buildnumber%.sql'

copy /b SQLBuild.sql+"DB - Database_Grants_20160616.sql" %buildnumber%.sql

echo Copying Deployment SQL to Deployment folder...
XCOPY %buildnumber%.sql "C:\RAProjects\Motiva\Deployment\MotivaDev\Builds\SQL" /Y /R
