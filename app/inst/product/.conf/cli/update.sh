# Declare variable

# Declare function
function action {
    # automaticatly end the try block, if command-result is non-null
    EXECUTE_ERROR_CHECK=throw
    # setting log filename
    [ ! -d ${CLI_DIRECTORY}/.log ] && mkdir ${CLI_DIRECTORY}/.log
    CLI_LOG_FILE_INFO=${CLI_DIRECTORY}/.log/update-info
    [ ! -e ${CLI_LOG_FILE_INFO} ] && touch ${CLI_LOG_FILE_INFO}
    CLI_LOG_FILE_WARN=${CLI_DIRECTORY}/.log/update-warn
    [ ! -e ${CLI_LOG_FILE_WARN} ] && touch ${CLI_LOG_FILE_WARN}
    CLI_LOG_FILE_ERR=${CLI_DIRECTORY}/.log/update-err
    [ ! -e ${CLI_LOG_FILE_ERR} ] && touch ${CLI_LOG_FILE_ERR}
    CLI_LOG_FILE=/tmp/log/update
    [ ! -d ${CLI_LOG_FILE%/*} ] && mkdir -p ${CLI_LOG_FILE%/*}
    [ -e ${CLI_LOG_FILE} ] && rm ${CLI_LOG_FILE}
    # execute script
    ## Pre-execute script
    log-t START
    ## Execute install command
    source ${CLI_SHELL_DIRECTORY}/utils/libs.sh exec-script update
    ## Post-execute script
    log-t FINISH
}

function args {
    return 0
}

function short {
    echo "Execute package update script."
}

function help {
    echo "Execute package update script"
    echo ""
    echo "Options:"
    echo "    --help, -h        Show more command information."
    command-description ${BASH_SOURCE##*/}
}

# Execute script
"$@"
