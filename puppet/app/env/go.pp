class app::env::go {
    class { 'golang':
        version => $golang_version,
    }

    exec { '/usr/local/go/bin/go get github.com/revel/cmd/revel':
        require => Class['golang'],
    }
}
