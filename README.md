containerhost
=========

Install and configure a Linux host to run containers in userspace as systemd unit(s)


Requirements
------------

- A linux host (RHEL10 or compatible) reachable by Ansible via SSH  
  The bare minimum bootable setup is enough, the role will install the required packages

- If cloned from a template, regenerate ssh server keys   
(delete keys on RHEL, on Debian after keys delete you need to run `dpkg-reconfigure openssh-server`)

- create your Ansible inventory
  - set `ansible_user` to the user which will run your containers. Ansible will use the same user to connect
  - set your `inventory_hostname` to the external fqdn of the host - the role will update the acual real hostname to the one set in the inventory, unless you disable this feature

- copy ssh keys for passworldess connection
- enable passwordless sudo  
`echo 'containeradmin        ALL=(ALL)       NOPASSWD: ALL' >/etc/sudoers.d/containeradmin_nopasswd`
- check if time sync is avaiable
- if you use DHCP, set a reservation
- register fqdn of the host to the DNS


Role Variables
--------------

FIXME TODO


Dependencies
------------

None


Example Playbook
----------------

Including an example of how to use your role (for instance, with variables passed in as parameters) is always nice for users too:

```
---
- hosts: my_containerhost
  roles:
    - role: containerhost
      vars:
        todo: fixme
      tags: example_tag
```


License
-------

MIT

