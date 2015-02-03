class app::database::redis {
    exec {'add-redis-apt-repository':
        require => Package['python-software-properties'],
        command => 'add-apt-repository ppa:rwky/redis',
    }
    exec {'apt-update-redis':
        require => Exec['add-redis-apt-repository'],
        command => '/usr/bin/apt-get update',
    }
    package {["redis-server"]:
        require => Exec['apt-update-redis'],
        ensure => present,
    }
}
