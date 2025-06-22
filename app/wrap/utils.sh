# Declare function
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
