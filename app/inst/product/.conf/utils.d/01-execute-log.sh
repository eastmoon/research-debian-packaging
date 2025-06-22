function log-t() {
    msg=${1}
    if [ ! -z ${CLI_LOG_FILE} ];
    then
        echo "INFO:${msg}" >> ${CLI_LOG_FILE}
    fi
}

function log-i() {
    msg=${1}
    echo-i ${msg}
    LOG_COUNT=`expr ${LOG_COUNT} + 1`
    if [ ! -z ${CLI_LOG_FILE} ];
    then
        if [ ! -z ${TARGET_SCRIPT} ]; then
            SCRIPT_NAME=${TARGET_SCRIPT##*/}
            SCRIPT_NAME=${SCRIPT_NAME%.*}
            echo "INFO:${TARGET_MODULE}:${MODULE_COUNT}%${MODULE_TOTAL}:${SCRIPT_NAME}:${LOG_COUNT}%${LOG_TOTAL}:${msg}" >> ${CLI_LOG_FILE}
        else
            echo "INFO:${TARGET_MODULE}:${MODULE_COUNT}%${MODULE_TOTAL}:${msg}" >> ${CLI_LOG_FILE}
        fi
    fi
}

function log-e() {
    msg=${1}
    echo-e ${msg}
    if [ ! -z ${CLI_LOG_FILE} ];
    then
        if [ ! -z ${TARGET_SCRIPT} ]; then
            SCRIPT_NAME=${TARGET_SCRIPT##*/}
            SCRIPT_NAME=${SCRIPT_NAME%.*}
            echo "ERROR:${TARGET_MODULE}:${SCRIPT_NAME}:${msg}" >> ${CLI_LOG_FILE}
        else
            echo "ERROR:${TARGET_MODULE}:${msg}" >> ${CLI_LOG_FILE}
        fi
    fi
}

## File operation
function fadd() {
    ADD_STR=${1}
    TARGET_FILE=${2}
    if [ -e ${TARGET_FILE} ];
    then
        if [ $(grep "${ADD_STR}" ${TARGET_FILE} | wc -l) -eq 0 ];
        then
            echo "${ADD_STR}" >> ${TARGET_FILE}
        else
            echo-w "\"${ADD_STR}\" was exist in ${TARGET_FILE}"
        fi
    else
        echo-e "[ ${BASH_SOURCE[1]}: line ${BASH_LINENO[0]} ] ${FUNCNAME[0]} : ${TARGET_FILE} not exist"
    fi
}
