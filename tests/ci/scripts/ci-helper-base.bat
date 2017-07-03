@echo off

REM WORK_DIR and BUILD_DIR must be set!
if NOT defined WORK_DIR (
  echo "WORK_DIR must be set!"
  exit 1
)

if NOT defined BUILD_DIR (
  set BUILD_DIR=%BASE_DIR%
)

echo "Working directory: %WORK_DIR%, Build directory: %BUILD_DIR%"

if NOT "%1"=="install" (
  if NOT exist %WORK_DIR% (
    echo "Working directory doesn't exist and this isn't an install!"
    exit 1
  ) else (
	cd %WORK_DIR%
  )
) else (
  REM if only one argument
  if NOT exist %WORK_DIR% (
    REM create work directory
	mkdir %WORK_DIR%
  )
  if "%2"=="" (
    echo "usage: %0 install PROJECTNAME";
    exit 1
  )
)
if "%1"=="install" (
  call:download_and_extract %PLATFORM_URL%
  call:download_and_extract %MXUNIT_URL%
) else (
  REM no "else if in batch file logic"
  REM so need to do a convoluted method to handle it
  if NOT "%1"=="start" (
    if NOT "%1"=="stop" (
      echo "Usage: %0 {install|start|stop}"
      exit 1
	)
  )
)

goto:eof


REM FUNCTIONS SECTION

REM function for downloading and extracting files
:download_and_extract
  SETLOCAL
  set urlString=%1
  for %%F in (%urlString%) do set FILENAME=%%~nxF
  REM determine whether local or remote file
  set FIRST_CHAR=%urlString:~0,1%
  if "%FIRST_CHAR%"=="/" (
    echo Copying %1 to %WORK_DIR%/%FILENAME%
    copy %1 %WORK_DIR%/%FILENAME%
  ) else (
    REM make sure file does not already exist
	if NOT exist %WORK_DIR%/%FILENAME% (
      echo Downloading %1 to %WORK_DIR%/%FILENAME%
      cscript /nologo %TEST_DIR%/ci/scripts/wget.js %1 %WORK_DIR%/%FILENAME%
	)
  )
  
  for %%F in (%urlString%) do set FILENAME_EXT=%%~xF
  
  if %FILENAME_EXT%==.zip (
    echo unzipping %WORK_DIR%/%FILENAME%
    unzip -q %WORK_DIR%/%FILENAME% -d %WORK_DIR%
  ) else (
    echo untarring %WORK_DIR%/%FILENAME%
    REM untar goes here
  )

  echo deleting %WORK_DIR%\%FILENAME%
  DEL %WORK_DIR%\%FILENAME%
  ENDLOCAL
GOTO:EOF