class app::env::ruby {
    package { 'sass':
        ensure   => $sass_version,
        provider => 'gem',
    }

    package { 'compass':
        ensure => $compass_version,
        provider => 'gem',
    }
}
