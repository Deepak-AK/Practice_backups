Role Name
=========

This role customizes the Local Storage Operator for use with OpenShift Container Storage. This role creates a local volume discovery resource that automatically detects partitions and devices on identified nodes. This role also creates a local volume set resource.

Courses using this role:
  - DO370

Requirements
------------

This role uses the redhat.openshift and kubernetes.core Ansible collections.
Your DLE must pre-install these Ansible collections on workstation.

Role Variables
--------------

    additional_devices: 2 # The expected number of Available storage devices on each node.
    localvolumeset: # The main variable references in tasks and templates
      name: lso-volumeset # The name of the local volume set. Choose any name.
      namespace: openshift-local-storage # The namespace where the Local Storage Operator is installed (`openshift-local-storage` by default).
      deviceTypes: # A list of device types that can be used.
        - disk # Include full disks. Delete if you do not want to include full disks.
        - part # Include partitions. Delete if you do not want to include partitions.
      minSize: 0Ti # Allows you to specify a minimum size. Set to `0Ti` to include any size.
      storageClassName: lso-volumeset # The name of the storage class that will be created. Using the web console, the storage class name defaults to being the same name as the local volume set.
      volumeMode: Block # Defaults to `Block`, but can be `Filesystem`.
      nodes: # A list of nodes that will be used for storage. These nodes must have either free disks or free partitions that can be used.
        - worker01
        - worker02
        - worker03

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

    localvolumeset:
      name: lso-volumeset
      namespace: "{{ operators['lso']['namespace']['name'] }}"
      deviceTypes:
        - disk
        - part
      minSize: 0Ti
      storageClassName: lso-volumeset
      volumeMode: Block
      nodes: "{{ storage_nodes }}"

Assuming the variables have been defined, the Local Storage Operator can be installed and configured with:

    - name: Install and configure the Local Storage Operator
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
        - role: ocp-localvolumes

License
-------

BSD

Author Information
------------------

An optional section for the role authors to include contact information, or a website (HTML is not allowed).
