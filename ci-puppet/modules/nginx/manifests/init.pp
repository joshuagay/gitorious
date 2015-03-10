# Gitorious Nginx web server config for Jenkins

class nginx {
  package { 'nginx':
    ensure => installed,
  }

  service { 'nginx':
    ensure     => running,
    enable     => true,
    hasstatus  => true,
    hasrestart => true,
    require    => Package['nginx'],
  }

  # Default nginx configuration
  file { '/etc/nginx/nginx.conf':
    ensure  => present,
    group   => 'root',
    owner   => 'root',
    source  => 'puppet:///modules/nginx/nginx.conf',
    require => Package['nginx'],
    notify  => Service['nginx'],
  }

  # Vhost configuration
  file { '/etc/nginx/conf.d/default.conf':
    ensure  => present,
    group   => 'root',
    owner   => 'root',
    content => template('nginx/conf.d/default.conf.erb'),
    require => Package['nginx'],
    notify  => Service['nginx'],
  }

  # Docroot location
  file { '/var/local/www':
    ensure  => directory,
    group   => 'root',
    owner   => 'root',
    source  => 'puppet:///modules/nginx/www',
    recurse => true,
    require => Service['nginx'],
  }

  # SSL (HTTPS) cert
  file { "${::fqdn}.crt":
    ensure  => file,
    path    => "/etc/pki/tls/certs/${::fqdn}.crt",
    group   => 'root',
    owner   => 'root',
    mode    => '0644',
    source  => "puppet:///modules/nginx/${::fqdn}.crt",
    notify  => Service['nginx'],
  }

  # Remove old SSL cert
  file { 'gitoriousci.ktdreyer.com-chained.crt':
    ensure  => absent,
    path    => '/etc/pki/tls/certs/gitoriousci.ktdreyer.com-chained.crt',
    notify  => Service['nginx'],
  }
}
