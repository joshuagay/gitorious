# Gitorious config for local Jenkins slave accounts
define gitorious_jenkins::slave ($ssh_key) {

  # System account username.
  $username = "jenkins-${title}"

  # Create system account.
  user { $username :
    ensure     => present,
    comment    => "jenkins slave for ${title}",
    system     => true,
    home       => "/var/local/jenkins/${title}",
    managehome => true,
    require    => File['/var/local/jenkins'],
  }
  # Set up SSH public key for this system account.
  ssh_authorized_key { $username:
    ensure  => present,
    require => User[$username],
    name    => "${username}@${::fqdn}",
    type    => 'ssh-rsa',
    key     => $ssh_key,
    user    => $username,
  }
}
