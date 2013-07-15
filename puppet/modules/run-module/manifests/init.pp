class run-module($moduleName) {
    import "../../../manifests/configurations/node-configuration"
    import "../../../manifests/configurations/stack-installers-configuration"
    import "../../../manifests/configurations/stack-runtime-configuration"
    import "../../../manifests/configurations/deployment-configuration"

    include $moduleName
}