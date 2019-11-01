echo Prepare for Cluster AutoScaler Install
ClusterName=appmesh-demo
ASGNAME=$(aws autoscaling describe-auto-scaling-groups --query "AutoScalingGroups[?starts_with(AutoScalingGroupName, 'eksctl')]|[0:1].[AutoScalingGroupName]" --output text)
AWS_REGION=eu-west-1
echo $ASGNAME


#cd 1_create_the_initial_architecture
# Inject cluster name into cluster-autoscaler.yaml

echo Update with cluster 
gsed "s|- --node-group-auto-discovery=asg:tag=k8s.io/cluster-autoscaler/enabled,k8s.io/cluster-autoscaler/REPLACE_ME_WITH_CLUSTER_NAME|- --node-group-auto-discovery=asg:tag=k8s.io/cluster-autoscaler/enabled,k8s.io/cluster-autoscaler/${ClusterName}|g"  1_create_the_initial_architecture/cluster-autoscaler.template > 1_create_the_initial_architecture/cluster-autoscaler.yaml




echo update with region

# Inject correct AWS region into cluster-autoscaler.yaml
gsed -i "/            - name: AWS_REGION/{n;s/              value: REPLACE_ME_WITH_AWS_REGION/              value: ${AWS_REGION}/}" 1_create_the_initial_architecture/cluster-autoscaler.yaml


# Deploy the Cluster Autoscaler
kubectl apply -f 1_create_the_initial_architecture/cluster-autoscaler.yaml


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

