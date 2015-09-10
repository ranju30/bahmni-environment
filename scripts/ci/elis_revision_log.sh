revision='{
    "go" : "https://ci-bahmni.thoughtworks.com/go/pipelines/value_stream_map/_jobname_/_pipelineCount_",
    "github": "https://github.com/Bhamni/OpenElis/commit/_sha_"
}'

jobName=`env | egrep "GO_PIPELINE_NAME=" | sed "s/GO_PIPELINE_NAME=//g"`
pipelineCounter=`env | egrep "GO_PIPELINE_COUNTER=" | sed "s/GO_PIPELINE_COUNTER=//g"`
sha=`env | egrep "GO_REVISION_OPENELIS_GITHUB=" | sed "s/GO_REVISION_OPENELIS_GITHUB=//g"`

echo $revision | sed "s/_pipelineCount_/$pipelineCounter/g" | sed "s/_jobname_/$jobName/g" | sed "s/_sha_/$sha/g"

