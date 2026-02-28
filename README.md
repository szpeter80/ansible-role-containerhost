<!-- markdownlint-disable MD012 -->

containerhost
=========

Install and configure a Linux host to run containers in userspace as systemd unit(s)

Errata
------------

- podman-compose.yaml have to be updated with correct host paths (eg actual user home).  
  Templating the creation of the compose file can solve this.

Requirements
------------

- A linux host (RHEL10 or compatible) reachable by Ansible via SSH  
  The bare minimum bootable setup is enough, the role will install the required packages

- If cloned from a template, regenerate ssh server keys  
(delete keys on RHEL, on Debian after keys delete you need to run `dpkg-reconfigure openssh-server`)

- copy ssh keys for passworldess connection
- register fqdn of the host to the DNS
- if you use DHCP, set a reservation
- check if time sync is avaiable  
- enable passwordless sudo  
`echo 'containeradmin        ALL=(ALL)       NOPASSWD: ALL' >/etc/sudoers.d/containeradmin_nopasswd`
  
- create your Ansible inventory
  - set `ansible_user` to the user which will run your containers.
    Ansible will use the same user to connect
  - set your `inventory_hostname` to the external fqdn of the host
    The role will set the hostname to the value of `inventory_hostname` (unless this function is disabled)


Role Variables
--------------

FIXME TODO

Until that, please see defaults/main.yml and vars/*


Dependencies
------------

None


Example Playbook
----------------

Contents of containerhost.yml:

```ansible
---
- hosts: my_containerhost
  roles:
    - role: containerhost
      vars:
        containerhost__container_project_name: dummy
      tags: example_tag

```

**Invocation:**  
`ansible-playbook -e containerhost__container_project_name=lampstack containerhost.yml`

**Update:**  
`ansible-playbook -e containerhost__container_project_name=lampstack -t update containerhost.yml`

License
-------

MIT

