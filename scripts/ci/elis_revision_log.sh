revision='{
    "go" : "https://ci-bahmni.thoughtworks.com/go/pipelines/value_stream_map/_jobname_/_pipelineCount_",
    "github": "https://github.com/Bhamni/OpenElis/commit/_sha_"
}'

echo "----------"
echo env
echo "----------"
jobName=`env | egrep "GO_JOB_NAME=" | sed "s/GO_JOB_NAME=//g"`
pipelineCount=`env | egrep "GO_PIPELINE_LABEL=" | sed "s/GO_PIPELINE_LABEL=//g"`
sha=`env | egrep "GO_REVISION=" | sed "s/GO_REVISION=//g"`

echo $revision | sed "s/_pipelineCount_/$pipelineCount/g" | sed "s/_jobname_/$jobName/g" | sed "s/_sha_/$sha/g"

