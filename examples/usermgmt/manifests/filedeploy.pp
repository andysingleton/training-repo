# == Define: usermgmt::filedeploy
#
# Define to deploy a file. To be called by create_resource
#
# === Examples
#
# usermgmt::filedeploy { 'myfile':
#   ensure   => 'file',
#   owner    => 'someone',
#   group    => 'somegroup',
#   mode     => '0400',
#   template => 'sometemplate',
#   content  => 'some content',
#   require  => File["somefile"],
# }
#
define usermgmt::filedeploy (
  $owner,                #ownerof file
  $group,                #group of file
  $ensure      = present,
  $mode        = '0400', #perms
  $content     = undef,  #content of the file
  $purge       = undef,
  $recurse     = undef,
  $template    = undef,
  $requirement = undef,  #dependancies
) {

  if $content != undef {

    file { $name:
      ensure  => $ensure,
      owner   => $owner,
      group   => $group,
      mode    => $mode,
      content => $content,
      require => $requirement,
    }

  } elsif $template != undef {

    file { $name:
      ensure  => $ensure,
      owner   => $owner,
      group   => $group,
      mode    => $mode,
      content => template($template),
      require => $requirement,
    }

  } else {

    file { $name:
      ensure  => $ensure,
      owner   => $owner,
      group   => $group,
      purge   => $purge,
      recurse => $recurse,
      mode    => $mode,
      require => $requirement,
    }

  }

}

