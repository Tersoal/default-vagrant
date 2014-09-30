class app::php {
    package {
        [
            "php5-cli",
            "php5-mysql",
            "php5-intl",
            "php5-curl",
            "php5-mcrypt",
#            "php5-memcached",
            "php-pear",
        ]:
        ensure => present,
        notify => Service['nginx'],
    }

    class { 'xdebug':
        default_enable   => '1',
        remote_enable    => '1',
        remote_handler   => 'dbgp',
        remote_host      => 'localhost',
        remote_port      => '9000',
        remote_autostart => '1',
        require          => [Package["php5-cli"]],
        notify           => Service['nginx'],
    }

    include app::php::fpm

    include composer
}

import "php/*.pp"
