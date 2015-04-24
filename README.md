worldcubeassociation.org
========================

This repository contains all of the code that runs on [worldcubeassociation.org](https://www.worldcubeassociation.org/).

## Setup
- Install [Vagrant](https://www.vagrantup.com/), which requires
  [VirtualBox](https://www.virtualbox.org/).
- `git clone https://github.com/cubing/worldcubeassociation.org` - Clone this repo! (And navigate into it, `cd worldcubeassociation.org`)
- `git submodule update --init --recursive` - Initialize submodules. (Note: you will need to have access to the [cubing/wca-website-php](https://github.com/cubing/wca-website-php) repo, and an [SSH key](https://help.github.com/articles/generating-ssh-keys/) set up for this.)
- `wget --user=<USERNAME> --password=<PASSWORD> https://www.worldcubeassociation.org/results/admin/dump/worldcubeassociation.org_alldbs.tar.gz` - Download a (possibly outdated) full database export. (You'll need access to the admin section of the WCA website for this to work.)

## Run
- `vagrant up` - Once the VM finishes intializing (which can take some time), the website will be
  accessible at [http://localhost:8080](http://localhost:8080).