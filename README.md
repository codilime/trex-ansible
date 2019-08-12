# TRex traffic generator Ansible installer

TRex Ansible is an experimental deployer of [TRex Traffic Generator](https://trex-tgn.cisco.com), attempting to test network connections or devices between remote locations. 

WARNING: This is R&D project in early work in progress stage. It does only some of intented funcionality and may be full of bugs. Additionally, bear in mind that if we see that it's not possible to reach our goals with TRex we may change it to something else. 

## Problem defined

In the world of high-performance network testing we have some good commercial, products (with Ixia and Spirent being probably mostly known). However, these are very expensive hardware platforms, and not many can afford to have it. We also have some software products, with some of them being open-sourced like TRex or Warp17. None of them though offers functionality to test high performance (pps), latency, jitter and so on between two remote ends in different networks, or maybe even clouds. TRex tries to touch that problem offering Client-Server architecture in Stateful mode, but it's hard to use for high performance testing, like hundreds of thousands of packets per second. We're trying to find an alternative approach with stateless mode. 

## Description

This repo includes Ansible code to setup/download/install [TRex Traffic Generator](https://trex-tgn.cisco.com). It uses custom Docker image, built on top of CentOS. It should run on modern Ubuntu, CentOS, Fedora (however in the case of Fedora - you may need to enforce `ansible_python_interpreter=python3` and tune or disable SELinux). It will not work on Debian.

Bear in mind that running TRex in docker container requires root privileges due to fact that it needs to compile and insert DPDK module (thus kernel headers must exist in /usr/src of host). It also needs configure or replace existing network device drivers. Thus, it's runs privileged and with all Linux CAPs included. You're warned now.

Compiling modules in docker with one toolchain (CentOS in this case) against underlying kernel build with presumably another compiler is problematic. And because of that it seems like we need to rewrite Ansible code and forget about Docker. That will probably happen in future versions.

Multiple machines may be set up with installer, starting TRex in interactive mode with exposed API on port 4500/4501. Installer also supports running multiple TRex instances on libvirt hosts. 

## Requirements

* Modern Linux Ubuntu, Fedora or CentOS bare metal or virtual machine with Docker daemon, [Docker SDK](https://docker-py.readthedocs.io/en/stable/) and kernel headers properly installed,
* [Ansible](https://www.ansible.com/) 2.8 or newer on your laptop or any management host where you're going to run it.

## Usage

Ansible directory contains two playbooks:

* libvirt.yml - launches TRex virtual machines based on Ubuntu cloud image on libvirt. For now, it is controlled by `libvirt_trex_vm_count` variable which say how many instances are launched on each libvirt host (it defaults to 1). Libvirt with python-libvirt on target machines is required for this playbook to work. This playbook can also set up libvirt on machine, with optional `-e { enable_libvirt_setup: True }' parameter. 
* system.yml - Sets up system dependiences:
  * kernel headers, modules, python pip,
  * Docker daemon and python API library
* trex.yml - downloads and launches a Docker container with TRex in interactive mode.

*IMPORTANT:* Running system.yml playbook may *damage* your docker installation, if you already have one. Run it on fresh systems only. The same applies to setup-all.yml playbook, which imports above playbooks.

To run Ansible playbooks, you need to prepare inventory and add your host(s) to [trex] group.

Run it in a standard way:

    ansible-playbook -i inventory/example/ libvirt.yml -e @extra/vars.yml
    ansible-playbook -i inventory/example/ system.yml
    ansible-playbook -i inventory/example/ trex.yml

You can also specify parts of a playbook with tags (run with --list-tags to see available tags).

To force recreation of TRex containers add `-e trex_force_recreate=true` in command line.

## Configuration

You can customize `ansible/inventory/*/group_vars/all.yml` file in your inventory dir, or create host vars per host. See attached examples.

Supported parameters:

* `trex_docker_image` - trex docker image registry, defaults to codilimecom/trex:latest.
* `trex_dpdk_pci_interfaces` - this list of interfaces for machine to be set up by DPDK. It takes the form of PCI ids, like '00:06.0' or '00:07.0'.
* `trex_docker_published_ports` - list of published ports. Defaults to 4500, 4501 and 4507 on 127.0.0.1. Takes form of the list of IP:hostport:containerport, for example "[ '0.0.0.0:4500:4500', '0.0.0.0:4501:4501' ]".
