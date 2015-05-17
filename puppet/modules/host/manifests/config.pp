class host::config inherits global {
  $os_path="${::global::os_path}"
  $package_dir="${::global::package_dir}"
}