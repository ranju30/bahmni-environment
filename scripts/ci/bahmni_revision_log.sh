revision='{
    "go" : "https://ci-bahmni.thoughtworks.com/go/pipelines/value_stream_map/_jobname_/_pipelineCount_",
    "github": {
        "bahmni_core" : "https://github.com/Bahmni/bahmni-core/commit/_bahmniCoreSha_",
        "openmrs" : "https://github.com/Bahmni/openmrs-distro-bahmni/commit/_openmrsSha_",
        "openmrs_modules" : "https://github.com/Bahmni/openmrs-module-bahmniapps/commit/_openmrsModulesSha_",
        "functional_tests" : "https://github.com/Bahmni/emr-functional-tests/commit/_functionalTestsSha_",
        "config" : "https://github.com/Bahmni/default-config/commit/_defaultConfigSha_"
    }
}'

replace() {
    envValue=`env | egrep "$2=" | sed "s/$2=//g"`
    sed "s/$1/$envValue/g"
}

echo $revision | replace "_jobname_" "GO_PIPELINE_NAME" | replace "_pipelineCount_" "GO_PIPELINE_COUNTER" | replace "_defaultConfigSha_" "GO_REVISION_DEFAULT_CONFIG" | replace "_bahmniCoreSha_" "GO_REVISION_BAHMNI_CORE" | replace "_openmrsSha_" "GO_REVISION_OPENMRS_DISTRO_BAHMNI" | replace "_openmrsModulesSha_" "GO_REVISION_OPENMRS_MODULE_BAHMNIAPPS" | replace "_functionalTestsSha_" "GO_REVISION_EMR_FUNCTIONAL_TESTS"


