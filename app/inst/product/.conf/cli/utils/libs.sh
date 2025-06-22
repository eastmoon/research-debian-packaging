#!/bin/bash
set -e

# ------------------- Common Command method -------------------

function exec-script() {
    # Declare variable
    CLI_COMMAND=${1}

    # Execute script
    ## Declare variable from .runrc
    [ -e ${CLI_DIRECTORY}/.conf/.runrc ] && source ${CLI_DIRECTORY}/.conf/.runrc
    ## Retieve application cli information directory
    PACKAGE_APP_CLI_INFO_DIR=${APP_CLI_DIR}/info/${PACKAGE_CLI_INFO_NAME}
    ## clear error log file when script execute
    [ -e ~/.runerr ] && rm ~/.runerr
    ## .conf/.attribute will give all shell global variable setting.
    ## .conf/.runmodule is first condition, if file exist, run.sh will by order run directory which defined in file.
    ## .conf/.runignore is second condition, when first condition was lost, alway execute second condition, and it will run all directory which not defined in file.
    cd ${CLI_DIRECTORY}
    if [ -e .conf/.runmodule ];
    then
        MODULE_TOTAL=$(cat .conf/.runmodule | wc -l)
        MODULE_COUNT=0
        for subdir in $(cat .conf/.runmodule)
        do
            MODULE_COUNT=`expr ${MODULE_COUNT} + 1`
            exec-module-script ${subdir} ${CLI_COMMAND}
        done
    fi
    ## Show error message, if error check was not "throw" mode,
    if [ "${EXECUTE_ERROR_CHECK}" != "throw" ] && [ $(cat ~/.runerr | wc -l) -gt 0 ]; then
        echo-e "All error logger :\n $(cat ~/.runerr)"
    fi
}

function exec-module-script() {
    TARGET_MODULE=${1}
    COMMAND_SCRIPT=${2}
    log-t "execute module ${TARGET_MODULE}"
    if [ -z ${EXECUTE_MODULE} ] || [ "${EXECUTE_MODULE}" == ${TARGET_MODULE} ];
    then
        if [ -e ${CLI_DIRECTORY}/${TARGET_MODULE}/${COMMAND_SCRIPT}.sh ];
        then
            echo-a "========== Run ${COMMAND_SCRIPT} command in ${TARGET_MODULE} module =========="
            cd ${CLI_DIRECTORY}/${TARGET_MODULE}
            # Initial log information
            TARGET_SCRIPT=entrypoint
            LOG_COUNT=0
            LOG_TOTAL=0
            SCRIPT_TARGET="./${COMMAND_SCRIPT}.sh"
            SCRIPT_LIST=
            while [[ ! -z ${SCRIPT_TARGET} ]]; do
                SCRIPT_LIST="${SCRIPT_LIST} ${SCRIPT_TARGET}"
                SEARCH_RESULT=
                for target_script in ${SCRIPT_TARGET[@]}; do
                    for source_file in $(grep '^exec-source' ${target_script} | awk '{print $2}'); do
                        SEARCH_RESULT="${SEARCH_RESULT} ${source_file}"
                    done
                done
                SCRIPT_TARGET="${SEARCH_RESULT}"
            done
            for target_script in ${SCRIPT_LIST[@]}; do
                LOG_RESULT=`grep '^log-i' ${target_script} | wc -l`
                [ ${LOG_RESULT} -gt 0 ] && LOG_TOTAL=`expr ${LOG_TOTAL} + ${LOG_RESULT}`
            done
            # Execute module entrypoint script
            try
            (
                [ "${EXECUTE_ERROR_CHECK}" == "throw" ] && throwErrors || ignoreErrors
                source ${COMMAND_SCRIPT}.sh
            ) 2>> ~/.runerr
            catch || {
                # now you can handle
                case $ex_code in
                    *)
                        echo-e "An exception was thrown when ${COMMAND_SCRIPT} execute \nError : $(cat ~/.runerr)"
                    ;;
                esac
            }
        fi
        cd ${CLI_DIRECTORY}
    fi
}

function exec-source() {
    TARGET_SCRIPT=${1}
    log-t "execute source ${TARGET_SCRIPT}"
    if [ -e ${TARGET_SCRIPT} ];
    then
        echo-i "Execute source script : ${TARGET_SCRIPT}"
        source ${TARGET_SCRIPT}
    else
        echo-e "[ ${BASH_SOURCE}: line ${LINENO} ] Target ${TARGET_SCRIPT} not exist."
    fi
}

# ------------------- Execute script -------------------
"$@"
