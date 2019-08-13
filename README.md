# TRex traffic generator Ansible installer

TRex Ansible is an experimental deployer of [TRex Traffic Generator](https://trex-tgn.cisco.com), attempting to test network connections or devices between remote locations. 

WARNING: This is R&D project in early work in progress stage. It does only some of intented funcionality and may be full of bugs. Additionally, bear in mind that if we see that it's not possible to reach our goals with TRex we may change it to something else. 

## Problem defined

In the world of high-performance network testing we have some good commercial, products (with Ixia and Spirent being probably mostly known). However, these are very expensive hardware platforms, and not many can afford to have it. We also have some software products, with some of them being open-sourced like TRex or Warp17. None of them though offers functionality to test high performance (pps), latency, jitter and so on between two remote ends in different networks, or maybe even clouds. TRex tries to touch that problem offering Client-Server architecture in Stateful mode, but it's hard to use for high performance testing, like hundreds of thousands of packets per second. We're trying to find an alternative approach with stateless mode. 

## Description

This repo includes Ansible code to setup/download/install [TRex Traffic Generator](https://trex-tgn.cisco.com). It should work on modern Ubuntu, CentOS, Fedora (however in case of Fedora - you may need to enforce `ansible_python_interpreter=python3` and tune or disable SELinux), but currently we're going to treat seriously only Ubuntu (due to early stage and lack of time).

Multiple machines may be set up with installer, starting TRex in interactive mode with exposed API on port 4500/4501. Installer also supports running multiple TRex instances on libvirt hosts. 

## Requirements

* Modern Linux Ubuntu (prefferable), Fedora or CentOS bare metal or virtual machine,
* [Ansible](https://www.ansible.com/) 2.8 or newer on your laptop or any management host where you're  going to run it.

## Usage


Ansible directory one single playbook with following plays:

* Setup libvirt machines and install libvirt - this is optional and setting up libvirt host requires `-e '{ enable_libvirt_setup: True }'` - otherwise we assume that libvirt on host is configured and do    not touch that. 
* Launch TRex libvirt virtual machines - launches TRex virtual machines based on Ubuntu cloud image on libvirt. For now it is controlled by `libvirt_trex_vm_count` variable which say how many instances are launched on each libvirt host (it defaults to 1). Libvirt with python-libvirt on target machines is    required for this playbook to work.
* Setup T-Rex Traffic Generator - installs and runs TRex in interactive mode on all hosts in trex      group, including discovered VMs. 

To run Ansible playbooks, you need to prepare inventory and add your host(s) to [trex] group.

Run it in a standard way:

    ansible-playbook -i inventory/example/ setup.yml -e  '{ cleanup_vms: False, enable_libvirt_setup:  True }'

You can also specify parts of playbook with tags (run with --list-tags to see available tags).

To force recreation of TRex containers add `-e trex_force_recreate=true` in command line.


## Configuration

You can customize `ansible/inventory/*/group_vars/all.yml` file in your inventory dir, or create host vars per host. See attached examples.

Supported parameters:

* `trex_dpdk_pci_interfaces` - this list of interfaces for machine to be set up by DPDK. It takes the form of PCI ids, like '00:06.0' or '00:07.0'.
