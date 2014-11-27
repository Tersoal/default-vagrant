class mysql::client::install {

  package { 'mysql_client':
    require => Exec["apt-update-mysql"],
    ensure  => $mysql::client::package_ensure,
    name    => $mysql::client::package_name,
  }

}
