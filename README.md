# TRex traffic generator Ansible installer

## Description

WARNING: This is early work in progress stage. It does only some of intented funcionality and may be full of bugs. Be aware of that.

This repo includes Ansible code to setup/download/install [TRex Traffic Generator](https://trex-tgn.cisco.com). It uses custom Docker image, built on top of CentOS. It should run on modern Ubuntu, CentOS, Fedora (however in case of Fedora - you may need to enforce `ansible_python_interpreter=python3` and tune or disable SELinux). It will not work on Debian.

Bear in mind that running TRex in docker container requires root privileges due to fact that it needs to compile and insert DPDK module (thus kernel headers must exist in /usr/src of host). It also needs configure or replace existing network device drivers. Thus, it's runs privileged and with all Linux CAPs included. You're warned now.

Compiling modules in docker with one toolchain (CentOS in this case) agains underlying kernel build with presumably another compiler is problematic. And because of that it seems like we need to rewrite Ansible code and forget about Docker. That will probably happen in future versions.

Multiple machines may be set up with installer, although we don't use them for now (yet).

## Requirements

* Modern Linux Ubuntu, Fedora or CentOS bare metal or virtual machine with Docker daemon, [Docker SDK](https://docker-py.readthedocs.io/en/stable/) and kernel headers properly installed,
* [Ansible](https://www.ansible.com/) 2.8 or newer on your laptop or any management host where you're going to run it.

## Usage

Ansible directory contains two playbooks:

* libvirt.yml - launches TRex virtual machines based on Ubuntu cloud image on libvirt. For now it is controlled by `libvirt_trex_vm_count` variable which say how many instances are launched on each libvirt host (it defaults to 1). Libvirt with python-libvirt on target machines is required for this playbook to work.
* system.yml - Sets up system dependiences:
  * kernel headers, modules, python pip,
  * Docker daemon and python API library
* trex.yml - downloads and launches Docker container with TRex in interactive mode.

*IMPORTANT:* Running system.yml playbook may *damage* your docker installation, if you already have one. Run it on fresh systems only. The same applies to setup-all.yml playbook, which imports above playbooks.

To run Ansible playbooks, you need to prepare inventory and add your host(s) to [trex] group.

Run it in a standard way:

    ansible-playbook -i inventory/example/ libvirt.yml -e @extra/vars.yml
    ansible-playbook -i inventory/example/ system.yml
    ansible-playbook -i inventory/example/ trex.yml

You can also specify parts of playbook with tags (run with --list-tags to see available tags).

To force recreation of TRex containers add `-e trex_force_recreate=true` in command line.

## Configuration

You can customize `ansible/inventory/*/group_vars/all.yml` file in your inventory dir, or create host vars per host. See attached examples.

Supported parameters:

* `trex_docker_image` - trex docker image registry, defaults to codilimecom/trex:latest.
* `trex_dpdk_pci_interfaces` - this list of interfaces for machine to be set up by DPDK. It takes the form of PCI ids, like '00:06.0' or '00:07.0'.
* `trex_docker_published_ports` - list of published ports. Defaults to 4500, 4501 and 4507 on 127.0.0.1. Takes form of list of IP:hostport:containerport, for example "[ '0.0.0.0:4500:4500', '0.0.0.0:4501:4501' ]".
