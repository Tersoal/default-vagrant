class app::php {
    package {
        [
            "php5-cli",
            # "php5-apcu",
            "php5-mysql",
            "php5-intl",
            "php5-curl",
            "php5-mcrypt",
            "php5-xdebug",
            "php5-memcached"
        ]:
        ensure => present,
        notify => Service[$webserverService],
    }

    exec {'change-permissions':
        require => File['/dev/shm/symfony', '/dev/shm/symfony/cache', '/dev/shm/symfony/logs'],
        command => 'sudo chmod -R 777 /dev/shm/symfony',
    }

    exec {"clear-symfony-cache":
        require => [Package["php5-cli"], Exec['change-permissions']],
        command =>"/bin/bash -c 'cd $vhostpath/$vhost.$domain && /usr/bin/php app/console cache:clear --env=dev && /usr/bin/php app/console cache:clear --env=test'",
    }

    exec {'change-permissions-after-clean-cache':
        require => Exec['clear-symfony-cache'],
        command => 'sudo chmod -R 777 /dev/shm/symfony',
    }

    if 'nginx' == $webserver {
        include app::php::fpm
    }

    include composer
}
import "php/*.pp"
