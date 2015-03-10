# Libvirt configuration for Gitorious' Jenkins

class hypervisor {
  package { 'libvirt':
    ensure => installed,
  }
  service { 'libvirtd':
    ensure     => running,
    enable     => true,
    hasstatus  => true,
    hasrestart => true,
    require    => Package['libvirt'],
  }
  file { '/etc/sysconfig/libvirt-guests':
    source  => 'puppet:///modules/hypervisor/libvirt-guests.sysconfig',
    notify  => Service['libvirtd'],
    require => Package['libvirt'],
  }

  # Set up the area for LXC guest configs
  file { '/etc/libvirt/lxc':
    ensure  => directory,
    require => Package['libvirt'],
  }

  # cgconfig is necessary for installing LXCs
  service { 'cgconfig':
    ensure     => running,
    enable     => true,
    hasstatus  => true,
    hasrestart => true,
    require    => Package['libvirt'],
  }

  # install "virt-install" tool
  package { 'python-virtinst':
    ensure => installed,
  }

}
