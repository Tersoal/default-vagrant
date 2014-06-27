class app::webserver::nginxserver {
    require app::ssl
    class { 'nginx': }

    case $::osfamily {
        Redhat: {
            $apache2_package = "httpd"
        }
        Debian: {
            $apache2_package = "apache2"
        }
    }

    package {"$apache2_package":
        ensure => purged,
    }

    nginx::resource::vhost { "$vhost.$domain":
        ensure      => 'present',
        www_root    => "$vhostpath/$vhost.$domain/web",
        index_files => [ 'app_dev.php'],
        try_files   => [ '$uri', '@rewriteindex'],
        ssl         => true,
        ssl_cert    => "/etc/ssl/private/$vhost$domain.crt",
        ssl_key     => "/etc/ssl/private/$vhost$domain.key",
        access_log  => "/var/log/nginx/access.log",
        error_log   => "/var/log/nginx/error.log",
    }

    nginx::resource::location { 'location-rewriteindex':
        ensure        => present,
        ssl           => true,
        vhost         => "$vhost.$domain",
        www_root      => "$vhostpath/$vhost.$domain/web",
        location      => '@rewriteindex',
        rewrite_rules => ['^(.*)$ /app_dev.php/$1 last'],

    }


    nginx::resource::location { 'location-phpfpm':
        ensure          => present,
        ssl             => true,
        vhost           => "$vhost.$domain",
        www_root        => "$vhostpath/$vhost.$domain/web",
        location        => '~ ^/(app|app_dev)\.php(/|$)',
        proxy           => undef,
        fastcgi         => "127.0.0.1:9000",
        location_cfg_append => {
            fastcgi_connect_timeout => '3m',
            fastcgi_read_timeout    => '3m',
            fastcgi_send_timeout    => '3m',
            fastcgi_split_path_info => '^(.+\.php)(/.*)$',
            include                 => 'fastcgi_params',
            fastcgi_param           => 'SCRIPT_FILENAME $document_root$fastcgi_script_name',
        }
    }

    file {'/etc/nginx/conf.d/php5-fpm.nginx.conf':
        ensure  => present,
        owner   => root,
        group   => root,
        content => template("/vagrant/files/etc/nginx/conf.d/php5-fpm.nginx.conf"),
        require => [File["/etc/nginx/conf.d/"]],
        notify  => Service["php5-fpm", "nginx"],
    }

    nginx::resource::vhost { "phpmyadmin.$domain":
        ensure      => 'present',
        www_root    => "/usr/share/phpmyadmin",
        index_files => [ 'index.php', 'index.html', 'index.htm'],
        listen_port => '8081',
        location_custom_cfg_prepend => [
            'if (!-e $request_filename) {
                rewrite ^/(.+)$ /index.php?url=$1 last;
                break;
            }'
        ]
    }

    nginx::resource::location { 'location-phpmyadmin':
        ensure              => present,
        vhost               => "phpmyadmin.$domain",
        location            => '~ .php$',
        fastcgi             => "127.0.0.1:9000",
        location_cfg_append => {
            fastcgi_split_path_info => '^(.+\.php)(/.+)$',
            fastcgi_index           => 'index.php',
            include                 => 'fastcgi_params',
            fastcgi_param           => 'SERVER_PORT $http_x_forwarded_port',
        }
    }
}