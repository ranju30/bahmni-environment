$build_output_dir = "${package_dir}/build"

$deployment_log_file = "${logs_dir}/bahmni_deploy.log"
$deployment_log_expression = ">> ${deployment_log_file} 2>> ${deployment_log_file}"

$bahmni_openerp_branch = "master"
$bahmni_openerp_temp_dir = "${temp_dir}/bahmni-openerp"
$openerp_base_data_dump = "bahmni-openerp-base-data.sql"