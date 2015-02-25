node default {
  Package {
    require => Class['repo_manager']
  }
  hiera_include('classes')
}
