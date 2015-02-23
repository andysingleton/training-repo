# == Class: usermgmt
#
# This module creates users groups from a hiera hashes
#
# === Security
#
# This module can be used to appy the following security recommendation.
# Block shell and login access for all non-root system accounts.
# Reference: CIS: 9.1, NSA: 2.3.1.4
#
# === Parameters
#
# [*userlist*]
#   Hash of file user parameters
#
# === Examples
#
# [*hiera*]
#  classes: - 'usermgmt'
#  usermgmt::userlist:
#    'someuser':
#      shell: '/sbin/nologin'
#      uid: '400'
#      ssh_keys:
#        'mykey':
#          type: 'ssh-rsa'
#          key:  'mykeydata=='
#  usermgmt::group:
#    'somegroup':
#      gid: '3000'
#
class usermgmt (
  $enable_user_clean = false,
  $userhash          = undef,
  $grouphash         = undef,
) {

  $userlist  = hiera_hash('usermgmt::userlist', $userhash)
  $grouplist = hiera_hash('usermgmt::grouplist', $grouphash)

  unless $grouplist == undef {

    validate_hash($grouplist)
    create_resources('usermgmt::group', $grouplist)

  }

  unless $userlist == undef {
    validate_hash($userlist)
    if $enable_user_clean {
      validate_hash($::user_absent)
      $complete_userlist = merge($::user_absent,$userlist)
    } else {
      $complete_userlist = $userlist
    }

    package { 'libshadow':
      ensure   => present,
      provider => gem,
    }

    validate_hash($complete_userlist)
    create_resources('usermgmt::user', $complete_userlist)

  }

}
