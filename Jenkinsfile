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
    node {
        def lib = library (
            identifier: 'my-shared-library@main'
        
        )

        buildAndDeploy {
            
        }
    }

}