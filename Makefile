.PHONY: info install-chef-librarian download-chef-cookbooks install-vagrant-dependencies make-drupal

PWD = $(shell pwd)

default: info

info:
	@echo "make info (this)"
	@echo "make install-chef-librarian"
	@echo "make download-chef-cookbooks"
	@echo "make install-vagrant-dependencies"
	@echo "make make-drupal"

install-chef-librarian:
	gem install librarian-chef

download-chef-cookbooks:
	cd $(PWD)/build/vagrant/chef-repo ; librarian-chef install --clean --verbose

install-vagrant-dependencies:
	vagrant plugin install vagrant-triggers
	vagrant plugin install vagrant-hostsupdater
	vagrant plugin install vagrant-cachier
	vagrant plugin install vagrant-vbguest
	vagrant plugin install vagrant-omnibus
	vagrant plugin install vagrant-persistent-storage
	vagrant plugin install vagrant-hostmanager

make-drupal:
	cd $(PWD)/build/phing ; $(shell pwd) ; phing