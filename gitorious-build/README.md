# Gitorious build scripts

This repository contains all necessary pieces needed to build the fully
functional and deployable gitorious system.

It consists of the following parts:

* `docker` directory - contains Docker image definition files (Dockerfiles) for
  all Gitorious services,
* `packer` directory - contains Packer image definition files for building
  Gitorious "appliance" images for VirtualBox, VMWare, EC2 and others.
