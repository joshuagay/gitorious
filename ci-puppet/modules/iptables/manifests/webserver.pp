# Firewall configuration for Gitorious' Jenkins

class iptables::webserver {
  package { 'iptables':
    ensure => installed,
  }
  service { 'iptables':
    ensure     => running,
    enable     => true,
    hasstatus  => true,
    hasrestart => true,
    require    => Package['iptables'],
  }
  file { '/etc/sysconfig/iptables':
    source => 'puppet:///modules/iptables/iptables.sysconfig',
    notify => Service['iptables'],
  }
}
