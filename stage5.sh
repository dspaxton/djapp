echo "Switching Jazz service to 0/100 v1/v2"
kubectl apply -f 6_cutover/jazz_service_update.yaml
echo "Switching Metal service to 0/100 v1/v2"
kubectl apply -f 6_cutover/metal_service_update.yaml

