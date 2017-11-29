@echo off

REM  Get User input for where to get files and deploy files
REM  Get User input for where to get files and deploy files
set /p buildnumber= Please provide build number?

set /P c=Do you want to zip TULV0025[Y/N]?
if /I "%c%" EQU "Y" goto :zip
if /I "%c%" EQU "N" goto :nozip




:zip

echo Creating Deployment SQL...
set  Granscript = %~dp0 + "\DB - Database_Grants_20160616.sql"

rem for %f in ('dir /b %~dp0\SQLBuild.sql', Granscript ) do echo %f >> 'dir /b %~dp0\%buildnumber%.sql'

copy /b SQLBuild.sql+"DB - Database_Grants_20160616.sql" %buildnumber%.sql

echo Remove existing SQL files from deployment folder
del /F /Q "C:\RAProjects\Motiva\Deployment\TULV0025\Nightly\z_SQL\*.sql"

echo Copying Deployment SQL to Deployment folder...
XCOPY %buildnumber%.sql "C:\RAProjects\Motiva\Deployment\TULV0025\Nightly\z_SQL\" /Y /R

echo Zipping Deployment folder...
"C:\Program Files\7-Zip\7z.exe" a -t7z -m0=lzma2 -mx=9 -aoa "C:\RAProjects\Motiva\Deployment\TULV0025\TULV0025.7z" "C:\RAProjects\Motiva\Deployment\TULV0025\Nightly"
pause

:nozip

echo Creating Deployment SQL...
set  Granscript = %~dp0 + "\DB - Database_Grants_20160616.sql"

rem for %f in ('dir /b %~dp0\SQLBuild.sql', Granscript ) do echo %f >> 'dir /b %~dp0\%buildnumber%.sql'

copy /b SQLBuild.sql+"DB - Database_Grants_20160616.sql" %buildnumber%.sql

echo Remove existing SQL files from deployment folder
del /F /Q "C:\RAProjects\Motiva\Deployment\TULV0025\Nightly\z_SQL\*.sql"

echo Copying Deployment SQL to Deployment folder...
XCOPY %buildnumber%.sql "C:\RAProjects\Motiva\Deployment\TULV0025\Nightly\z_SQL\" /Y /R
