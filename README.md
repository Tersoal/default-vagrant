# My Vagrant/Puppet Default Setup 

## Setup

-   Install vagrant on your system
    see [vagrantup.com](http://docs.vagrantup.com/v2/getting-started/index.html)

-   Install vagrant-hostupdater on your system
    see [cogitatio/vagrant-hostsupdater](https://github.com/cogitatio/vagrant-hostsupdater)

-   Get a base box with puppet support
    see [vagrantup.com docs](http://docs.vagrantup.com/v2/getting-started/boxes.html)

-   Get a copy of this repository. You can do this either by integrating it as a git submodule or by just checking it out and copying the files. 
    Prefarably, the contents of this repository should be placed in a directory `vagrant` inside your project's root dir.

-   Copy `vagrant/Personalization.dist` to `vagrant/Personalization` and modify `vagrant/Personalization` according to your needs.

    Example:
    ```ruby
    # Name of the vhost to create
    $vhost = "myapp"
    $domain = "localhost"

    # Path of the vhost
    $vhostpath = "/var/www"

    # Mysql
    $mysql_rootpassword = "app"
    $mysql_user = "root"
    $mysql_password = "123"
    $mysql_database = "symfony"


    # VM IP
    $ip = "192.168.10.42"

    # Use NFS?
    $use_nfs = true

    # Base box name - Get one that supports puppet
    $base_box = "http://files.vagrantup.com/precise64.box"

    # Which webserver do you want to use?
    # Valid choices are "nginx" and "apache2"
    #
    # Note: nginx implies the use of php-fpm
    $webserver = "nginx"
    ```
        
    -   Execute "vagrant up" in the directory vagrant.
    
## NEWS 
- Add jfryman/nginx module
- Dropped old nginx module
- PHPFPM slow querylog
- New tools package from tcpdump
- PHPMyAdmin available

## Archive
- Nginx SSL support
- Vagrant v2 support
- Automatic ssl certificate generation
- Custom domain support
- Apache SSL support
- Apache & Stdlib module upgrade
- New concat module
- MySQL custom user, password, database support
- MySQL custom root password
- Xdebug support only phpfpm
- Small bugfix



## Infrastructure

After performing the steps listed above, you will have the following environment set up:

- A running virtual machine with your project on it
- Your project directory will be mounted as a shared folder in this virtual machine
- Your project will be accessible via a browser (go to `http://{$vhost}.{$domain}/[app_dev.php]` or `https://{$vhost}.{$domain}/[app_dev.php]` )
- You can now start customizing the new virtual machine. In most cases, the machine should correspond to the infrastructure your production server(s) provide.
