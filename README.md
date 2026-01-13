[![Community Project header](https://github.com/newrelic/opensource-website/raw/master/src/images/categories/Community_Project.png)](https://opensource.newrelic.com/oss-category/#community-project)

# Linux package installation action

Github action that tests the correct installation of a given package and version in multiple Linux distributions.

## Inputs

| Key                        | Description |
| ---------------            | ----------- |
| `repo_base_url`            | Base URL to the rpm/yum/apt repository of NR. |
| `package_name`             | Name of the package. |
| `package_version`          | Version of the package to install and assert. |
| `gpg_key`                  | GPG key URL to verify package signatures. |
| `platforms`                | Comma separated list of platforms to test the installation into. |

## Available platforms

 - al2
 - al2023
 - centos7
 - centos8
 - debian-bullseye
 - debian-bookworm
 - debian-trixie
 - redhat8
 - redhat9
 - redhat10
 - suse15.2
 - suse15.3
 - suse15.4
 - suse15.5
 - suse15.6
 - suse15.7
 - ubuntu1604
 - ubuntu1804
 - ubuntu2004
 - ubuntu2204
 - ubuntu2404

## Example usage

```yaml
name: 🧬 Testing package installation
on:
  push:

jobs:
  molecule-packaging-tests:
    name: Launch molecule tests with infra-agent package
    runs-on: ubuntu-22.04
    steps:
      - uses: actions/checkout@v2

      - name: Testing that infra-agent package can be installed
        uses: newrelic/pkg-installation-testing-action@main
        with:
          repo_base_url: 'http://nr-downloads-ohai-staging.s3-website-us-east-1.amazonaws.com/infrastructure_agent'
          package_name: 'newrelic-infra'
          package_version: '1.71.0'
          gpg_key: 'https://download.newrelic.com/infrastructure_agent/gpg/newrelic-infra.gpg'
          platforms: "al2,al2022,centos7,centos8,debian-bullseye,redhat8,redhat9,suse15.2,suse15.3,suse15.4,suse15.5,suse15.6,suse15.7,ubuntu1604,ubuntu1804,ubuntu2004,ubuntu2204"
```


## Testing

The action uses Molecule to launch the Ansible roles into the different platforms container images. All the used images are uploaded to the repository's Github container registry so the user does not need to set its Docker credentials. If you perform changes to the docker images, you can generate a new molecule configuration file setting the environment variable `TESTING`:

```bash
$ TESTING=true ./prepare_platform.sh "centos7,centos8" 
```

## Contribute

We encourage your contributions to improve pkg-installation-testing-action! Keep in mind that when you submit your pull request, you'll need to sign the CLA via the click-through using CLA-Assistant. You only have to sign the CLA one time per project.

If you have any questions, or to execute our corporate CLA (which is required if your contribution is on behalf of a company), drop us an email at opensource@newrelic.com.

**A note about vulnerabilities**

As noted in our [security policy](../../security/policy), New Relic is committed to the privacy and security of our customers and their data. We believe that providing coordinated disclosure by security researchers and engaging with the security community are important means to achieve our security goals.

If you believe you have found a security vulnerability in this project or any of New Relic's products or websites, we welcome and greatly appreciate you reporting it to New Relic through [our bug bounty program](https://docs.newrelic.com/docs/security/security-privacy/information-security/report-security-vulnerabilities/).

If you would like to contribute to this project, review [these guidelines](./CONTRIBUTING.md).

To all contributors, we thank you!  Without your contribution, this project would not be what it is today.

## License
Pkg-installation-testing-action repository is licensed under the [Apache 2.0](http://apache.org/licenses/LICENSE-2.0.txt) License.
