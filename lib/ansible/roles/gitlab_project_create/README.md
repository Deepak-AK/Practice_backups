gitlab_project_create
=====================

This role creates a project in GitLab and then populates it with initial contents.
The role also configures Git on the system (`/etc/gitconfig` and `~/.git-credentials`) so that the user can use Git commands to access GitLab without having to authenticate each time.

The role pushes to the new GitLab project the initial content that you provide by setting the `gitlab_project_create_content` variable.
That variable provides the path to the directory that stores your initial content.
If you set the variable to `""` (empty), then no content is pushed.
By default, the role pushed a sample `README.md` file.

GitLab organizes the Git repositories in groups and projects.
A GitLab group can contain several projects (repositories).
The URL to access a project is built from the group and the project names:

```
https://git.lab.example.com/<group>/<project>.git
```

For example:

```
https://git.lab.example.com/rh293/my_webserver.git
```

The role creates the group (defined by the `gitlab_project_create_group` variable) if it does not exists.
The project (defined by the `gitlab_project_create_project_name` variable) is also created by the role.
However, if the project already exists, it is deleted first and then recreated.
This prevents obsolete data in the repository to conflict with new content for the exercise.

By default, the role does not create a project because the  `gitlab_project_create_project_name` variable is empty.
If you wish to create a project and push some content, then set the `gitlab_project_create_project_name` and `gitlab_project_create_content` variables.

See the `gls.utils.gitlab_project_destroy` role to cleanup the configuration (removing the project and the Git configuration on the system).
You typically should use that role at the end of the exercise.


Requirements
------------

A GitLab server must be available and a user account must be provided for the role to perform its configuration.
The user account must be able to create and modify groups.


Role Variables
--------------

The role accepts the following variables.

### GitLab API variables

* `gitlab_project_create_api_server`: The GitLab server DNS name. If using HTTPS, you must provide the FQDN to prevent TLS validation issues. **Do not** add the `http://` or `https://` prefix to that name.
  By default, `gitlab_project_create_api_server` is set to `git.ocp4.example.com`.
* `gitlab_project_create_api_scheme`: The URI scheme for accessing the GitLab API (`http` or `https`).
  Notice that to prevent issues with self-signed or expired certificates the role does not validate the certificate.
  By default, `gitlab_project_create_api_scheme` is set to `https`.
* `gitlab_project_create_api_username`: Username to use to connect to the GitLab API. The user you use must have rights to create and delete groups and projects.
  By default, `gitlab_project_create_api_username` is set to `root`.
* `gitlab_project_create_api_password`: Password to connect to the GitLab API.
  By default, `gitlab_project_create_api_password` is set to `RedHatGitlab`.


### Project variables

* `gitlab_project_create_group`: The GitLab group to create if it does not exist.
  The role creates the project in that group.
  The group you provide with that variable is automatically converted to lowercases (GitLab requirement).
  The `gitlab_project_create_group` is set to `training` by default.
* `gitlab_project_create_project_name`: The name of the project (repository) to create in the group.
  If the project already exists, it is first destroyed and then recreated.
  By default, `gitlab_project_create_project_name` is empty so no project is created.
* `gitlab_project_create_content`: The path to a directory that contains the initial contents you wish to push to the new project (Git repository).
  By default, a sample `README.md` file is pushed.
* `gitlab_project_create_user`: The GitLab user to associate to the GitLab group.
  That user becomes the owner of the group and gets full control over the group's projects.
  It is also stored (with the associated password) in the system Git configuration (`~/.git-credentials`) for the `student`, `devops`, and `root` Linux users so that those user can use the `git` command without having to authenticate to GitLab every time.
  The user must exist in GitLab before the role can use it.
  By default, `gitlab_project_create_user` is set to `developer`.
* `gitlab_project_create_pass`: The associated password.
  By default, `gitlab_project_create_pass` is set to `developer`.


Dependencies
------------

The role depends on the `community.general` collection for the GitLab modules and the `git_config` module.


Example Playbook
----------------

```yaml
---
- name: Creating and populating a project (repository) in GitLab
  hosts: workstation
  become: true
  gather_facts: false

  tasks:
    - name: Ensure the project exists in GitLab
      include_role:
        name: gls.utils.gitlab_project_create
      vars:
        gitlab_project_create_api_server: git.lab.example.com
        gitlab_project_create_api_username: root
        gitlab_project_create_api_password: AllYourBaseAreBelong
        gitlab_project_create_group: network-tools
        gitlab_project_create_project_name: router_config
        gitlab_project_create_user: operator1
        gitlab_project_create_pass: Sup3r53creT!
...
```

The `tests/` directory provides an additional example.


License
-------

GPL 3.0 or later.
