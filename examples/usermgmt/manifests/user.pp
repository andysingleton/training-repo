# == Define: usermgmt::user
#
# Define to create/set users params and user ssh pub keys.
#
# For further options and reading please see puppet type documentation for
# types user and ssh_authorized_key
#
# === Examples
#
# userimgmt::user { 'someuser':
#   shell => '/bin/bash',
# }
#
define usermgmt::user (
  $ensure           = present,
  $fullname         = undef,           # Users full name
  $email            = undef,           # Users email address
  $comment          = '',              # Comment field
  $expiry           = undef,           # User expiry date YYYY-MM-DD
  $gid              = undef,           # The user's primary group.
  $groups           = undef,           # Groups to which the user belongs
  $home             = "/home/${name}", # The home directory of the user.
  $manage_home      = true,            # Manage user home
  $manage_ssh       = true,            # Manage users .ssh folder
  $purge_home       = true,            # Clean users homes dirs
  $password         = undef,           # User password
  $password_max_age = undef,           # Max password age
  $password_min_age = undef,           # Min password age
  $provider         = undef,           # Backend, 'useradd' is default
  $shell            = '/bin/bash',     # The user's login shell.
  $system           = undef,           # Whether user is a system user
  $uid              = undef,           # The user ID
  $ssh_pub_keys     = undef,           # A hash of the users pubilc keys
  $ssh_private_keys = undef,           # A hash of the users private keys
  $home_dir_files   = {},              # Hash of files copied to home dir
  $home_dir_mode    = '0750',          # Mode of the home dir
) {

  #If we dont explicitly set a comment then use full name and email
  if $fullname or $email {
    $full_comment = "${fullname} <${email}>"
  } else {
    $full_comment = $comment
  }

  if ! defined(User[$name]) {
    user { $name:
      ensure           => $ensure,
      comment          => $full_comment,
      expiry           => $expiry,
      gid              => $gid,
      groups           => $groups,
      home             => $home,
      managehome       => $manage_home,
      password         => $password,
      password_max_age => $password_max_age,
      password_min_age => $password_min_age,
      provider         => $provider,
      shell            => $shell,
      system           => $system,
      uid              => $uid,
    }

    case $ensure {
      present: {
        $dir_ensure = directory
      }
      default: {
        $dir_ensure = absent
      }
    }

    if $manage_home or $manage_ssh {

      file { $home:
        ensure  => $dir_ensure,
        owner   => $name,
        group   => $name,
        mode    => $home_dir_mode,
        recurse => $purge_home,
        purge   => $purge_home,
        force   => $purge_home,
        require => User[$name],
      }

      if $manage_ssh {

        file { "${home}/.ssh":
          ensure  => $dir_ensure,
          owner   => $name,
          group   => $name,
          mode    => '0700',
          recurse => true,
          purge   => true,
          require => File[$home],
        }

        file { "${home}/.ssh/known_hosts":
          ensure  => $ensure,
          owner   => $name,
          group   => $name,
          mode    => '0600',
          require => File["${home}/.ssh"],
        }

        unless $ssh_pub_keys == undef {

          file { "${home}/.ssh/authorized_keys":
            ensure  => $ensure,
            owner   => $name,
            group   => $name,
            mode    => '0600',
            content => template("${module_name}/authorized_keys.erb"),
            require => File["${home}/.ssh"],
          }

        }

        unless $ssh_private_keys == undef {

          $ssh_private_keys_defaults = {
            ensure      => $ensure,
            owner       => $name,
            group       => $name,
            mode        => '0600',
            requirement => File["${home}/.ssh"],
          }

          create_resources('usermgmt::filedeploy', $ssh_private_keys, $ssh_private_keys_defaults)
        }

      }

      if $ensure == present {
        if $manage_home {

          $local_home_dir_files = { "${home}/.bashrc"                     => {content => undef, template => undef},
                                    "${home}/.profile"                    => {content => undef, template => undef},
                                    "${home}/.bash_logout"                => {content => undef, template => undef},
                                    "${home}/.bash_history"               => {ensure  => absent, content => undef, template => undef},
                                    "${home}/.viminfo"                    => {content => undef, template => undef},
                                    "${home}/.sudo_as_admin_successful"   => {content => undef, template => undef},
                                    "${home}/.cache"                      => {ensure => directory, purge => true, recurse => true, content => undef, template => undef},
                                    "${home}/.cache/motd.legal-displayed" => {content => undef, template => undef},
          }

          $merged_home_dir_files = merge($local_home_dir_files, $home_dir_files)

          unless $merged_home_dir_files == {} {

            $home_dir_files_defaults = {
              ensure      => $ensure,
              owner       => $name,
              group       => $name,
              mode        => '0600',
              requirement => User[$name],
            }

            create_resources('usermgmt::filedeploy', $merged_home_dir_files, $home_dir_files_defaults)
          }

        }
      }

    }
  }

}

