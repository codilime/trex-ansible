# TRex traffic generator installer

## Description

This repo includes Ansible code to setup/download/install [TRex Traffic Generator](https://trex-tgn.cisco.com). It uses custom Docker image, built on top of CentOS. It should run on modern Ubuntu, Debian, CentOS, Fedora (however it was tested on Ubuntu and CentOS for now). 

Bear in mind that running TRex in docker container requires root privileges due to fact that it needs to compile and insert DPDK module (thus kernel headers must exist in /usr/src of host). It also needs write access to PCI devices to replace existing network device drivers. Thus, it's runs privileged and with all Linux CAPs included. You're warned now. 

Multiple machines may be set up with installer, although we don't use them for now (yet). 

## Requirements

* Modern Linux Ubuntu or CentOS bare metal or virtual machine with Docker daemon, (Docker SDK)[https://docker-py.readthedocs.io/en/stable/] and kernel headers properly installed, 
* (Ansible)[https://www.ansible.com/] on your laptop or any management host where you're going to run it. 

## Usage

Ansible directory contains two playbooks: 

* system.yml - install required kernel headers and Docker (mandatory if you don't have them)
* trex.yml - downloads and launches docker container with TRex in interactive mode. 

You need to prepare inventory for these playbooks, and add your host(s) to [trex] group. 

Run it:

    ansible-playbook -i inventory/example/ system.yml
    ansible-playbook -i inventory/example/ trex.yml

## Configuration

You can customize `ansible/group_vars/all.yml` file in your inventory dir, or create host vars per host. 

Supported parameters:

* trex_docker_image - trex docker image registry, 
* trex_dpdk_pci_interfaces - this list of interfaces for machine to be set up by DPDK. It takes the form of PCI ids, like '00:06.0' or '00:07.0'. 

