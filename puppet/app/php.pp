class app::php {
    exec {'apt-update-php':
      require => Exec['add-apt-repository'],
      command => '/usr/bin/apt-get update',
    }

    package {
        [
            "php5-dev",
            "php5-cli",
            "php5-intl",
            "php5-curl",
            "php5-mcrypt",
            "php5-mysql",
            "php5-pgsql",
#            "php5-memcached",
            "php-pear",
        ]:
        require => Exec['apt-update-php'],
        ensure  => present,
        notify  => Service['nginx'],
    }

    exec { 'pecl install mongo':
        require => Package['php5-dev', 'php-pear'],
        command => 'pecl install mongo',
        unless => 'pecl info mongo'
    }

    file { '/etc/php5/mods-available/mongo.ini':
        content=> 'extension=mongo.so',
        require => Exec['pecl install mongo']
    }

    file { '/etc/php5/cli/conf.d/20-mongo.ini':
        ensure => 'link',
        target => '/etc/php5/mods-available/mongo.ini',
        require => File['/etc/php5/mods-available/mongo.ini'],
        notify => Service['nginx']
    }

    class { 'xdebug':
        default_enable   => '1',
        remote_enable    => '1',
        remote_handler   => 'dbgp',
        remote_host      => 'localhost',
        remote_port      => '9000',
        remote_autostart => '1',
        require => [Package["php5-cli"]],
        notify => Service['nginx'],
    }

    include app::php::fpm

    include composer
}

import "php/*.pp"
