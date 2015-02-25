class app::env::ruby {
    exec {'apt-get-update':
        command => '/usr/bin/apt-get update',
    }

    exec { 'install ruby':
        command => '/usr/bin/apt-get install ruby1.9.3 -y',
        require => Exec['apt-get-update'],
    }

    package { 'sass':
        ensure   => $sass_version,
        provider => 'gem',
        require => Exec['install ruby']
    }

    package { 'scss-lint':
        provider => 'gem',
        require => Exec['install ruby']
    }

    package { 'compass':
        ensure => $compass_version,
        provider => 'gem',
        require => Exec['install ruby']
    }
}
