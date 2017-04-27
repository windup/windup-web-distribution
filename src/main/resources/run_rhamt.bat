@echo off
REM ---------------------------------------------------------------------------
REM RedHat Application Migration Toolkit UI Console
REM --------------------------------------------------------------

SET JBOSS_HOME=%~dp0.

if "x%WINDUP_DATA_DIR%" == "x" (
    SET WINDUP_DATA_DIR=%JBOSS_HOME%\standalone\data
)

REM *** Launching embedded RHAMT console server ***
call %JBOSS_HOME%\bin\standalone.bat -c standalone-full.xml -Dwindup.data.dir=%WINDUP_DATA_DIR% %*
