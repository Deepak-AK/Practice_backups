Role Name
=========

Use this role to install an operator.
This role creates a namespace for the operator (if a namespace does not already exist), it creates an operator group for the operator, and it creates a subscription for the operator.
Because this role is generic, it does not perform additional configuration required by many operators.

Courses using this role:
  - DO370

Requirements
------------

This role uses the redhat.openshift and kubernetes.core Ansible collections.
Your DLE must pre-install these Ansible collections on workstation.

Role Variables
--------------

    operators:
      name: The name of the operator (identified with `oc get packagemanifests`)
      namespace:
        name: The namespace where the operator will be installed.
      operator_group: The name of the operator group (frequently the same name as the operator).
      channel: oc get packagemanifest/MANIFEST -o jsonpath='{.status.defaultChannel}'
      source: oc get packagemanifest/MANIFEST -o jsonpath='{.metadata.labels.catalog}'
      installPlanApproval: "Automatic" (default) or "Manual"
      sourceNamespace: oc get packagemanifest/MANIFEST -o jsonpath='{.metadata.labels.catalog-namespace}' defaults to "openshift-marketplace"

Dependencies
------------

This role requires that you access the OpenShift cluster as a user with the cluster-admin role. The lab user on the utility machine can run commands as the system:admin user using the kubeconfig file located at /home/lab/ocp4/auth/kubeconfig.

Example Playbook
----------------

The following variables could be defined in `host_vars/utility`:

    ocp_cluster:
      host: "https://api.ocp4.example.com:6443"
      kubeconfig: /home/lab/ocp4/auth/kubeconfig
      validate_certs: False

    operators:
      lso:
        name: "local-storage-operator"
        namespace:
          name: "openshift-local-storage"
        operator_group: "openshift-local-storage"
        channel: "4.6"
        source: "redhat-operators"
  
Assuming the variables have been defined, the Local Storage Operator can be installed with:

    - name: Install the Local Storage Operator
      hosts: utility
      remote_user: lab
      gather_facts: False
      module_defaults:
        group/k8s:
          host: "{{ ocp_cluster['host'] }}"
          kubeconfig: "{{ ocp_cluster['kubeconfig'] }}"
          validate_certs: "{{ ocp_cluster['validate_certs'] }}"

      roles:
        - role: ocp-install-operator
          operator: "{{ operators['lso'] }}"

License
-------

BSD

Author Information
------------------

An optional section for the role authors to include contact information, or a website (HTML is not allowed).
