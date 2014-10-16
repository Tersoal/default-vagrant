parameters = File.expand_path("../parameters.yml", __FILE__)
load parameters

VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
    config.vm.box = $base_box

    config.vm.host_name = $vhost + "." + $domain
    config.hostsupdater.aliases = ["phpmyadmin." + $domain]

    config.vm.network "private_network", ip: $ip
    config.vm.network "forwarded_port", guest: 80, host: $port

    config.vm.synced_folder  "../", $vhostpath + "/" + $vhost + "." + $domain, type: "nfs"

    config.vm.provider "virtualbox" do |v|
    v.customize ["modifyvm", :id, "--cpuexecutioncap", "50"]
    v.memory = $memory
    v.cpus = $cpu
    end

    config.vm.provision :shell, :inline => 'echo -e "mysql_root_password=app
    controluser_password=123" > /etc/phpmyadmin.facts;'

    # This solution is better but does not work properly
    # config.vm.provision :shell, :inline => 'echo -e "mysql_root_password=' + $mysql_user +
    # ' controluser_password=' + $mysql_password + '" > /etc/phpmyadmin.facts;'

    config.vm.provision :puppet do |puppet|
        puppet.manifests_path = "puppet"
        puppet.manifest_file  = "app.pp"
        puppet.module_path    = "puppet/modules"
        puppet.facter         = {
            "vhost"                 => $vhost,
            "domain"                => $domain,
            "webserver"             => $webserver,
            "vhostpath"             => $vhostpath,
            "database_rootpassword" => $database_rootpassword,
            "database_user"         => $database_user,
            "database_password"     => $database_password,
            "database_name"         => $database_name,
            "database"              => $database,
            "symfony"               => $symfony
        }
    end
end
