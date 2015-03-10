# Gitorious.org config for a Jenkins builder

class gitorious_jenkins::builder($scl = 'UNSET', $scl_url = 'UNSET') {

  # Homedir parent location for slave account(s)
  file { '/var/local/jenkins':
    ensure => directory,
    group  => 'root',
    owner  => 'root',
    mode   => '0755',
  }

  # The Gitorious test suite requires MySQL.
  # We can install and enable MySQL, but there are still manual steps required.
  # 1. Run mysql_secure_installation
  # 2. Run mysql -p
  # 3. mysql> CREATE DATABASE gitorious_test;
  # 4. mysql> CREATE USER 'gitorious'@'localhost' IDENTIFIED BY 'gitorious';
  # 5. mysql> GRANT ALL ON gitorious_test.* TO 'gitorious'@'localhost';
  package { 'mysql-server':
    ensure => installed,
  }
  service { 'mysqld':
    ensure     => running,
    enable     => true,
    hasstatus  => true,
    hasrestart => true,
    require    => Package['mysql-server'],
  }

  # Other dependencies (for bundler's gem installations)
  package { [
    'file',
    'gcc',
    'gcc-c++',
    'ImageMagick-devel',
    'libicu-devel',
    'libxml2-devel',
    'libxslt-devel',
    'make',
    'mysql-devel',
    'oniguruma-devel',
    'postgresql-devel',
    'patch',
    'sphinx',
    'tar',
    'nodejs',
  ]:
    ensure => installed,
  }

  # Should we use the standard ruby packages,
  # or should we use an alternate SCL package?
  if ($scl == 'UNSET') {
    $ruby_devel = 'ruby-devel'
  } else {
    $ruby_devel = "${scl}-ruby-devel"
    yumrepo {$scl :
      descr    => "${scl} SCL",
      baseurl  => $scl_url,
      gpgcheck => 0,
      before   => Package[$scl, $ruby_devel],
    }
    package { $scl :
      ensure => installed,
    }
  }

  package { $ruby_devel :
    ensure => installed,
  }

}
