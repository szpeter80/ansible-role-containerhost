<!-- markdownlint-disable MD012 -->

containerhost
=============

Install and configure a Linux host to run containers in userspace as systemd unit(s)

TODO
----

- refactor haproxy to include the ansible inventory name/address in the self signed cert


Errata
------------

None known at this time.

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

For the comprehensive list, please see `defaults/main.yml` and `vars/*`.

Valid project names:

- nw_haproxy: HAProxy for listening on tcp/80 + tcp/443

- db_postgresql: PostgreSQL database and a dumping containers


Example Playbook
----------------

Contents of containerhost.yml:

```ansible
---
- hosts: my_containerhost
  roles:
    - role: containerhost
      vars:
        # Set host timezone
        containerhost__time_zone: "Europe/Budapest"

        # Set host hostname to inventory hostname
        containerhost__enforce_inventory_hostname: true

        # Install fail2ban to protect SSH
        containerhost__enable_fail2ban: true

        # This specifies which container project to use
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

