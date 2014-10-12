class app::php {
    package {
        [
            "php5-cli",
            "php5-intl",
            "php5-curl",
            "php5-mcrypt",
#            "php5-memcached",
            "php-pear",
            "php5-xdebug",
        ]:
        ensure => present,
        notify => Service['nginx'],
    }

    if 'mysql' == $database {
        package {
            "php5-mysql":
                ensure => present,
                notify => Service['nginx'],
        }
    }

    if 'postgresql' == $database {
        package {
            "php5-pgsql":
                ensure => present,
                notify => Service['nginx'],
        }
    }

    include app::php::fpm

    include composer
}

import "php/*.pp"
