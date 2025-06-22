function try()
{
    [[ $- = *e* ]]; SAVED_OPT_E=$?
    set +e
}

function catch()
{
    export ex_code=$?
    (( $SAVED_OPT_E )) && set +e
    return $ex_code
}

function throw()
{
    exit $1
}

function throwWarn()
{
    if [ -z ${@} ];
    then
        echo-w "[ ${BASH_SOURCE[1]}: line ${BASH_LINENO[0]} ] $(tail -n 1 ~/.runerr)"
    else
        echo-w "[ ${BASH_SOURCE[1]}: line ${BASH_LINENO[0]} ] ${@}"
    fi
}

function throwErrors()
{
    set -e
}

function ignoreErrors()
{
    set +e
}
