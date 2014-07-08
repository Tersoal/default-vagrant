class app::mysql {
    mysql::db { "$mysql_database":
      user     => "$mysql_username",
      password => "$mysql_password",
    }

    class { 'phpmyadmin':
        require => Class['mysql'],
    }
}
class app::database {
include app::mysql

    exec {"manage-database":
        require => [Package["php5-cli"], Class["app::mysql"]],
        command => "/bin/bash -c 'cd $vhostpath/$vhost.$domain && sh scripts/update_doctrine_dev.sh'",
        onlyif  => "/usr/bin/test -f '$vhostpath/$vhost.$domain/scripts/update_doctrine_dev.sh'",
    }
}