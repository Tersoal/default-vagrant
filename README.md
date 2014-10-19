<h1>
    <a href="url"><img src="http://upload.wikimedia.org/wikipedia/commons/8/87/Vagrant.png" align="left" height="48" ></a>
    &nbsp;&nbsp;
    Puppet Vagrant VM
</h1>
> This VM is focused on PHP development but also has different environments that provides some other useful tools.

This box contains the following:
* PHP-FPM 5.6 with the following extensions:
    - php5-cli
    - php5-intl
    - php5-curl
    - php5-mcrypt
    - php-pear
    - php5-xdebug
* Nginx with SSL support
* MySQL
* phpMyAdmin
* PostgreSQL
* Composer

ENVIRONMENTS
------------
* Symfony (launches some useful commands about **cache and logs permissions** or about **Doctrine** when the machine is booting)
* Ruby (For now, this is installed by default, because it only contains **Sass** and **Compass**)

Prerequisites
-------------

* Install [Vagrant](http://docs.vagrantup.com/v2/installation/index.html) on your system, which in turn requires [RubyGems](https://rubygems.org/pages/download) and [VirtualBox](https://www.virtualbox.org/wiki/Downloads).

*NOTE: If you are on Windows, I would recommend [RubyInstaller](http://rubyinstaller.org/) for installing Ruby and any ssh client as [PuTTY](http://www.chiark.greenend.org.uk/~sgtatham/putty/download.html) for log into your Vagrant box.*

* For simplified the usage of this box, you should install **[vagrant-hostsupdater](https://github.com/cogitatio/vagrant-hostsupdater)** plugin for Vagrant, which adds an entry to your `/etc/hosts` file on the host system and **[vagrant-vbguest](https://github.com/dotless-de/vagrant-vbguest)** plugin which automatically installs the host's VirtualBox Guest Additions on the guest system.
```
vagrant plugin install vagrant-hostsupdater
vagrant plugin install vagrant-vbguest
```
    

Getting started
---------------

The recommended way to clone this VM is using the following command because you have to clone the *git submodules*
too:

    git clone --recursive https://github.com/benatespina/default-vagrant.git vagrant

Then, you have to duplicate the `parameters.yml.dist` in the same directory but without `.dist`
extension, modifying the values with your favorite preferences. The following configuration is by default:

```
virtual_machine:
    vhost:      app
    domain:     localhost
    vhostpath:  /var/www
    ip:         192.168.10.42
    port:       8080
    use_nfs:    true
    box:        precise64
    cpu:        1
    memory:     512

database:
    mysql:
        rootpassword: app
        user:         root
        password:     123
        name:         mysql-database

    postgresql:
        rootpassword: app
        user:         root
        password:     123
        name:         postgresql-database

environments:
    symfony: false
```

Then, you have to build the *Vagrant* machine and then, you have to connect via **ssh** to the VM with the following commands:

    vagrant up
    vagran ssh

That's all! Now you can type your hostname in your favorite browser as this:

    app.localhost

Besides, if you have activated the *MySQL* database you can access to *phpMyAdmin* typing the following url in the browser:

    phpmyadmin.localhost

*NOTE: I am pretty sure that it works fine, but in case that not, I have recollected on [TROUBLESHOOTING.md](https://github.com/benatespina/default-vagrant/blob/master/TROUBLESHOOTING.md) most of typical errors about Vagrant.*

    
Credits
-------
This is a fork of [pigri](https://github.com/pigri)'s
[default-vagrant](https://github.com/pigri/default-vagrant) project.

Created by **benatespina** - [benatespina@gmail.com](mailto:benatespina@gmail.com).
Copyright (c) 2014

[![License](http://img.shields.io/:license-mit-green.svg)](http://doge.mit-license.org)
