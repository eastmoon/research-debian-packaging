@rem ------------------- batch setting -------------------
@echo off

@rem ------------------- execute script -------------------
call :%*
goto end

@rem ------------------- declare function -------------------
:do-dev-prepare
    @rem create cache
    IF NOT EXIST %CLI_DIRECTORY%\cache (mkdir %CLI_DIRECTORY%\cache)

    @rem declare variable initial value
    if not defined CONTENT_DIRECTORY (set CONTENT_DIRECTORY=%CLI_DIRECTORY%\%RC_PUBLISH_DEFAULT_CONTENT_DIR:/=\%)

    @rem build image
    docker build -t wrapper.sdk:%PROJECT_NAME% %CLI_DIRECTORY%\conf\docker\wrapper.sdk
    goto end

:do-dev-remove
    goto end

:do-dev
    @rem Declare variable

    @rem execute script
    echo ^> Startup service
    call :do-dev-prepare
    docker run -ti --rm ^
        -v %CONTENT_DIRECTORY%:/content ^
        -v %CLI_DIRECTORY%\cache\publish:/publish ^
        -v %CLI_DIRECTORY%\app\inst:/inst ^
        -v %CLI_DIRECTORY%\app\wrap:/wrap ^
        -w "/wrap" ^
        wrapper.sdk:%PROJECT_NAME%
    goto end

:pre-do-pub
    @rem create cache
    IF NOT EXIST %CLI_DIRECTORY%\cache (mkdir %CLI_DIRECTORY%\cache)
    IF NOT EXIST %CLI_DIRECTORY%\cache\publish (mkdir %CLI_DIRECTORY%\cache\publish)
    call :do-dev-prepare
    goto end

:do-pub
    @rem execute script
    docker run -ti --rm ^
        -v %CONTENT_DIRECTORY%:/content ^
        -v %CLI_DIRECTORY%\cache\publish:/publish ^
        -v %CLI_DIRECTORY%\app\inst:/inst ^
        -v %CLI_DIRECTORY%\app\wrap:/app ^
        -w "/app" ^
        wrapper.sdk:%PROJECT_NAME% -c "bash publish.sh"
    goto end

:post-do-pub
    @rem execute integrate pacakge script
    IF EXIST %CLI_DIRECTORY%\conf\publish\main.sh (
        @rem build runner and config file
        docker run -ti --rm ^
          -v %CLI_DIRECTORY%:/app ^
          -w "/app" ^
          bash -c "bash ./conf/publish/main.sh"
    )
    goto end

:pre-do-pack
    @rem create cache
    IF NOT EXIST %CLI_DIRECTORY%\cache (mkdir %CLI_DIRECTORY%\cache)
    IF EXIST %CLI_DIRECTORY%\cache\package (rd /S /Q %CLI_DIRECTORY%\cache\package)
    mkdir %CLI_DIRECTORY%\cache\package
    call :do-dev-prepare
    goto end

:do-pack

    @rem execute script
    docker run -ti --rm ^
        -v %CLI_DIRECTORY%\cache\package:/package ^
        -v %CLI_DIRECTORY%\cache\publish:/publish ^
        -v %CLI_DIRECTORY%\app\wrap:/wrap ^
        -w "/wrap" ^
        wrapper.sdk:%PROJECT_NAME% -c "bash package.sh %RC_PACKAGE_DEFAULT_NAME%
    goto end

:post-do-pack
    @rem execute integrate pacakge script
    IF EXIST %CLI_DIRECTORY%\conf\package\main.sh (
        @rem build runner and config file
        docker run -ti --rm ^
          -v %CLI_DIRECTORY%:/app ^
          -w "/app" ^
          bash -c "bash ./conf/package/main.sh"
    )
    goto end

:do-copy
    set CONTENT_DIR=%2
    set OUTPUT_DIR=%1
    @rem
    IF NOT "%OUTPUT_DIRECTORY%" == "" (
        echo ^> Copy publish content to output directory
        IF EXIST "%OUTPUT_DIRECTORY%" (rd /S /Q  "%OUTPUT_DIRECTORY%")
        mkdir "%OUTPUT_DIRECTORY%"
        IF EXIST "%OUTPUT_DIRECTORY%" (
            xcopy /Y /S /Q %CACHE_DIRECTORY%\package %OUTPUT_DIRECTORY%
        )
    )


@rem ------------------- End method-------------------

:end
