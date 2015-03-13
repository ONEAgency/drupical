.PHONY: info install-chef-librarian download-chef-cookbooks install-vagrant-dependencies make-drupal vagrant-provision vagrant-up
PWD = $(shell pwd)
VAGRANTPLUG = $(shell vagrant plugin list)

default: info

info:
	@echo "make info (this)"
	@echo "make install-chef-librarian"
	@echo "make download-chef-cookbooks"
	@echo "make install-vagrant-dependencies"
	@echo "make make-drupal"
	@echo "make vagrant-provision"
	@echo "make vagrant-up"

install-chef-librarian:
	gem install librarian-chef

download-chef-cookbooks:
	cd $(PWD)/build/vagrant/chef-repo ; librarian-chef install --clean --verbose

install-vagrant-dependencies: check-triggers check-hostsupdater check-cachier check-vbguest check-omnibus check-persistent-storage check-hostmanager check-reload

make-drupal:
	cd $(PWD)/build/phing ; $(shell pwd) ; phing

vagrant-provision:
	vagrant reload --provision

vagrant-up:
	ssh-add ~/.ssh/id_rsa ; vagrant up

check-triggers:
ifneq (,$(findstring triggers, $(VAGRANTPLUG)))
	@echo "Vagrant triggers is already installed"
else
	vagrant plugin install vagrant-triggers
endif

check-hostsupdater:
ifneq (,$(findstring hostsupdater, $(VAGRANTPLUG)))
	@echo "Vagrant hostsupdater is already installed"
else
	vagrant plugin install vagrant-hostsupdater
endif

check-cachier:
ifneq (,$(findstring cachier, $(VAGRANTPLUG)))
	@echo "Vagrant cachier is already installed"
else
	vagrant plugin install vagrant-cachier
endif

check-vbguest:
ifneq (,$(findstring vbguest, $(VAGRANTPLUG)))
	@echo "Vagrant vbguest is already installed"
else
	vagrant plugin install vagrant-vbguest
endif

check-omnibus:
ifneq (,$(findstring omnibus, $(VAGRANTPLUG)))
	@echo "Vagrant omnibus is already installed"
else
	vagrant plugin install vagrant-omnibus
endif

check-persistent-storage:
ifneq (,$(findstring persistent, $(VAGRANTPLUG)))
	@echo "Vagrant persistent-storage is already installed"
else
	vagrant plugin install vagrant-persistent-storage
endif

check-hostmanager:
ifneq (,$(findstring hostmanager, $(VAGRANTPLUG)))
	@echo "Vagrant hostmanager is already installed"
else
	vagrant plugin install vagrant-hostmanager
endif

check-reload:
ifneq (,$(findstring reload, $(VAGRANTPLUG)))
	@echo "Vagrant reload is already installed"
else
	vagrant plugin install vagrant-reload
endif