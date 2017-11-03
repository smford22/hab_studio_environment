# hab_studio_environment
This simple cookbook is designed to get a VM to do some habitat development on. It is ideal for people on older versions of Windows (7,8, etc) That does not have a hardware to run Docker CE, which the habitat studio requires.

## Prereqs
- [ChefDK](http://downloads.chef.io/)
- [VirtualBox](https://www.virtualbox.org/wiki/Downloads)
- [Vagrant](https://www.vagrantup.com/)

## Shared Content
This repo also has a `shared` directory that gets mounted in the guest VM at `/home/vagrant/src`. This allows you to code locally on your own editor of choice, save the files locally, but then have them available on the guest.

## Bring up a habitat vm
1. clone this project to your local workstation
2. `cd hab_studio_environment`
3. `kitchen converge`
4. `kitchen login`
5. `[vagrant@default-centos-73 ~]$hab setup` <-- This will setup your origin and key
6. `[vagrant@default-centos-73 ~]$hab studio enter`

