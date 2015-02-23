# == Define: usermgmt::group
#
# Define to create/set groups params.
#
# For further options and reading please see puppet type documentation for
# type group
#
# === Examples
#
# userimgmt::group { 'somegroup':
#   gid => '3000',
# }
#
define usermgmt::group (
  $ensure = present,
  $gid    = undef,   # The group ID.
  $system = false,   # Whether the group is a system group with lower GID
) {

  if ! defined(Group[$name]) {
    group { $name:
      ensure => present,
      gid    => $gid,
      system => $system,
    }
  }

}

