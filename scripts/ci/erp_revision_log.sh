revision='{
    "go" : "https://ci-bahmni.thoughtworks.com/go/pipelines/value_stream_map/_jobname_/_pipelineCount_",
    "github": {
        "openerp_modules" : "https://github.com/Bhamni/openerp-modules/commit/_modulesSha_",
        "functional_tests" : "https://github.com/Bhamni/openerp-functional-tests/commit/_functionalTestsSha_",
        "atomfeed" : "https://github.com/Bhamni/openerp-atomfeed-service/commit/_atomFeedSha_"
    }
}'

jobName=`env | egrep "GO_PIPELINE_NAME=" | sed "s/GO_PIPELINE_NAME=//g"`
pipelineCounter=`env | egrep "GO_PIPELINE_COUNTER=" | sed "s/GO_PIPELINE_COUNTER=//g"`
modulesSha=`env | egrep "GO_REVISION_OPENERP_MODULES=" | sed "s/GO_REVISION_OPENERP_MODULES=//g"`
functionaTestsSha=`env | egrep "GO_REVISION_OPENERP_FUNCTIONAL_TESTS=" | sed "s/GO_REVISION_OPENERP_FUNCTIONAL_TESTS=//g"`
atomFeedSha=`env | egrep "GO_REVISION_OPENERP_ATOMFEED_SERVICE=" | sed "s/GO_REVISION_OPENERP_ATOMFEED_SERVICE=//g"`

echo $revision | sed "s/_pipelineCount_/$pipelineCounter/g" | sed "s/_jobname_/$jobName/g" | sed "s/_modulesSha_/$modulesSha/g" | sed "s/_functionalTestsSha_/$functionaTestsSha/g" | sed "s/_atomFeedSha_/$atomFeedSha/g"

