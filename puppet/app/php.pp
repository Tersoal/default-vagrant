class app::php {
    exec {'add-php-apt-repository':
        require => Package['python-software-properties'],
        command => 'add-apt-repository ppa:ufirst/php',
    }
    exec {'apt-update-php':
        require => Exec['add-apt-repository'],
        command => '/usr/bin/apt-get update',
    }

    package {
        [
            "php7.0-dev",
            "php7.0-fpm",
            "php7.0-cli",
            "php7.0-intl",
            "php7.0-curl",
            "php7.0-mcrypt",
            "php7.0-mysql",
            "php7.0-pgsql",
            "php7.0-gd",
#            "php7.0-memcached",
            "php-pear",
        ]:
        require => Exec['apt-update-php'],
        ensure  => present,
        notify  => Service['nginx'],
    }

    exec { 'install pkg-config':
        require => Package['php7.0-dev', 'php-pear'],
        command => 'apt-get install pkg-config'
    }

    exec { 'pecl install mongodb':
        require => [Package['php7.0-dev', 'php-pear'], Exec['install pkg-config']],
        command => 'pecl install mongodb',
        unless => 'pecl info mongodb'
    }

    file { '/etc/php/7.0/mods-available/mongodb.ini':
        content=> 'extension=mongodb.so',
        require => Exec['pecl install mongodb']
    }

    file { '/etc/php/7.0/cli/conf.d/20-mongodb.ini':
        ensure => 'link',
        target => '/etc/php/7.0/mods-available/mongodb.ini',
        require => File['/etc/php/7.0/mods-available/mongodb.ini'],
        notify => Service['nginx']
    }

    file { '/etc/php/7.0/fpm/conf.d/20-mongodb.ini':
        ensure => 'link',
        target => '/etc/php/7.0/mods-available/mongodb.ini',
        require => [Package["php7.0-fpm"], File['/etc/php/7.0/mods-available/mongodb.ini']],
        notify  => Service["php7.0-fpm", "nginx"],
    }

    exec { 'pecl install redis':
        require => Package['php7.0-dev', 'php-pear'],
        command => 'pecl install redis',
        unless => 'pecl info redis'
    }

    file { '/etc/php/7.0/mods-available/redis.ini':
        content=> 'extension=redis.so',
        require => Exec['pecl install redis']
    }

    file { '/etc/php/7.0/cli/conf.d/20-redis.ini':
        ensure => 'link',
        target => '/etc/php/7.0/mods-available/redis.ini',
        require => File['/etc/php/7.0/mods-available/redis.ini'],
        notify => Service['nginx']
    }

    file { '/etc/php/7.0/fpm/conf.d/20-redis.ini':
        ensure => 'link',
        target => '/etc/php/7.0/mods-available/redis.ini',
        require => [Package["php7.0-fpm"], File['/etc/php/7.0/mods-available/redis.ini']],
        notify  => Service["php7.0-fpm", "nginx"],
    }

    file {'/etc/php/7.0/fpm/conf.d/my-php.ini':
        ensure  => 'present',
        owner   => root,
        group   => root,
        source  => '/vagrant/files/etc/php7/fpm/conf.d/my-php.ini',
        require => [Package["php7.0-fpm"]],
        notify  => Service["php7.0-fpm", "nginx"],
    }

    service { "php7.0-fpm":
        ensure     => running,
        hasrestart => true,
        hasstatus  => true,
        require    => [Package["php7.0-fpm"]],
    }

    class { 'xdebug':
        default_enable   => '1',
        remote_enable    => '1',
        remote_handler   => 'dbgp',
        remote_host      => 'localhost',
        remote_port      => '9000',
        remote_autostart => '1',
        require => [Package["php7.0-cli"]],
        notify => Service['nginx'],
    }

    include composer
}
