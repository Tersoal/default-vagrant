class app::database {
    if $mysql_is_defined == 'true' {
        include app::database::mysql
    }

    if $postgresql_is_defined == 'true' {
        include app::database::postgresql
    }

    if $mongodb_is_defined == 'true' {
        class {'::mongodb::globals':
          manage_package_repo => true,
        }->
        class {'::mongodb::server':
            verbose => true,
        }->
        class {'::mongodb::client':
        }->
        exec {'apt-update-mongo':
            command => '/usr/bin/apt-get update',
        }
        exec { 'apt-get install mongodb-org-tools':
            require => Exec['apt-update-mongo'],
        }

        mongodb_database { $mongodb_db_name:
            ensure   => present,
            tries    => 10,
            require  => Class['mongodb::server'],
        }
    }

    if $redis_is_defined == 'true' {
        include app::database::redis
    }
}

import "database/*.pp"
