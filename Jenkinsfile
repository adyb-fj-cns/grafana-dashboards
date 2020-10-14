podTemplate(containers: [
  containerTemplate(name: 'grafonnet', image: 'adybfjcns/grafonnet', ttyEnabled: true, command: 'cat')
]) {
    node(POD_LABEL) {
        git branch: 'main', url: 'https://github.com/adyb-fj-cns/grafana-dashboards'

        def lib = library (
            identifier: 'my-shared-library@main'
        )

        convertDashboards {
            containerName = 'grafonnet'
            sourceDir = 'dashboards-jsonnet'
        }

        uploadDashboards {
            containerName = 'grafonnet'
            credentialsId = 'grafana'
            sourceDir = 'dashboards-jsonnet'
            grafanaUrl = 'grafana-ui:3000'
        }    
    }
}