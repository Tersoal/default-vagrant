class app::database::mysql {
    $override_options = {
        'mysqld' => {
            'bind_address' => "$ip"
        }
    }
    class { "mysql::server":
        root_password    => $mysql_rootpassword,
        override_options => $override_options,
    }

    mysql_user { 'root@%':
        ensure                   => 'present',
        max_connections_per_hour => '0',
        max_queries_per_hour     => '0',
        max_updates_per_hour     => '0',
        max_user_connections     => '0',
    }

    mysql_grant { 'root@%/*.*':
        ensure     => 'present',
        options    => ['GRANT'],
        privileges => ['ALL'],
        table      => '*.*',
        user       => 'root@%',
    }

    mysql::db { "$mysql_db_name":
        user     => "$mysql_username",
        password => "$mysql_password",
    }

    class { 'phpmyadmin':
        require => Class['mysql'],
    }
}
