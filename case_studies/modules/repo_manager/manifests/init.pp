class repo_manager(
  $name     = 'dummy'
  $baseurl  = 'http://dummyvals'
  $desc     = 'dummy description'
  $enabled  = 0
  $gpgcheck = 0
 ) {
  yumrepo { "$name":
    baseurl => "$baseurl/$operatingsystem/$operatingsystemrelease/$architecture",,
    descr    => "$desc",
    enabled => $enabled,
    gpgcheck => $gpgcheck
  }
}
