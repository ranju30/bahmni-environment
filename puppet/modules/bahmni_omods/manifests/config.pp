class bahmni_omods::config inherits global {
  $bahmni_user="${::global::bahmni_user}"
  $build_output_dir="${::global::build_output_dir}"
  $tomcatInstallationDirectory="${::global::tomcatInstallationDirectory}"
  $webapps_dir="${::global::webapps_dir}"

  $openmrs_modules_dir = "/home/${bahmni_user}/.OpenMRS/modules"
  $ui_modules_dir = "${build_output_dir}/ui-modules"
  $liquibase_jar="${webapps_dir}/openmrs/WEB-INF/lib/liquibase-core-2.0.5.jar"
  $openmrs_war_path="${build_output_dir}/${openmrs_distro_file_name_prefix}/${openmrs_war_file_name}.war"
}