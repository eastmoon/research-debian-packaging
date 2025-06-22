# Declare variable

# Declare function
function action {
    # automaticatly end the try block, if command-result is non-null
    EXECUTE_ERROR_CHECK=throw
    # setting log filename
    [ ! -d ${CLI_DIRECTORY}/.log ] && mkdir ${CLI_DIRECTORY}/.log
    CLI_LOG_FILE_INFO=${CLI_DIRECTORY}/.log/install-info
    [ ! -e ${CLI_LOG_FILE_INFO} ] && touch ${CLI_LOG_FILE_INFO}
    CLI_LOG_FILE_WARN=${CLI_DIRECTORY}/.log/install-warn
    [ ! -e ${CLI_LOG_FILE_WARN} ] && touch ${CLI_LOG_FILE_WARN}
    CLI_LOG_FILE_ERR=${CLI_DIRECTORY}/.log/install-err
    [ ! -e ${CLI_LOG_FILE_ERR} ] && touch ${CLI_LOG_FILE_ERR}
    CLI_LOG_FILE=/tmp/log/install
    [ ! -d ${CLI_LOG_FILE%/*} ] && mkdir -p ${CLI_LOG_FILE%/*}
    [ -e ${CLI_LOG_FILE} ] && rm ${CLI_LOG_FILE}
    # execute script
    ## Pre-execute script
    log-t START
    ## Execute install command
    source ${CLI_SHELL_DIRECTORY}/utils/libs.sh exec-script install
    ## Post-execute script
    log-t FINISH
}

function args {
    return 0
}

function short {
    echo "Execute package install script."
}

function help {
    echo "Execute package install script"
    echo ""
    echo "Options:"
    echo "    --help, -h        Show more command information."
    command-description ${BASH_SOURCE##*/}
}

# Execute script
"$@"
