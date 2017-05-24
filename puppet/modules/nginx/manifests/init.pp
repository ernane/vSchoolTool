# Class: nginx
#
#
class nginx {

   Exec {
      path => ['/usr/bin', '/bin', '/usr/sbin', '/sbin', '/usr/local/bin', '/usr/local/sbin']
   }

   # Common packages
  $commonPackages = ['curl', 'build-essential', 'libxml2', 'libxml2-dev', 'libxslt1-dev', 'python-software-properties', 'vim']
    package { $commonPackages:
      ensure  => latest,
      require => Exec['update'],
  }

  if ! defined(Package['nginx']) {
    package { 'nginx':
      ensure  => latest,
      require => Exec['update'],
    }
  }

  service { 'nginx':
    ensure  => 'running',
    enable  => true,
    require => Package['nginx'],
  }

  # Add a vhost template
  file { 'nginx-vhost':
    ensure  => file,
    path    => '/etc/nginx/sites-available/schooltool.conf',
    require => Package['nginx'],
    source  => 'puppet:///modules/nginx/schooltool.conf',
  }

  file { '/etc/nginx/nginx.conf':
    ensure  => file,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    source  => 'puppet:///modules/nginx/nginx.conf',
    require => Package['nginx'],
    notify  => Service['nginx']
  }

  # Disable the default nginx vhost
  file { 'default-nginx-disable':
    ensure  => absent,
    path    => '/etc/nginx/sites-enabled/default',
    require => Package['nginx'],
  }

   # Symlink our vhost in sites-enabled to enable it
  file { 'vagrant-nginx-enable':
    ensure  => link,
    target  => '/etc/nginx/sites-available/schooltool.conf',
    path    => '/etc/nginx/sites-enabled/schooltool.conf',
    notify  => Service['nginx'],
    require => [
      File['nginx-vhost'],
      File['default-nginx-disable'],
    ],
  }
}
