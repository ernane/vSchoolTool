exec { 'update':
  command => '/usr/bin/apt-get update'
}

node 'schooltool.loc'{
  class { 'schooltool':}
}
