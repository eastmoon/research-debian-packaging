@rem ------------------- batch setting -------------------
@echo off

@rem ------------------- declare variable -------------------

@rem ------------------- execute script -------------------
call :%*
goto end

@rem ------------------- declare function -------------------

:action
    @rem execute script
    echo Start project %PROJECT_NAME% develop server
    call %CLI_SHELL_DIRECTORY%\utils\tools.bat workflow do-dev
    goto end

:args
    goto end

:short
    echo Developer mode
    goto end

:help
    echo This is a Command Line Interface with project %PROJECT_NAME%
    echo Startup developer server
    echo.
    echo Options:
    echo      --help, -h        Show more command information.
    call %CLI_SHELL_DIRECTORY%\utils\tools.bat command-description %~n0
    goto end


:end
