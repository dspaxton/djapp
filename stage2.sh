
echo
echo Create Injector Controller
echo

cd 2_create_injector
./create.sh
cd ..
kubectl label namespace prod appmesh.k8s.aws/sidecarInjectorWebhook=enabled

echo
echo Create CRDs
echo

sleep 5

kubectl apply -f 3_add_crds/mesh-definition.yaml
kubectl apply -f 3_add_crds/virtual-node-definition.yaml
kubectl apply -f 3_add_crds/virtual-service-definition.yaml
kubectl apply -f 3_add_crds/controller-deployment.yaml

sleep 15

echo
echo Create Mesh
echo

kubectl create -nprod -f 4_create_initial_mesh_components/mesh.yaml

sleep 15

echo
echo Create Virtual Nodes for Virtual Services
echo

kubectl create -nprod -f 4_create_initial_mesh_components/nodes_representing_virtual_services.yaml


echo
echo Create Placeholder Services for Virtual Nodes for Virtual Services
echo

kubectl create -nprod -f 4_create_initial_mesh_components/metal_and_jazz_placeholder_services.yaml

echo
echo Create Virtual Nodes for Physical Services and Virtual Services
echo

kubectl create -nprod -f 4_create_initial_mesh_components/nodes_representing_physical_services.yaml
kubectl apply -nprod -f 4_create_initial_mesh_components/virtual-services.yaml

