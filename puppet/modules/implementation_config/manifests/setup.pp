class implementation_config::setup($implementation_name = $implementation_name) {
  $implementation_zip_file = "${build_output_dir}/${implementation_name}_config.zip"

  exec { "unzip_${implementation_name}" :
    command   => "rm -rf ${build_output_dir}/${implementation_name}_config && unzip -q -o $implementation_zip_file -d ${build_output_dir}/${implementation_name}_config ${deployment_log_expression}",
    provider  => shell,
    path      => "${os_path}"
  }
}