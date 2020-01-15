###############
Ouranos-ansible
###############

Configuration management for Ouranos servers.

.. contents::


Setup
=====

* `Install Ansible`_ version 2.6 or newer on your machine.  Ansible do not need
  to be installed on any of the hosts you need to manage.

* Run `download-ansible-galaxy-roles.sh`_ to download the other roles this
  playbook needs.

.. _Install Ansible:
    https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html

.. _download-ansible-galaxy-roles.sh:
    download-ansible-galaxy-roles.sh


Assumptions
===========

* You have ssh login as root on all the hosts you need to manage.
  
* Ssh login without password using ssh keys is a must since during one single
  play, Ansible will make many ssh connections, you do not want to have to
  re-type your password manually each and every time.


Usage
=====

Use the wrapper script `ansible/run-ansible-playbook`_ to avoid having to type several
``ansible-play`` options over and over again.  All valid ``ansible-play``
options can be given to the wrapper script, it will forward those options to
``ansible-play``.

Example::

  cd ansible

  # dry-run (no "force"), all hosts, all roles
  ./run-ansible-playbook /path/to/inventory_file

  # for real, all hosts, all roles
  ./run-ansible-playbook /path/to/inventory_file force

  # for real, only gitlab-ci and docker tags for all hosts
  ./run-ansible-playbook /path/to/inventory_file force -t gitlab-ci,docker

  # for real, only gitlab-ci and docker tags, only for hosts gitlab and jenkins
  ./run-ansible-playbook /path/to/inventory_file force -t gitlab-ci,docker -l gitlab,jenkins

.. _ansible/run-ansible-playbook:
    ansible/run-ansible-playbook


Design Notes
============

Try to re-use exiting roles from `Ansible Galaxy`_ instead of writing our own.
But to ensure reproducibility, we need to pin the exact version we use in
`ansible-requirements.yml`_ (used by `download-ansible-galaxy-roles.sh`_).

The directory layout is following Ansible suggested `best practices`_.

`ansible/site.yml`_ provides a very good overview of what are being done on each hosts
(roles used), the list of hosts on the current site and list of tags available
to filter which roles to run.

All private secrets and exact hostnames are in the inventory file.  The
hostnames in `ansible/site.yml`_ are pseudo hostnames.  See
`ansible/sample-inventory`_.

Roles should try to be as generic/re-usable as much as possible, as the other
roles we re-use from `Ansible Galaxy`_.

.. _Ansible Galaxy:
    https://galaxy.ansible.com/

.. _best practices:
    https://docs.ansible.com/ansible/latest/user_guide/playbooks_best_practices.html#directory-layout

.. _ansible-requirements.yml:
    ansible-requirements.yml

.. _ansible/site.yml:
    ansible/site.yml

.. _ansible/sample-inventory:
    ansible/sample-inventory


References
=========

* `Ansible Documentation <http://docs.ansible.com/>`_
