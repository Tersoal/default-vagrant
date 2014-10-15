##Failed writing body (0 != 1205)
[https://github.com/mitchellh/vagrant/issues/2465](https://github.com/mitchellh/vagrant/issues/2465
)

Vagrant has problems with non ASCII characters in home path (on Windows)

Since my home directory is actually João Portela and not Joao Portela the problem became clear. As a first attempt, I assumed that setting `VAGRANT_HOME` explicitly `VAGRANT_HOME=C:/Users/João Portela/.vagrant.d` would fix the issue, but the exact same error message still appeared.

As a work around we can change `VAGRANT_HOME` to something else that doesn't have non-ascii characters - I changed to `VAGRANT_HOME=C:\.vagrant.d`


##The guest machine entered an invalid state while waiting for it to boot
DL is deprecated, please use Fiddle
The guest machine entered an invalid state while waiting for it
to boot. Valid states are 'starting, running'. The machine is in the
'poweroff' state. Please verify everything is configured
properly and try again.

If the provider you're using has a GUI that comes with it,
it is often helpful to open that and watch the machine, since the
GUI often has more helpful error messages than Vagrant can retrieve.
For example, if you're using VirtualBox, run `vagrant up` while the
VirtualBox GUI is open.

Often, this takes you to the legendary message error `VT-x is not available: verr_vmx_no_vmx`.

##VT-x is not available: verr_vmx_no_vmx
This trouble comes because your Intel or AMD processor does not support virtualization technology. Intel's website has a whole list of which processors support VT-x [here](http://ark.intel.com/Products/VirtualizationTechnology).

If you have this error and your processor has virtualization tecnhology, you have to enable into BIOS. However, if your computer does not support virtualization, there are some steps you can follow:

* [Thing about Vagrant, VirtualBox and lack of hardware virtualization](http://piotr.banaszkiewicz.org/blog/2012/06/10/vagrant-lack-of-hvirt/) by Piotr Banaszkiewicz.
* [VirtualBox Import Appliance; VT-x is not available](http://aminsblog.wordpress.com/2012/05/27/vt-x-is-not-available-ve/) by Amin Abbaspour.

This steps might not work, at least it did not in my case. Thus, my solution is to install a Vagrant box of 32 bits. For example if you have a precise64, you should install a precise32 box changing the following lines in your `Vagrantfile`.

    config.vm.box      = "precise32"
    config.vm.box_url  = "http://files.vagrantup.com/precise32.box"

##Failed to mount folders in Linux guest
Failed to mount folders in Linux guest. This is usually because the "vboxsf" file system is not available. Please verify that the guest additions are properly installed in the guest and can work properly. The command attempted was:

    mount -t vboxsf -o uid=`id -u vagrant`,gid=`getent group vagrant | cut -d: -f3` /vagrant /vagrant
    mount -t vboxsf -o uid=`id -u vagrant`,gid=`id -g vagrant` /vagrant /vagrant

To solve the above problem you have to create a symbolic link:

    sudo ln -s /opt/VBoxGuestAdditions-4.3.10/lib/VBoxGuestAdditions /usr/lib/VBoxGuestAdditions

And then, you have to type the `vagrant reload`.

Finally, at this [wiki](https://github.com/edx/configuration/wiki/Vagrant-troubleshooting) there are some others issues that you could consider.
