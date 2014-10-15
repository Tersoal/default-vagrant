class app::env::symfony {
    file { ["/dev/shm/symfony"]:
        ensure => "directory"
    }

    file { ["/dev/shm/symfony/cache"]:
        ensure => "directory"
    }

    file { ["/dev/shm/symfony/logs"]:
        ensure => "directory"
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

    exec {"manage-database":
        require => [Package["php5-cli"], Class["app::database::mysql"]],
        command => "/bin/bash -c 'cd $vhostpath/$vhost.$domain && sh scripts/update_doctrine_dev.sh'",
        onlyif  => "/usr/bin/test -f '$vhostpath/$vhost.$domain/scripts/update_doctrine_dev.sh'",
    }
}
