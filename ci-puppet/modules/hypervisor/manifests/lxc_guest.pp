# Configure an LXC "VM".

# This gets us 90% of the way to a working slave, but we still have to
# configure a few things in the slave and install it by hand. See the
# "/etc/libvirt/lxc/install-${title}.sh" shell script for details.

define hypervisor::lxc_guest ($lxc_ip) {

  # Determine the LXC's hostname
  $lxc_hostname = "${title}.${::fqdn}"

  # Our VMs will all be on a private network,
  # so we need static /etc/hosts entries for each one.
  host { $lxc_hostname :
    ip => $lxc_ip,
  }

  # Create a chroot for this VM.
  file { "/var/lib/libvirt/lxc/${title}":
    ensure => directory,
  }

  # Create a template XML file for this host.
  file { "/etc/libvirt/lxc/${title}.xml.tmpl":
    ensure  => file,
    content => template('hypervisor/builder.xml.erb'),
    require => File['/etc/libvirt/lxc'],
  }

  # Autostart the VM, if it's already been imported.
  exec { "autostart_${title}":
    command     => "/usr/bin/virsh autostart ${title}",
    creates     => "/etc/libvirt/lxc/autostart/${title}.xml",
    environment => 'LIBVIRT_DEFAULT_URI=lxc:///',
    onlyif      => "/usr/bin/test -f /etc/libvirt/lxc/${title}.xml",
  }

  # Create a shell script to handle the rest of the steps manually.
  # Exec'ing this in Puppet will time out, because the yum commands
  # take so long to complete.
  file { "/etc/libvirt/lxc/install-${title}.sh":
    ensure  => file,
    content => template('hypervisor/builder-install.sh.erb'),
    require => File['/etc/libvirt/lxc'],
    mode    => '0755'
  }

}
