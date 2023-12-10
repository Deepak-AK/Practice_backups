gitlab_project_destroy
======================

This role removes a project from GitLab.
The role also removes the Git configuration on the system (`/etc/gitconfig` and `~/.git-credentials`).

This role is meant to be use in association with the `gls.utils.gitlab_project_create` role to revert the configuration to its original state.


Requirements
------------

A GitLab server must be available and a user account must be provided for the role to perform its configuration.
The user account must be able to delete projects in groups.


Role Variables
--------------

The role accepts the following variables.

### GitLab API variables

* `gitlab_project_destroy_api_server`: The GitLab server DNS name. If using HTTPS, you must provide the FQDN to prevent TLS validation issues. **Do not** add the `http://` or `https://` prefix to that name.
  By default, `gitlab_project_destroy_api_server` is set to `git.lab.example.com`.
* `gitlab_project_destroy_api_scheme`: The URI scheme for accessing the GitLab API (`http` or `https`).
  Notice that to prevent issues with self-signed or expired certificates the role does not validate the certificate.
  By default, `gitlab_project_destroy_api_scheme` is set to `https`.
* `gitlab_project_destroy_api_username`: Username to use to connect to the GitLab API. The user you use must have rights to create and delete groups and projects.
  By default, `gitlab_project_destroy_api_username` is set to `root`.
* `gitlab_project_destroy_api_password`: Password to connect to the GitLab API.
  By default, `gitlab_project_destroy_api_password` is set to `RedHatGitlab`.


### Project variables

* `gitlab_project_destroy_group`: The GitLab group that contains the project to delete.
  The `gitlab_project_destroy_group` is set to `training` by default.
* `gitlab_project_destroy_project_name`: The name of the project (repository) to delete from the group.
  By default, `gitlab_project_destroy_project_name` is empty so no project is destroyed.


Dependencies
------------

The role depends on the `community.general` collection for the GitLab modules.


Example Playbook
----------------

```yaml
---
- name: Deleting a project (repository) in GitLab
  hosts: workstation
  become: true
  gather_facts: false

  tasks:
    - name: Ensure the project is absent from GitLab
      include_role:
        name: gls.utils.gitlab_project_destroy
      vars:
        gitlab_project_destroy_api_server: git.lab.example.com
        gitlab_project_destroy_api_username: root
        gitlab_project_destroy_api_password: AllYourBaseAreBelong
        gitlab_project_destroy_group: network-tools
        gitlab_project_destroy_project_name: router_config
...
```

The `tests/` directory provides an additional example.


License
-------

GPL 3.0 or later.
