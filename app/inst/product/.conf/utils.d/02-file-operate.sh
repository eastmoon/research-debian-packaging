function freplace() {
    ORIGINAL_STR=${1}
    REPLACE_STR=${2}
    TARGET_FILE=${3}
    if [ -e ${TARGET_FILE} ];
    then
        if [ $(grep "${REPLACE_STR}" ${TARGET_FILE} | wc -l) -eq 0 ];
        then
            sed -i "s/${ORIGINAL_STR}/${REPLACE_STR}/g" ${TARGET_FILE}
        else
            echo-w "\"${REPLACE_STR}\" was exist in ${TARGET_FILE}"
        fi
    else
        echo-e "[ ${BASH_SOURCE[1]}: line ${BASH_LINENO[0]} ] ${FUNCNAME[0]} : ${TARGET_FILE} not exist"
    fi
}

function fempty() {
    TARGET_FILE=${1}
    if [ -e ${TARGET_FILE} ];
    then
        sed -i '$ d' ${TARGET_FILE}
    else
        echo-e "[ ${BASH_SOURCE[1]}: line ${BASH_LINENO[0]} ] ${FUNCNAME[0]} : ${TARGET_FILE} not exist"
    fi
}
