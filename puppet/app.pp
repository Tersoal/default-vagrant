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

file { ["/dev/shm/symfony"]:
    ensure => "directory"
}

file { ["/dev/shm/symfony/cache"]:
    ensure => "directory"
}

file { ["/dev/shm/symfony/logs"]:
    ensure => "directory"
}

import "app/*.pp"

$webserverService = $webserver ? {
    apache2 => 'httpd',
    nginx   => 'nginx',
    default => 'nginx'
}

host { 'localhost':
    ip => '127.0.0.1',
    host_aliases => [
      "localhost.localdomain",
      "localhost4",
      "localhost4.localdomain4",
      "$vhost.$domain"
    ],
    notify => Service[$webserverService],
}

class { "mysql": }
class { "mysql::server":
    config_hash => {
        "root_password" => "$mysql_rootpassword",
        "etc_root_password" => true,
    }
}
Mysql::Db {
    require => Class['mysql::server', 'mysql::config'],
}

include app::php
include app::webserver
include app::tools
include app::database
include app::ssl

file { '/home/vagrant/.bash_aliases':
    ensure => present,
    owner => root,
    group => root,
    content => template("/vagrant/files/conf/dotfiles/bash_template.erb"),
}
