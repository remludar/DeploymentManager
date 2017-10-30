@echo off

REM  Get User input for where to get files and deploy files
set destination="C:\Deploy\Builds"

set newtime=%time: =0%
set buildnumber=SQLDeploy_%DATE:~10,4%%DATE:~4,2%%DATE:~7,2%_%newtime:~0,2%%time:~3,2%%time:~6,2%

echo Creating Deployment SQL...
set  Granscript=%~dp0 + "\DB - Database_Grants_20160616.sql"
copy /b SQLBuild.sql+"DB - Database_Grants_20160616.sql" %buildnumber%.sql

echo Copying Deployment SQL to Deployment folder...
XCOPY %buildnumber%.sql %destination% /Y /R

pause


REM Used in old code to delete previous builds?
REM :delete
REM echo Creating Deployment SQL...
REM set  Granscript = %~dp0 + "\DB - Database_Grants_20160616.sql"

REM rem for %f in ('dir /b %~dp0\SQLBuild.sql', Granscript ) do echo %f >> 'dir /b %~dp0\%buildnumber%.sql'

REM copy /b SQLBuild.sql+"DB - Database_Grants_20160616.sql" %buildnumber%.sql

REM echo Remove existing SQL files from deployment folder
REM del /F /Q %destination%\*.sql"

REM echo Copying Deployment SQL to Deployment folder...
REM XCOPY %buildnumber%.sql %destination% /Y /R
