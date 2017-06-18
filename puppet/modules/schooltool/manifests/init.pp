class schooltool {

  if ! defined(Package['schooltool']) {
    package { ['schooltool']:
    ensure  => latest,
    require => Exec['update'],
    }
  }

  service { 'schooltool':
    ensure     => 'running',
    enable     => true,
    alias      => 'schooltool::schooltool',
    hasstatus  => true,
    hasrestart => true,
    require    => Package['schooltool'],
  }

  exec { '/usr/bin/perl -pi -e "s/^.*host.*$/host = 0.0.0.0/" "/etc/schooltool/standard/paste.ini"':
    onlyif  => '/bin/grep "host.*\=.*127\.0\.0\.1" /etc/schooltool/standard/paste.ini',
    require => Package['schooltool'],
    notify  => Service['schooltool'],
  }

  file { '/etc/schooltool/standard/schooltool.conf':
    ensure  => file,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    source  => 'puppet:///modules/schooltool/schooltool.conf',
    require => Package['schooltool'],
    notify  => Service['schooltool']
  }
}
