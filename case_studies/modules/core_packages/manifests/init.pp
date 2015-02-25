class core_packages {
  # Local defaults
  Package { ensure => 'latest' }

  # Packages
  package { 'motd': }
  package { 'ntp': }
  package { 'rsync': }
  package { 'dnsmasq': }

 # Related services
  service { 'dnsmasq':
    ensure     => running,
    enable     => true,
    hasrestart => true,
    hasstatus  => true,
    require    => Package['dnsmasq']
  }
  service { 'ntpd':
    ensure     => running,
    enable     => true,
    hasrestart => true,
    hasstatus  => true,
    require    => Package['ntp']
  }

  # Resource dependencies
  Package['motd'] -> Package['ntp']
  Package['rsync'] -> Package['ntp']
  Package['ntp'] -> Package['dnsmasq']

}

