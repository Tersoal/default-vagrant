class app::env::node {
    if ($nodejs_version != 'stable' and $nodejs_version != 'latest') {
      $nodejs_version = "v${nodejs_version}"
    }

    class { 'nodejs':
        version => $nodejs_version,
    }

    package { 'gulp':
        ensure   => 'present',
        provider => 'npm',
        require  => Class['nodejs']
    }

    package { 'grunt-cli':
        ensure   => 'present',
        provider => 'npm',
        require  => Class['nodejs'],
    }

    package { 'bower':
        ensure   => 'present',
        provider => 'npm',
        require  => Class['nodejs'],
    }
}
