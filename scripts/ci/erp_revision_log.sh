revision='{
    "go" : "https://ci-bahmni.thoughtworks.com/go/pipelines/value_stream_map/_jobname_/_pipelineCount_",
    "github": {
        "openerp_modules" : "https://github.com/Bhamni/openerp-modules/commit/_modulesSha_",
        "functional_tests" : "https://github.com/Bhamni/openerp-functional-tests/commit/_functionalTestsSha_",
        "atomfeed" : "https://github.com/Bhamni/openerp-atomfeed-service/commit/_atomFeedSha_"
    }
}'

replace() {
    envValue=`env | egrep "$2=" | sed "s/$2=//g"`
    sed "s/$1/$envValue/g"
}

echo $revision | replace "_jobname_" "GO_PIPELINE_NAME" | replace "_pipelineCount_" "GO_PIPELINE_COUNTER" | replace "_modulesSha_" "GO_REVISION_OPENERP_MODULES" | replace "_functionalTestsSha_" "GO_REVISION_OPENERP_FUNCTIONAL_TESTS" | replace "_atomFeedSha_" "GO_REVISION_OPENERP_ATOMFEED_SERVICE"
