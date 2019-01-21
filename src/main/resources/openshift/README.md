# rhamt-ocp
Builder for the Red Hat Application Migration Toolkit on OpenShift Container Platform

# Prerequisites

- Access to a running OpenShift instance
- Client tools on your local machine (OpenShift 3.5+ supported)

# Usage

1. Connect to OpenShift with the command line tools. For example:
    `oc login`

2. Follow the prompts to connect to your local OpenShift instance

3. The default project name is `rhamt`. If someone else in your group is using this name already, this may be unsuitable. In that case, edit the [`deployment.properties`](deployment.properties) file to change the value of `OCP_PROJECT` from `rhamt` to a name that you prefer.

3. Execute `deploy.sh`

In case you're trying to use RHAMT on [OpenShift Online Starter](https://www.openshift.com/products/online/), you can try the [`deployment_openshift_online_starter.properties`](deployment_openshift_online_starter.properties) running the following commands:

1. `deploy.sh deployment_openshift_online_starter.properties`
2. changing the `rhamt-web-console-postgresql` container memory limit to be `256 MiB` in the OpenShift UI
