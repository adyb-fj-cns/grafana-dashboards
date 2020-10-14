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

        buildAndDeploy {
            
        }

        stage('convert'){
            container('grafonnet') {
                sh '''
                    SCRIPT_PATH="dashboards-jsonnet"; \
                    for file in $SCRIPT_PATH/*.jsonnet; \
                    do \
                        input=$(basename -- $file); \
                        output=$SCRIPT_PATH/${input%.*}.json; \
                        echo "Converting $file into $output"; \
                        jsonnet $file > $output; \
                    done
                '''
            }
            }

            stage('upload'){
            container('grafonnet') {
                withCredentials([usernamePassword(
                credentialsId: 'grafana', 
                usernameVariable: 'GRAFANA_USERNAME', 
                passwordVariable: 'GRAFANA_PASSWORD')]) {

                sh '''
                    SCRIPT_PATH="dashboards-jsonnet"; \
                    for file in $SCRIPT_PATH/*.json; \
                    do \
                    DASHBOARD=$(jq . $file); \
                    curl -X POST \
                        -H 'Content-Type: application/json' \
                        -d "{\\\"dashboard\\\": $DASHBOARD, \\\"overwrite\\\": true}" \
                        "http://$GRAFANA_USERNAME:$GRAFANA_PASSWORD@grafana-ui:3000/api/dashboards/db";
                    done
                    '''
                    
                }
            }
        }
    }

}