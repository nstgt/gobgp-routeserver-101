# GoBGP Route Server 101

This repository provides Vagrantfile to build the tutorial environment which is described in the following slide:

[GoBGP 101: How to start](https://speakerdeck.com/nstgt/gobgp-101-how-to-start)

This was presented at 34th Euro-IX Forum (Toulouse, France / Apr 2019)


## About tutorial

- This tutorial focuses on using GoBGP as an IXP Route Server
- It covers following topics:
    - Installation of GoBGP
    - gobgpd administration via systemd
    - Logging
    - Writing configuration file
    - Adding eBGP peers
    - Applying policy
        - Import policy
        - Export policy
    - RPKI setup

## Prerequisites

- VirtualBox 5.2.26 r128414
- Vagrant 2.2.4

Tested on my MacBook Pro running  macOS Mojave 10.14.3, but should work on both Windows/Linux too. If you find any problem, please report it through opening an issue.


## Getting started

1. clone the repository
    - `git clone https://github.com/nstgt/gobgp-routeserver-101`
2. `cd gobgp-routeserver-101`
3. `vagrant up`
    - Take a while...
4. Configure three vSRX routers (r1,r2,r3)
    - run `util/save_inittial_configs.sh`
    - run `util/set_junos_ntpdate.sh`
    - run `util/upload_junos_configs.sh`

## What should do next?

You will configure GoBGP installed on **rs** so login to rs by `vagrant ssh rs` and be root `sudo su -` then create first configuration at `/etc/gobgp/gobgpd.yaml` as described in slides, then boot it `systemctl start gobgpd`

After that you can modify it following the step by step instruction in the slide, or try out whatever you want to.

You can find the final configuration for **rs** as `configs/rs/gobgpd.yaml.complete`