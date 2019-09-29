echo
echo Create Jazz and Metal v2 Resources
echo

kubectl apply -nprod -f 5_canary/jazz_v2.yaml
kubectl apply -nprod -f 5_canary/jazz_service_update.yaml
kubectl apply -nprod -f 5_canary/metal_v2.yaml
kubectl apply -nprod -f 5_canary/metal_service_update.yaml
