class app::tools {
    package {[
              "python-software-properties",
              "mlocate",
              "zip",
              "unzip",
              "strace",
              "tcpdump",
              "patch",
              "mc",
              "vim",
              "htop",
              "git",
              "build-essential"]:
        ensure => present,
    }

    exec {'find-utils-updatedb':
        command => '/usr/bin/updatedb &',
        require => Package['mlocate'],
    }

      exec {'add-apt-repository':
          before  => Class['app::php'],
          command => 'sudo add-apt-repository ppa:ondrej/php5',
          require => Package['python-software-properties']
    }
}
