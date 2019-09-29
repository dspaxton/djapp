echo
echo Create Prod Namespace
echo

kubectl create -f 1_create_the_initial_architecture/1_prod_ns.yaml

echo
echo Initial Deployments and Services
echo

kubectl create -nprod -f 1_create_the_initial_architecture/1_initial_architecture_deployment.yaml
kubectl create -nprod -f 1_create_the_initial_architecture/1_initial_architecture_services.yaml

