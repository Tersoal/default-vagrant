class app::server {
    require app::ssl
    class { 'nginx': }

    nginx::resource::vhost { "$vhost.$domain":
        ensure      => 'present',
        www_root    => "$vhostpath/$vhost.$domain/web",
        index_files => ['app_dev.php'],
        try_files   => ['$uri', '@rewriteindex'],
        ssl         => true,
        ssl_cert    => "/etc/ssl/private/$vhost$domain.crt",
        ssl_key     => "/etc/ssl/private/$vhost$domain.key",
        access_log  => '/var/log/nginx/access.log',
        error_log   => '/var/log/nginx/error.log',
    }

    nginx::resource::location { 'location-rewriteindex':
        ensure        => present,
        ssl           => true,
        vhost         => "$vhost.$domain",
        www_root      => "$vhostpath/$vhost.$domain/web",
        location      => '@rewriteindex',
        rewrite_rules => ['^(.*)$ /app_dev.php/$1 last'],
    }

    nginx::resource::location { 'location':
        ensure              => present,
        vhost               => "$vhost.$domain",
        www_root            => "$vhostpath/$vhost.$domain/web",
        location            => '~ \.php$',
        proxy               => undef,
        fastcgi             => "unix:/var/run/php/php7.0-fpm.sock",
        location_cfg_append => {
            include => 'fastcgi_params',
        }
    }

    nginx::resource::location { 'location-uploads':
        ensure    => present,
        vhost     => "$vhost.$domain",
        www_root  => "$vhostpath/$vhost.$domain/web",
        location  => '~ ^/uploads/cache',
        try_files => ['$uri', '@rewriteindex'],
    }

    nginx::resource::location { 'location-phpfpm':
        ensure          => present,
        ssl             => true,
        vhost           => "$vhost.$domain",
        www_root        => "$vhostpath/$vhost.$domain/web",
        location        => '~ ^/(app|app_dev|app_test)\.php(/|$)',
        proxy           => undef,
        fastcgi         => "unix:/var/run/php/php7.0-fpm.sock",
        location_cfg_append => {
            fastcgi_connect_timeout => '3m',
            fastcgi_read_timeout    => '3m',
            fastcgi_send_timeout    => '3m',
            fastcgi_split_path_info => '^(.+\.php)(/.*)$',
            include                 => 'fastcgi_params',
        }
    }

    file {'/etc/nginx/conf.d/php7-fpm.nginx.conf':
        ensure  => present,
        owner   => root,
        group   => root,
        content => template('/vagrant/files/etc/nginx/conf.d/php7-fpm.nginx.conf'),
        require => [File['/etc/nginx/conf.d/']],
        notify  => Service['php7.0-fpm', 'nginx'],
    }

    nginx::resource::vhost { "phpmyadmin.$domain":
        ensure      => 'present',
        www_root    => "/usr/share/phpmyadmin",
        index_files => [ 'index.php', 'index.html', 'index.htm'],
        location_custom_cfg_prepend => [
            'if (!-e $request_filename) {
                rewrite ^/(.+)$ /index.php?url=$1 last;
                break;
            }'
        ]
    }

    nginx::resource::location { 'location-phpmyadmin':
        ensure              => present,
        www_root            => "/usr/share/phpmyadmin",
        vhost               => "phpmyadmin.$domain",
        location            => '~ .php$',
        fastcgi             => "unix:/var/run/php/php7.0-fpm.sock",
        location_cfg_append => {
            fastcgi_split_path_info => '^(.+\.php)(/.+)$',
            fastcgi_index           => 'index.php',
            include                 => 'fastcgi_params',
            fastcgi_param           => 'SERVER_PORT $http_x_forwarded_port',
        }
    }
}