class scamall::python  {
  package { ['python3.4', 'virtualenv']:
    ensure => present,
  } ->
  exec { 'mkvenv':
    command => '/usr/bin/virtualenv /home/scamall/scamall.venv -p /usr/bin/python3',
    creates => '/home/scamall/scamall.venv',
    requires => [User['scamall']],
  }
}
