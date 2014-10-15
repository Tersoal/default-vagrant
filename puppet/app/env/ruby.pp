class app::env::ruby {
    package { ['sass', 'compass']:
        ensure => 'installed',
        provider => 'gem',
    }
}
