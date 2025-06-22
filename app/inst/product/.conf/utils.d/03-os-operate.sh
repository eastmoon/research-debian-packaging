function system-runner() {
    SERVICE_NAME=${1}
    EXEC_COMMAND=${2}
    if [ $( systemctl list-units --full -all 2>/dev/null | grep " ${SERVICE_NAME}.service" | wc -l ) -eq 0 ];
    then
        echo-e "[ ${BASH_SOURCE[1]}: line ${BASH_LINENO[0]} ] ${FUNCNAME[0]} : ${SERVICE_NAME} not found in systemctl"
        return 1 # fail
    fi
    if [ $( systemctl is-enabled "${SERVICE_NAME}.service" 2>/dev/null | grep enabled | wc -l ) -eq 0 ];
    then
        echo-w "[ ${BASH_SOURCE[1]}: line ${BASH_LINENO[0]} ] ${FUNCNAME[0]} : ${SERVICE_NAME} not enable in systemctl"
    fi
    return 0 # success
}

function command-runner() {
    COMMAND_NAME=${1}
    EXEC_COMMAND=${2}
    if [ $(command -v ${COMMAND_NAME} | wc -l) -eq 0 ];
    then
        echo-e "[ ${BASH_SOURCE[1]}: line ${BASH_LINENO[0]} ] ${FUNCNAME[0]} : ${COMMAND_NAME} is not exist"
        return 1
    fi
    return 0
}

function try-file() {
    if [ ! -e ${1} ];
    then
        msg="[ ${BASH_SOURCE[1]}: line ${BASH_LINENO[0]} ] ${IOT_SERVICE_FILE} not exist"
        if [ ! -z ${2} ] && [ "${2}" == "err" ];
        then
            echo-e ${msg}
        else
            echo-w ${msg}
        fi
        return 1
    fi
    return 0
}

function copy() {
    SOURCE=${1}
    DESTINATION=${2}
    if [ -d ${SOURCE} ];
    then
        [ ! -d ${DESTINATION} ] && mkdir -p ${DESTINATION}
        ## Copy files
        /bin/cp -Rf ${SOURCE}/. ${DESTINATION} 2>/dev/null || :
    elif [ -f ${SOURCE} ];
    then
        [ ! -d ${DESTINATION} ] && mkdir -p ${DESTINATION}
        ## Copy file
        /bin/cp -f ${SOURCE} ${DESTINATION} 2>/dev/null || :
    fi
}
