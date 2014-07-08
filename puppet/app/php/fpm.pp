class app::php::fpm {
    package { "php5-fpm":
        ensure => present,
        notify => Service[$webserver],
    }

    file {'/etc/php5/fpm/conf.d/my-php.ini':
        ensure  => 'present',
        owner   => root,
        group   => root,
        source  => '/vagrant/files/etc/php5/fpm/conf.d/my-php.ini',
        require => [Package["php5-fpm"]],
        notify  => Service["php5-fpm", "nginx"],
    }

    service {"php5-fpm":
        ensure => running,
        hasrestart => true,
        hasstatus => true,
        require => [Package[php5-fpm]],
    }
}
