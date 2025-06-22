@rem ------------------- batch setting -------------------
@echo off

@rem ------------------- declare variable -------------------

@rem ------------------- execute script -------------------
call :%*
goto end

@rem ------------------- declare function -------------------

:action
    @rem declare variable
    set CACHE_DIRECTORY=%CLI_DIRECTORY%\cache

    @rem running docker container
    echo ^> Create image and pacakge content.
    call %CLI_SHELL_DIRECTORY%\utils\tools.bat workflow do-pack %CACHE_DIRECTORY%

    @rem copy content to output directory
    IF NOT "%OUTPUT_DIRECTORY%" == "" (
        echo ^> Copy package content to output directory
        IF EXIST "%OUTPUT_DIRECTORY%" (rd /S /Q  "%OUTPUT_DIRECTORY%")
        mkdir "%OUTPUT_DIRECTORY%"
        IF EXIST "%OUTPUT_DIRECTORY%" (
            xcopy /Y /S /Q %CACHE_DIRECTORY%\package %OUTPUT_DIRECTORY%
        )
    )
    goto end

:args
    set KEY=%1
    set VALUE=%2
    if "%KEY%"=="--output" (set OUTPUT_DIRECTORY=%VALUE%)
    if "%KEY%"=="-o" (set OUTPUT_DIRECTORY=%VALUE%)
    if "%KEY%"=="--name" (set RC_PACKAGE_DEFAULT_NAME=%VALUE%)
    if "%KEY%"=="-n" (set RC_PACKAGE_DEFAULT_NAME=%VALUE%)
    goto end

:short
    echo Package mode
    goto end

:help
    echo This is a Command Line Interface with project %PROJECT_NAME%
    echo List command with package
    echo.
    echo Options:
    echo      --help, -h        Show more command information.
    echo      --output, -o      Copy content to output directory.
    echo      --name, -n        Setting package name ( Default %RC_PACKAGE_DEFAULT_NAME% ).
    call %CLI_SHELL_DIRECTORY%\utils\tools.bat command-description %~n0
    goto end

:end
