# rhamt-ocp
Builder for the Red Hat Application Migration Toolkit on OpenShift Container Platform

# Prerequisites

- Access to a running OpenShift instance
- Client tools on your local machine (OpenShift 3.5+ supported)

# Usage

1. Connect to OpenShift with the command line tools. For example:
    `oc login`

2. Follow the prompts to connect to your local OpenShift instance

3. The default application name is "rhamt". If someone else in your group is using this name already, this may be unsuitable. In that case, edit the "deploy.sh" to change the value of OCP_PROJECT from "rhamt" to a name that you prefer.

3. Execute "deploy.sh"
