class app::php::fpm {
    package { "php5-fpm":
        ensure => present,
        notify => Service[$webserver],
    }

    file {"/etc/php5/fpm/pool.d":
        ensure => directory,
        owner => root,
        group => root,
        require => [Package["php5-fpm"]],
    }

    file {"/etc/php5/fpm/pool.d/$vhost$domain.conf":
        ensure => present,
        owner => root,
        group => root,
        content => template("/vagrant/files/etc/php5/fpm/pool.d/template.erb"),
        require => [File["/etc/php5/fpm/pool.d"]],
        notify => Service["php5-fpm", "nginx"],
    }

    file {'/etc/php5/fpm/conf.d/my-php.ini':
        ensure  => 'present',
        owner   => root,
        group   => root,
        source  => '/vagrant/files/etc/php5/fpm/conf.d/my-php.ini',
        require => [File["/etc/php5/fpm/conf.d"]],
        notify  => Service["php5-fpm", "nginx"],
    }

    service {"php5-fpm":
        ensure => running,
        hasrestart => true,
        hasstatus => true,
        require => [Package[php5-fpm]],
    }
}
