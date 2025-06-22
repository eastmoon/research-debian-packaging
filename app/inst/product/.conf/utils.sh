#
# Load all utils script in utils.d.
# utils script must split code into script file which filename is functional name.
#
if [ -d ${CLI_DIRECTORY}/.conf/utils.d ]; then
    for config_file in $(find ${CLI_DIRECTORY}/.conf/utils.d -type f -iname "[0-9]*-*.sh"); do
          source ${config_file}
    done
fi
