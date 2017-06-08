@echo off

REM get current path of batch file scripts
for /f %%i in ("%0") do set curpath=%%~dpi
call %curpath%ci-helper-base.bat %1 %2

if "%1"=="install" (
  move %WORK_DIR%\railo-express* %WORK_DIR%\railo
  move %WORK_DIR%\mxunit* %WORK_DIR%\railo\webapps\www\mxunit
  
  REM if nothing passed in for build directory, use scripts directory
  if "%BUILD_DIR%"=="" (
    set BUILD_DIR=%BASE_DIR%
  )

  echo creating symlink to scripts directory %BUILD_DIR% railo\webapps\www\%2
  mklink /D %WORK_DIR%\railo\webapps\www\%2 %BUILD_DIR%
) else (
  REM no "else if in batch file logic"
  REM so need to do a convoluted method to handle it
  if "%1"=="start" (
    echo changing dir to %WORK_DIR%\railo
    cd %WORK_DIR%\railo
    echo starting server
    cmd /k start.bat
  ) else (
    if "%1"=="stop" (
      echo changing dir to %WORK_DIR%\railo
      cd %WORK_DIR%\railo
      echo stopping server
      cmd /c stop.bat
    ) else (
      echo "Usage: %MY_DIR% (install|start|stop)"
    )
  )
)