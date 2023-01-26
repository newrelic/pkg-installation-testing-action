#!/usr/bin/env bash


# So that when a command fails, bash exits.
set -o errexit

# This will make the script fail, when accessing an unset variable.
set -o nounset

# the return value of a pipeline is the value of the last (rightmost) command
# to exit with a non-zero status, or zero if all commands in the pipeline exit
# successfully.
set -o pipefail

# This helps in debugging your scripts. TRACE=1 ./script.sh
if [[ "${TRACE-0}" == "1" ]]; then set -o xtrace; fi



if [[ "${1-}" =~ ^-*h(elp)?$ ]]; then
    echo 'Usage: ./prepare_platform.sh "al2,al2022"
This is a bash script to make generate a Molecule configutaion.
'
    exit
fi

set_header() {
    yq -i '.dependency = {"name": "galaxy"}' $1
    yq -i '.driver = {"name": "docker"}' $1
}

set_platforms_config() {
    local PLATFORMS=$1
    local FILE_PATH=$2
    local IS_TESTING=${TESTING:-}

    for PLATFORM in ${PLATFORMS//,/ }
    do

        # set default platform values
        yq -i ".platforms += [{
            \"name\": \"$PLATFORM\",
            \"privileged\": true}]" $FILE_PATH

        if [[ ! -z "${IS_TESTING}" ]]; then
            yq -i ".platforms[] |= select(.name == \"$PLATFORM\") += {\"image\":\"$PLATFORM\", \"dockerfile\": \"./dockerfiles/$PLATFORM\"}" $FILE_PATH
        else
            yq -i ".platforms[] |= select(.name == \"$PLATFORM\") += {\"image\":\"ghcr.io/newrelic/pkg-installation-testing-action-$PLATFORM\"}" $FILE_PATH
        fi

        # debian based distributions need to set up the init command
        if [[ $PLATFORM =~ "debian" || $PLATFORM =~ "ubuntu" ]]; then
            yq -i ".platforms[] |= select(.name == \"$PLATFORM\") += {\"command\":\"/sbin/init\"}" $FILE_PATH
        fi

        # set python interpreter groups
        if [[ $PLATFORM == "al2" || $PLATFORM == "centos7" ]]; then
            yq -i ".platforms[] |= select(.name == \"$PLATFORM\") += {\"groups\": [\"python\"]}" $FILE_PATH
        else
            yq -i ".platforms[] |= select(.name == \"$PLATFORM\") += {\"groups\": [\"python3\"]}" $FILE_PATH
        fi

    done
}

set_footer() {
    local PLATFORMS=$1
    local FILE_PATH=$2
    yq -i '.provisioner = {"name": "ansible"}' $FILE_PATH
    yq -i '.provisioner.inventory.group_vars.python3 = {"ansible_python_interpreter": "python3"}' $FILE_PATH
    yq -i '.provisioner.inventory.group_vars.python = {"ansible_python_interpreter": "python"}' $FILE_PATH
    yq -i '.provisioner.env = {"ANSIBLE_ROLES_PATH": "../../roles"}' $FILE_PATH
}

main() {
    local PLATFORMS=$1
    local MOLECULE_FILE_PATH="${GITHUB_ACTION_PATH:-.}/molecule/default/molecule.yml"

    echo '' > $MOLECULE_FILE_PATH
    set_header $MOLECULE_FILE_PATH
    set_platforms_config $PLATFORMS $MOLECULE_FILE_PATH
    set_footer $PLATFORMS $MOLECULE_FILE_PATH
}

main "$@"
