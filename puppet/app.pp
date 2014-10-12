Exec { path => [
    '/usr/local/bin',
    '/opt/local/bin',
    '/usr/bin',
    '/usr/sbin',
    '/bin',
    '/sbin'
], logoutput => true }
Package { require => Exec['apt_update'], }

class { 'apt':
    always_apt_update => true
}

import "app/*.pp"

host { 'localhost':
    ip           => '127.0.0.1',
    host_aliases => ["$vhost.$domain", "phpmyadmin.$domain"],
    notify       => Service['nginx'],
}

class { "mysql": }
class { "mysql::server":
    config_hash => {
        "root_password"     => "$mysql_rootpassword",
        "etc_root_password" => true,
    }
}
Mysql::Db {
    require => Class['mysql::server', 'mysql::config'],
}

include app::php
include app::server
include app::tools
include app::database
include app::ssl

if $is_symfony_env == true {
    import "app/env/symfony.pp"
    include app::symfony
}

file { '/home/vagrant/.bash_aliases':
    ensure => present,
    owner => root,
    group => root,
    content => template("/vagrant/files/conf/dotfiles/bash_template.erb"),
}
