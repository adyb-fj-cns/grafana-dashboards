podTemplate(yaml: """
apiVersion: v1
kind: Pod
metadata:
  name: pod
spec:
  containers:
  - name: grafonnet
    image: adybfjcns/grafonnet
    command:
    - cat
    tty: true
    resources:
      requests:
        memory: "32Mi"
        cpu: "100m"
      limits:
        memory: "64Mi"
        cpu: "200m"  
""") {
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