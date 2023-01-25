#!/bin/bash

PLATFORMS=$1

echo "
---
dependency:
  name: galaxy
driver:
  name: docker
platforms:" > "${GITHUB_ACTION_PATH}/molecule/default/molecule.yml"


# this will collide with al-2022 🤔
# if [[ "$PLATFORMS" == *"al-2"* ]]; then
# echo "
#   - name: al-2
#     image: al-2
#     dockerfile: al2.Dockerfile
#     privileged: true
#     environment: { container: docker }
#     groups:
#       - testing_hosts_linux" >> "${GITHUB_ACTION_PATH}/molecule/default/molecule.yml"
# fi

if [[ "$PLATFORMS" == *"al-2022"* ]]; then
echo "
  - name: al-2022
    image: ghcr.io/newrelic/pkg-installation-testing-action-al2022:latest
    privileged: true
    environment: { container: docker }
    groups:
      - testing_hosts_linux" >> "${GITHUB_ACTION_PATH}/molecule/default/molecule.yml"
fi

if [[ "$PLATFORMS" == *"centos-7"* ]]; then
echo "
  - name: centos-7
    image: ghcr.io/newrelic/pkg-installation-testing-action-centos7:latest
    privileged: true
    environment: { container: docker }
    groups:
      - testing_hosts_linux" >> "${GITHUB_ACTION_PATH}/molecule/default/molecule.yml"
fi

if [[ "$PLATFORMS" == *"centos-8"* ]]; then
echo "
  - name: centos-8
    image: ghcr.io/newrelic/pkg-installation-testing-action-centos8:latest
    privileged: true
    environment: { container: docker }
    groups:
      - testing_hosts_linux" >> "${GITHUB_ACTION_PATH}/molecule/default/molecule.yml"
fi

if [[ "$PLATFORMS" == *"debian-bullseye"* ]]; then
echo "
  - name: debian-bullseye
    image: ghcr.io/newrelic/pkg-installation-testing-action-debian-bullseye:latest
    command: \"/sbin/init\"
    privileged: true
    environment: { container: docker }
    groups:
      - testing_hosts_linux" >> "${GITHUB_ACTION_PATH}/molecule/default/molecule.yml"
fi

if [[ "$PLATFORMS" == *"debian-buster"* ]]; then
echo "
  - name: debian-buster
    image: ghcr.io/newrelic/pkg-installation-testing-action-debian-buster:latest
    command: \"/sbin/init\"
    privileged: true
    environment: { container: docker }
    groups:
      - testing_hosts_linux" >> "${GITHUB_ACTION_PATH}/molecule/default/molecule.yml"
fi

if [[ "$PLATFORMS" == *"redhat-8"* ]]; then
echo "
  - name: redhat-8
    image: ghcr.io/newrelic/pkg-installation-testing-action-redhat8:latest
    privileged: true
    environment: { container: docker }
    groups:
      - testing_hosts_linux" >> "${GITHUB_ACTION_PATH}/molecule/default/molecule.yml"
fi

if [[ "$PLATFORMS" == *"redhat-9"* ]]; then
echo "
  - name: redhat-9
    image: ghcr.io/newrelic/pkg-installation-testing-action-redhat9:latest
    privileged: true
    environment: { container: docker }
    groups:
      - testing_hosts_linux" >> "${GITHUB_ACTION_PATH}/molecule/default/molecule.yml"
fi

if [[ "$PLATFORMS" == *"suse-15.2"* ]]; then
echo "
  - name: suse15.2
    image: ghcr.io/newrelic/pkg-installation-testing-action-suse15.2:latest
    privileged: true
    environment: { container: docker }
    groups:
      - testing_hosts_linux" >> "${GITHUB_ACTION_PATH}/molecule/default/molecule.yml"
fi

if [[ "$PLATFORMS" == *"suse-15.3"* ]]; then
echo "
  - name: suse15.3
    image: ghcr.io/newrelic/pkg-installation-testing-action-suse15.3:latest
    privileged: true
    environment: { container: docker }
    groups:
      - testing_hosts_linux" >> "${GITHUB_ACTION_PATH}/molecule/default/molecule.yml"
fi

if [[ "$PLATFORMS" == *"suse-15.4"* ]]; then
echo "
  - name: suse15.4
    image: ghcr.io/newrelic/pkg-installation-testing-action-suse15.4:latest
    privileged: true
    environment: { container: docker }
    groups:
      - testing_hosts_linux" >> "${GITHUB_ACTION_PATH}/molecule/default/molecule.yml"
fi


if [[ "$PLATFORMS" == *"ubuntu-1604"* ]]; then
echo "
  - name: ubuntu-1604
    image: ghcr.io/newrelic/pkg-installation-testing-action-ubuntu1604:latest
    command: \"/sbin/init\"
    privileged: true
    environment: { container: docker }
    groups:
      - testing_hosts_linux" >> "${GITHUB_ACTION_PATH}/molecule/default/molecule.yml"
fi

if [[ "$PLATFORMS" == *"ubuntu-1804"* ]]; then
echo "
  - name: ubuntu-1804
    image: ghcr.io/newrelic/pkg-installation-testing-action-ubuntu1804:latest
    command: \"/sbin/init\"
    privileged: true
    environment: { container: docker }
    groups:
      - testing_hosts_linux" >> "${GITHUB_ACTION_PATH}/molecule/default/molecule.yml"
fi

if [[ "$PLATFORMS" == *"ubuntu-2004"* ]]; then
echo "
  - name: ubuntu-2004
    image: ghcr.io/newrelic/pkg-installation-testing-action-ubuntu2004:latest
    command: \"/sbin/init\"
    privileged: true
    environment: { container: docker }
    groups:
      - testing_hosts_linux" >> "${GITHUB_ACTION_PATH}/molecule/default/molecule.yml"
fi

if [[ "$PLATFORMS" == *"ubuntu-2204"* ]]; then
echo "
  - name: ubuntu-2204
    image: ghcr.io/newrelic/pkg-installation-testing-action-ubuntu2204:latest
    command: \"/sbin/init\"
    privileged: true
    environment: { container: docker }
    groups:
      - testing_hosts_linux" >> "${GITHUB_ACTION_PATH}/molecule/default/molecule.yml"
fi

echo "
provisioner:
  name: ansible
  inventory:
    host_vars:
      al-2:
        ansible_python_interpreter: python
      al-2022:
        ansible_python_interpreter: python3
      centos-7:
        ansible_python_interpreter: python
      centos-8:
        ansible_python_interpreter: python3
      debian-bullseye:
        ansible_python_interpreter: python3
      debian-buster:
        ansible_python_interpreter: python3
      redhat-8:
        ansible_python_interpreter: python3
      redhat-9:
        ansible_python_interpreter: python3
      suse15.2:
        ansible_python_interpreter: python3
      suse15.3:
        ansible_python_interpreter: python3
      suse15.4:
        ansible_python_interpreter: python3
      ubuntu-1604:
        ansible_python_interpreter: python3
      ubuntu-1804:
        ansible_python_interpreter: python3
      ubuntu-2004:
        ansible_python_interpreter: python3
      ubuntu-2204:
        ansible_python_interpreter: python3
  env:
    ANSIBLE_ROLES_PATH: \"../../roles\"
verifier:
  name: ansible
" >> "${GITHUB_ACTION_PATH}/molecule/default/molecule.yml"
