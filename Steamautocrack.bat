@echo off
color F1
chcp 65001 >nul 2>nul
setlocal enabledelayedexpansion
cd /d %~dp0
cls

:select
set select=
echo Select crack options:
echo 1.Auto crack(Unpack+Emu apply)
echo 2.Auto unpack(Unpack+Backup)
echo 3.Auto find file and unpack(Unpack+Backup)
echo 4.Auto apply EMU(Apply+Backup)
echo 5.EMU config(Appid+Achievements+DLC)
echo 6.EMU config Default(Appid)
echo 7.EMU setting(Language+UserID)
echo 8.Delete TEMP File(Run before crack)
echo 9.Open EMU setting floder
echo 10.Exit
set /p select=Select:
if /i "%select%"=="1" goto crack
if /i "%select%"=="2" cls & goto unpack
if /i "%select%"=="3" cls & goto unpackfind
if /i "%select%"=="4" goto EMUapply
if /i "%select%"=="5" goto EMUconfig
if /i "%select%"=="6" goto EMUdef
if /i "%select%"=="7" goto EMUsetting
if /i "%select%"=="8" goto deletetemp
if /i "%select%"=="9" goto open
if /i "%select%"=="10" exit
cls
goto select


:EMUdef
cls
set appid=
echo Selected EMU config Default.
set /p appid=Input appid:
if /i [%appid%]==[] cls & echo No appid input. & echo. & goto select
echo appid:%appid%
choice
IF /i ERRORLEVEL 2 cls & echo Cenceled. & echo. & goto select
mkdir Temp\steam_settings >nul 2>nul
echo %appid%>>Temp\steam_settings\steam_appid.txt
echo Steam EMU config Default completed.
pause
cls
goto select


:Open
start "" "%~dp0Temp\steam_settings\settings"
cls
goto select

:EMUapply
cls
set gamedir=
echo Selected EMU auto Apply.
if /i exist %~dp0Temp\steam_settings>nul 2>nul (nul) else ( cls & echo Please config steam api first. & echo. & goto select)
if /i exist %~dp0Temp\steam_settings\settings >nul 2>nul (nul) else ( cls & echo Please set steam api first. & echo. & goto select)
set /p gamedir=Drag and drop or steam api directory:
if /i [%gamedir%]==[] cls & echo No steam api selected. & echo. & goto select
if /i exist %gamedir% (nul)>nul 2>nul else cls & echo Input steam api directory not found. & echo. & goto select 
echo Selected directory %gamedir%
choice
IF /i ERRORLEVEL 2 cls & echo Cenceled. & echo. & goto select
echo Applying Steam EMU......
call %~dp0AutoEMUApply\AutoEMUApply.bat %gamedir%
echo Steam EMU applied.
goto deletetemp
pause
cls
goto select



:crack
cls
set gamedir=
echo Selected Auto crack.
if /i exist %~dp0Temp\steam_settings>nul 2>nul (nul) else ( cls & echo Please config steam api first. & echo. & goto select)
if /i exist %~dp0Temp\steam_settings\settings >nul 2>nul (nul) else ( cls & echo Please set steam api first. & echo. & goto select)
set /p gamedir=Drag and drop or input game directory:
if /i [%gamedir%]==[] cls & echo No game directory selected. & echo. & goto select
if /i exist %gamedir% (nul)>nul 2>nul else cls & echo Input game directory not found. & echo. & goto select 
echo Selected directory %gamedir%
choice
IF /i ERRORLEVEL 2 cls & echo Cenceled. & echo. & goto select
echo Unpacking......
call %~dp0FindExeUnpackModule\FindExeUnpackModule.bat %gamedir%
echo File unpack finished.
echo Applying Steam EMU......
call %~dp0FindAPIApplyModule\FindAPIApplyModule.bat %gamedir%
echo Steam EMU applied.
goto deletetemp
pause
cls
goto select

:unpackfind
cls
set gamedir=
echo Selected Auto find file and unpack.
set /p gamedir=Drag and drop or input game directory:
if /i [%gamedir%]==[] cls & echo No game directory selected. & echo. & goto select
if /i exist %gamedir% (nul)>nul 2>nul else cls & echo Input game directory not found. & echo. & goto select 
echo Selected directory %gamedir%
choice
IF /i ERRORLEVEL 2 cls & echo Cenceled. & echo. & goto select
echo Unpacking......
call %~dp0FindExeUnpackModule\FindExeUnpackModule.bat %gamedir%
echo File unpacked and a backup was made.
pause
cls
goto select


:unpack
set exedir=
echo Selected Unpack.
set /p exedir=Drag and drop or input exe file:
echo Selected file %exedir%
if /i [%exedir%]==[] cls & echo No input file selected. & echo. & goto select
if /i exist %exedir% (nul)>nul 2>nul else cls & echo Input file not found. & echo. & goto select >nul 2>nul
choice
IF /i ERRORLEVEL 2 cls & echo Cenceled. & echo. & goto select
echo Unpacking......
call %~dp0AutoUnpackModule\AutoUnpackModule.bat %exedir%
echo File unpack finished.
pause
cls
goto select

:deletetemp
echo Delete TEMP file?
choice
IF /i ERRORLEVEL 2 cls & echo Cenceled. & echo. & goto select
del /f /s /q %~dp0Temp>nul 2>nul
rd /s /q %~dp0Temp
cls
echo Temp file deleted.
echo.
goto select


:EMUconfig
cls
set appid=
set apikey=
set photo=
echo Selected EMUconfig.
set /p appid=Input appid:
if /i [%appid%]==[] cls & echo No appid input. & echo. & goto select
set /p apikey=Input Steam api key (For no api key leave blank):
if /i [%apikey%]==[] echo No Steam api key mode enabled. & set apikey=(Empty)
echo Generate achievement photos?
choice
IF /i ERRORLEVEL 1 set photo=[]
IF /i ERRORLEVEL 2 set photo=-p
echo appid:%appid% , Steam api key:%apikey%
choice
IF /i ERRORLEVEL 2 cls & echo Cenceled. & echo. & goto select
echo Getting game info......
call %~dp0AutoEMUConfigModule\AutoEMUConfigModule.bat %appid% %apikey% %photo%
echo Steam EMU config completed.
pause
cls
goto select

:EMUsetting
cls
set steamid=
set language=
set listenport=
set steamid=
if /i exist %~dp0Temp\steam_settings>nul 2>nul (nul) else ( cls & echo Please config steam api first. & echo. & goto select)
echo Selected EMUsetting.
echo For default leave blank.
set /p account=Input account_name (Default=goldberg):
copy /Y %~dp0AutoEMUSetModule\Example\language.txt %~dp0Temp\language.txt >nul 2>nul
start "" "%~dp0Temp\language.txt"
set /p language=Input language (Default=english):
del /f /s /q %~dp0Temp\language.txt >nul 2>nul
set /p listenport=Input listen_port (Default=47584):
set /p steamid=Input user_steam_id (Default=76561198648917173):
if /i [%account%]==[] set account=""
if /i [%language%]==[] set language=""
if /i [%listenport%]==[] set listenport=""
if /i [%steamid%]==[] set steamid=""
echo account_name:%account%
echo Language:%language%
echo listen_port:%listenport%
echo user_steam_id:%steamid%
choice
IF /i ERRORLEVEL 2 cls & echo Cenceled. & echo. & goto select
cd /d %~dp0
call AutoEMUSetModule\AutoEMUSetModule.bat %account% %language% %listenport% %steamid%
echo Steam EMU set completed.
pause
cls
goto select



