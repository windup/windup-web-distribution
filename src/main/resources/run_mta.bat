@REM ====
@REM ==== JAVA VERSION VALIDATION ====
@REM ====
if not "%JAVA_HOME%" == "" set JAVA_HOME=%JAVA_HOME:"=%

@REM ==== START VALIDATION ====
if not "%JAVA_HOME%" == "" goto OkJHome

@REM Try to infer the JAVA_HOME location from the registry
FOR /F "skip=2 tokens=2*" %%A IN ('REG QUERY "HKLM\Software\JavaSoft\Java Runtime Environment" /v CurrentVersion') DO set CurVer=%%B

FOR /F "skip=2 tokens=2*" %%A IN ('REG QUERY "HKLM\Software\JavaSoft\Java Runtime Environment\%CurVer%" /v JavaHome') DO set JAVA_HOME=%%B

if not "%JAVA_HOME%" == "" goto OkJHome

echo.
echo ERROR: JAVA_HOME not found in your environment.
echo Please set the JAVA_HOME variable in your environment to match the
echo location of your Java installation
echo.
goto error

:OkJHome
if exist "%JAVA_HOME%\bin\java.exe" goto chkJVersion

echo.
echo ERROR: JAVA_HOME is set to an invalid directory.
echo JAVA_HOME = "%JAVA_HOME%"
echo Please set the JAVA_HOME variable in your environment to match the
echo location of your Java installation
echo.
goto error

:chkJVersion
set PATH="%JAVA_HOME%\bin";%PATH%

for /f "tokens=3" %%g in ('java -version 2^>^&1 ^| findstr /i "version"') do (
   set JAVAVER=%%g
)
for /f "delims=. tokens=1-3" %%v in ("%JAVAVER%") do (
   set JAVAVER_MAJOR=%%v
   set JAVAVER_MINOR=%%w
)
set "JAVAVER_MAJOR=%JAVAVER_MAJOR:~1,2%"
if %JAVAVER_MAJOR% equ 11 (
    goto chkFHome
)

echo.
echo A Java 11 JRE is required to run MTA. "%JAVA_HOME%\bin\java.exe" is version %JAVAVER%
echo.
goto error

:chkFHome

:error
if "%OS%"=="Windows_NT" @endlocal
if "%OS%"=="WINNT" @endlocal
set ERROR_CODE=1


@REM ====
@REM ==== EXECUTION PHASE ====
@REM ====

@echo off
REM ---------------------------------------------------------------------------
REM RedHat Application Migration Toolkit UI Console
REM --------------------------------------------------------------

SET JBOSS_HOME=%~dp0.

if "x%WINDUP_DATA_DIR%" == "x" (
    SET WINDUP_DATA_DIR="%JBOSS_HOME%\standalone\data"
)

REM *** Launching embedded MTA console server ***
call "%JBOSS_HOME%\bin\standalone.bat" -c standalone-full.xml -Dwindup.data.dir="%WINDUP_DATA_DIR%" %*
