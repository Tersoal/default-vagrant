require 'yaml'
parameters = YAML.load_file 'parameters.yml'

VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
    if Vagrant.has_plugin?("vagrant-vbguest")
      config.vbguest.auto_update = false
    end

    config.vm.box = parameters['virtual_machine']['box']
    config.vm.provider :virtualbox do |vb|
        vb.name = parameters['virtual_machine']['vhost'] + "." + parameters['virtual_machine']['domain']
    end

    config.vm.host_name = parameters['virtual_machine']['vhost'] + "." + parameters['virtual_machine']['domain']
    config.hostsupdater.aliases = ["phpmyadmin." + parameters['virtual_machine']['domain']]

    config.vm.network "private_network", ip: parameters['virtual_machine']['ip']
    config.vm.network "forwarded_port", guest: 80, host: parameters['virtual_machine']['port']

    config.vm.synced_folder  "../", parameters['virtual_machine']['vhostpath'] + "/" + parameters['virtual_machine']['vhost'] + "." + parameters['virtual_machine']['domain'], type: "nfs"

    config.vm.provider "virtualbox" do |v|
    v.customize ["modifyvm", :id, "--cpuexecutioncap", "50"]
    v.memory = parameters['virtual_machine']['memory']
    v.cpus = parameters['virtual_machine']['cpu']
    end

    if defined?(parameters['database']['mysql']) && (parameters['database']['mysql'] != '') && (parameters['database']['mysql'] != nil) then
        mysql_is_defined   = 'true'
        mysql_rootpassword = parameters['database']['mysql']['rootpassword']
        mysql_user         = parameters['database']['mysql']['user']
        mysql_password     = parameters['database']['mysql']['password']
        mysql_db_name      = parameters['database']['mysql']['name']

        config.vm.provision :shell, :inline => 'echo -e "mysql_root_password=app
        controluser_password=123" > /etc/phpmyadmin.facts;'
    else
        mysql_is_defined   = 'false'
        mysql_rootpassword = ''
        mysql_user         = ''
        mysql_password     = ''
        mysql_db_name      = ''
    end

    if defined?(parameters['database']['postgresql']) && (parameters['database']['postgresql'] != '') && (parameters['database']['postgresql'] != nil) then
        postgresql_is_defined   = 'true'
        postgresql_rootpassword = parameters['database']['postgresql']['rootpassword']
        postgresql_user         = parameters['database']['postgresql']['user']
        postgresql_password     = parameters['database']['postgresql']['password']
        postgresql_db_name      = parameters['database']['postgresql']['name']
    else
        postgresql_is_defined   = 'false'
        postgresql_rootpassword = ''
        postgresql_user         = ''
        postgresql_password     = ''
        postgresql_db_name      = ''
    end

    if defined?(parameters['database']['mongodb']) && (parameters['database']['mongodb'] != '') && (parameters['database']['mongodb'] != nil) then
        mongodb_is_defined = 'true'
        mongodb_db_name    = parameters['database']['mongodb']['name']
    else
        mongodb_is_defined = 'false'
        mongodb_db_name    = ''
    end

    if defined?(parameters['database']['redis']) && (parameters['database']['redis'] != '') && (parameters['database']['redis'] != nil) then
        redis_is_defined = 'true'
    else
        redis_is_defined = 'false'
    end

    if defined?(parameters['environments']['nodejs']) && (parameters['environments']['nodejs'] != '') && (parameters['environments']['nodejs'] != nil)
    then
        nodejs_version = parameters['environments']['nodejs']
    else
        nodejs_version = 'false'
    end

    if defined?(parameters['environments']['golang']) && (parameters['environments']['golang'] != '') && (parameters['environments']['golang'] != nil)
    then
        golang_version = parameters['environments']['golang']
    else
        golang_version = 'false'
    end

    if defined?(parameters['environments']['ruby']['sass']) && (parameters['environments']['ruby']['sass'] != '') && (parameters['environments']['ruby']['sass'] != nil) && (parameters['environments']['ruby']['sass'] != 'latest')
    then
        sass_version = parameters['environments']['ruby']['sass']
    else
        sass_version = 'installed'
    end

    if defined?(parameters['environments']['ruby']['compass']) && (parameters['environments']['ruby']['compass'] != '') && (parameters['environments']['ruby']['compass'] != nil) && (parameters['environments']['ruby']['compass'] != 'latest')
    then
        compass_version = parameters['environments']['ruby']['compass']
    else
        compass_version = 'installed'
    end

    if defined?(parameters['environments']['symfony']) && (parameters['environments']['symfony'] != '') && (parameters['environments']['symfony'] != nil)
    then
        symfony = parameters['environments']['symfony']
    else
        symfony = 'false'
    end

    config.vm.provision :puppet do |puppet|
        puppet.manifests_path = "puppet"
        puppet.manifest_file  = "app.pp"
        puppet.module_path    = "puppet/modules"
        puppet.facter         = {
            "vhost"     => parameters['virtual_machine']['vhost'],
            "domain"    => parameters['virtual_machine']['domain'],
            "vhostpath" => parameters['virtual_machine']['vhostpath'],
            "ip"        => parameters['virtual_machine']['ip'],
            "port"      => parameters['virtual_machine']['port'],
            "use_nfs"   => parameters['virtual_machine']['use_nfs'],
            "box"       => parameters['virtual_machine']['box'],
            "cpu"       => parameters['virtual_machine']['cpu'],
            "memory"    => parameters['virtual_machine']['memory'],

            "mysql_is_defined"   => mysql_is_defined,
            "mysql_rootpassword" => mysql_rootpassword,
            "mysql_user"         => mysql_user,
            "mysql_password"     => mysql_password,
            "mysql_db_name"      => mysql_db_name,

            "postgresql_is_defined"   => postgresql_is_defined,
            "postgresql_rootpassword" => postgresql_rootpassword,
            "postgresql_user"         => postgresql_user,
            "postgresql_password"     => postgresql_password,
            "postgresql_db_name"      => postgresql_db_name,

            "mongodb_is_defined"   => mongodb_is_defined,
            "mongodb_db_name"      => mongodb_db_name,

            "redis_is_defined"   => redis_is_defined,

            "nodejs_version" => nodejs_version,
            "golang_version" => golang_version,

            "sass_version"    => sass_version,
            "compass_version" => compass_version,

            "symfony" => symfony
        }
    end
end
