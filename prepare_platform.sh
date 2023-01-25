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
    echo 'Usage: ./script.sh arg-one arg-two
This is an awesome bash script to make your life better.
'
    exit
fi

set_header() {
echo "
---
dependency:
  name: galaxy
driver:
  name: docker
platforms:" > $1
}

set_platforms_config() {
    local PLATFORMS=$1
    local FILE_PATH=$2
    local IS_TESTING=${TESTING:-}

    for PLATFORM in ${PLATFORMS//,/ }
    do
        echo "  - name: ${PLATFORM}" >> ${FILE_PATH}

        if [[ ! -z "${IS_TESTING}" ]]; then
            echo "    image: ${PLATFORM}" >> ${FILE_PATH}
            echo "    dockerfile: ./dockerfiles/${PLATFORM}" >> ${FILE_PATH}
        else
            echo "    image: ghcr.io/newrelic/pkg-installation-testing-action-${PLATFORM}:latest" >> ${FILE_PATH}
        fi

        if [[ $PLATFORM =~ "debian" || $PLATFORM =~ "ubuntu" ]]; then
            echo "    command: \"/sbin/init\"" >> ${FILE_PATH}
        fi

        echo "    privileged: true
    environment: { container: docker }
    groups:
      - testing_hosts_linux" >> ${FILE_PATH}
    done
}

set_footer() {
    local PLATFORMS=$1
    local FILE_PATH=$2

echo "
provisioner:
  name: ansible
  inventory:
    host_vars:" >> $FILE_PATH

    for PLATFORM in ${PLATFORMS//,/ }
    do
        echo "      ${PLATFORM}:" >> ${FILE_PATH}
        if [[ $PLATFORM == "al2" || $PLATFORM == "centos7" ]]; then
            echo "        ansible_python_interpreter: python" >> ${FILE_PATH}
        else
            echo "        ansible_python_interpreter: python3" >> ${FILE_PATH}
        fi
    done

echo "  env:
    ANSIBLE_ROLES_PATH: \"../../roles\"
verifier:
  name: ansible
" >> $FILE_PATH
}


main() {
    local MOLECULE_FILE_PATH="${GITHUB_ACTION_PATH}/molecule/default/molecule.yml"
    local PLATFORMS=$1
    set_header $MOLECULE_FILE_PATH
    set_platforms_config $PLATFORMS $MOLECULE_FILE_PATH
    set_footer $PLATFORMS $MOLECULE_FILE_PATH
}

main "$@"
