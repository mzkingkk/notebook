@echo off
:init
set JAVA_HOME11=D:\software\java11
set JAVA_HOME17=D:\software\java17
:start
echo Current JDK Version:
java -version
echo =============================================
echo jdk list:
echo - jdk11  %JAVA_HOME11%
echo - jdk17  %JAVA_HOME17%
echo =============================================
:select
set /p opt=switch :
if "%opt%"=="11" (
	set TARGET_JAVA_HOME=%JAVA_HOME11%
)
if "%opt%"=="17" (
	set TARGET_JAVA_HOME=%JAVA_HOME17%
)
echo selected: %TARGET_JAVA_HOME%
wmic ENVIRONMENT where name="JAVA_HOME" set VariableValue="%TARGET_JAVA_HOME%"
echo print any key to exit
pause>nul
@echo on