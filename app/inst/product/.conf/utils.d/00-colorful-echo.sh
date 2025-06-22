function echo-a() {
    echo -e "\033[90m[`date -Iseconds`]\033[0m ${@}"
    if [ ! -z ${CLI_LOG_FILE_ERR} ] && [ -e ${CLI_LOG_FILE_ERR} ];
    then
        echo -e "[`date -Iseconds`] ${@}" >> ${CLI_LOG_FILE_ERR}
    fi
    if [ ! -z ${CLI_LOG_FILE_INFO} ] && [ -e ${CLI_LOG_FILE_INFO} ];
    then
        echo -e "[`date -Iseconds`] ${@}" >> ${CLI_LOG_FILE_INFO}
    fi
    if [ ! -z ${CLI_LOG_FILE_WARN} ] && [ -e ${CLI_LOG_FILE_WARN} ];
    then
        echo -e "[`date -Iseconds`] ${@}" >> ${CLI_LOG_FILE_WARN}
    fi
}

function echo-e() {
    echo -e "\033[31m[`date -Iseconds`]\033[0m ${@}"
    if [ ! -z ${CLI_LOG_FILE_ERR} ] && [ -e ${CLI_LOG_FILE_ERR} ];
    then
        echo -e "[`date -Iseconds`] ${@}" >> ${CLI_LOG_FILE_ERR}
    fi
}

function echo-i() {
    echo -e "\033[32m[`date -Iseconds`]\033[0m ${@}"
    if [ ! -z ${CLI_LOG_FILE_INFO} ] && [ -e ${CLI_LOG_FILE_INFO} ];
    then
        echo -e "[`date -Iseconds`] ${@}" >> ${CLI_LOG_FILE_INFO}
    fi
}

function echo-w() {
    echo -e "\033[33m[`date -Iseconds`]\033[0m ${@}"
    if [ ! -z ${CLI_LOG_FILE_WARN} ] && [ -e ${CLI_LOG_FILE_WARN} ];
    then
        echo -e "[`date -Iseconds`] ${@}" >> ${CLI_LOG_FILE_WARN}
    fi
}
