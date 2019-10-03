echo Prepare for Container insights install
curl https://raw.githubusercontent.com/aws-samples/amazon-cloudwatch-container-insights/master/k8s-yaml-templates/quickstart/cwagent-fluentd-quickstart.yaml | sed "s/{{cluster_name}}/appmesh-demo/;s/{{region_name}}/eu-west-1/" | kubectl apply -f -
echo
echo Create Prod Namespace
echo

kubectl create -f 1_create_the_initial_architecture/1_prod_ns.yaml

echo
echo Initial Deployments and Services
echo

kubectl create -nprod -f 1_create_the_initial_architecture/1_initial_architecture_deployment.yaml
kubectl create -nprod -f 1_create_the_initial_architecture/1_initial_architecture_services.yaml

