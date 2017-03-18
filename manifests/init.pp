# Main SELinux class to be included on all nodes. If SELinux isn't enabled
# it does nothing anyway.
#
class selinux {

  if $::selinux {
    # The audit2allow tool was split out in -python at some point
    $audit2allow = "${::operatingsystem}-${::operatingsystemrelease}" ? {
      'Fedora-10' => 'policycoreutils',
       default    => 'policycoreutils-python',
    }
    # The restorecond tool was split out in -restorecond at some point
    if $::operatingsystem == 'Fedora' and $::operatingsystemrelease > 16 {
      package { 'policycoreutils-restorecond': ensure => installed }
    }
    package { 'libselinux-ruby': ensure => installed }
    package { $audit2allow:
      alias  => 'audit2allow',
      ensure => installed,
    }
    service { 'restorecond':
      enable    => true,
      ensure    => running,
      hasstatus => true,
    }
    # The parent directory used from selinux::audit2allow
    @file { '/etc/selinux/local': ensure => directory }
  }

}

