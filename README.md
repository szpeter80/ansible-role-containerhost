<!-- markdownlint-disable MD012 -->
containerhost
=============

Install and configure a Linux host to run rootless podman containers as systemd unit(s).
In order for a working setup, you need to install multiple projects, eg `nw_haproxy` + `db_postgresql` + `zabbix`

TODO
----

- document project dependencies or the absence of them (eg. Gitlab brings its own PostgreSQL, but Zabbix not)
- check/verify if all the required tasks have the "update" tag


Usage
-----

1. Prepare a linux host ("managed host", RHEL10 or compatible, 2 CPU, 8G RAM, 100G storage with pleanty space on /home)
  1. it should be reachable via SSH by Ansible
  1. A minimum package selection is enouh, the role will install the required packages
  1. If cloned from a template, regenerate ssh server keys.  
    On RHEL10, simply delete server keys, those will be re-generated.
    On Debian, after keys deleted you need to run `dpkg-reconfigure openssh-server`
  1. register FQDN of the host to the DNS
  1. if you use DHCP, set a reservation
  1. check if time sync is enabled and working
  1. copy ssh keys for passworldess connection
  1. enable passwordless sudo  
    `echo 'containeradmin        ALL=(ALL)       NOPASSWD: ALL' >/etc/sudoers.d/containeradmin_nopasswd`

1. Create a workspace directory on the host (control), which you will use to run automation.  
  This is not your "managed host".
  1. Install Ansible, any method is fine. A venv example:
    ```bash
    python -m venv ./venv
    . ./venv/bin/activate
    pip install --upgrade pip
    pip install ansible
    ansible --version
    ```
  1. create subfolders `mkdir -p ./roles/containerhost` (this will hold the role)
  1. clone the role from git  
  `git clone https://github.com/szpeter80/ansible-role-containerhost.git ./roles/containerhost/`

1. Create your Ansible inventory
  1. set your `inventory_hostname` to the FQDN of the host
    The role will update the hostname to the value of `inventory_hostname` (unless this function is disabled)
  1. example for INI-style, named `inventory.txt`  
    ```ini
    my-host.example.com ansible_user=admin
    ```
1. Create your Ansible configuration
  1. example for `ansible.cfg`  
    ```ini
    [defaults]
    inventory=inventory.txt
    roles_path=./roles:/etc/ansible/roles
    interpreter_python=auto_silent
    ```
1. create a playbook (eg `containerhost.yml`)
  ```yaml
  ---
  - name: Install containerhost project
    hosts: all
    roles:
      - role: containerhost
        vars:
          # Override role variables
          # For the comprehensive list, please see `defaults/main.yml` and `vars/*`
          containerhost__time_zone: "Europe/Budapest"
          containerhost__enforce_inventory_hostname: true
          containerhost__enable_fail2ban: true
          containerhost__container_project_name: dummy
        tags: example_tag
  ```

1. Run your automation
  1. Override the dummy project on the command line, to deploy project `nw_haproxy`  
    ```bash
    ansible-playbook -e containerhost__container_project_name=nw_haproxy containerhost.yml
    ```
  1. If you change some parameters, you can save time and skip some parts (eg package installation)
    ```bash
    ansible-playbook -e containerhost__container_project_name=dummy -t update containerhost.yml`
    ```


Valid project names:

- **nw_haproxy**: HAProxy for listening on tcp/80 + tcp/443
- **db_postgresql**: PostgreSQL database and a container to periodically dump the database
- **db_mariadb**: MariaDB database, PHPMyadmin and a container to periodically dump the database
- **gitlab_ce**: Gitlab CE
- **lampstack**: PHP-FPM + NGINX to run PHP apps
- **rclone**: headless container to sync cloud data to local
- **sonatype_nexus_ce**: Sonatype Nexus container registry
- **zabbix**: Zabbix, all components (except proxy): server, web UI, agent2, PDF report maker


License
-------

MIT
