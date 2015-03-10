# Automatically apply yum updates every night.

class yum::autopilot($ensure = present) {

  # Don't update the kernel since that requires manual intervention.

  cron { 'yum-autopilot':
    ensure  => $ensure,
    command => '/usr/bin/yum -y update -x kernel -q >/dev/null 2>&1',
    user    => 'root',
    hour    => 1,
    minute  => 0,
  }
}
