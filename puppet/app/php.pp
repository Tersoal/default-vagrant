class app::php {

  case $::osfamily {
    Redhat: {
        $php_package = ["php", "php-dev", "php-mysql", "php-intl", "php-curl", "php-xdebug"]
    }
    Debian: {
        $php_package = ["php5", "php5-cli", "php5-dev", "php5-mysql", "php5-intl", "php5-curl", "php5-xdebug"]
    }
  }

    package { $php_package:
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
}
import "php/*.pp"


