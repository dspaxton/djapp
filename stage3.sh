echo
echo Showing existing pods - note the 1/1 under the READY column
echo This indicates 1 container in each pod
echo
kubectl get pods -n prod

echo "Hit enter to continue"
read -e
echo
echo "Look inside one of the jazz pods to see what container(s) are running"
echo

jazzpod=$(kubectl get pods -l app=jazz -o json -nprod | jq .items[0].metadata.name | sed 's/"//g')
kubectl describe pod -n prod ${jazzpod} | awk '/Containers/,/QoS/'
echo "We can see there is only one container, the jazz container itself"
echo "Hit enter to continue"
read -e



#echo
#echo Create Jazz and Metal v2 Resources
#echo

#kubectl apply -nprod -f 5_canary/jazz_v2.yaml
#kubectl apply -nprod -f 5_canary/jazz_service_update.yaml
#kubectl apply -nprod -f 5_canary/metal_v2.yaml
#kubectl apply -nprod -f 5_canary/metal_service_update.yaml

#sleep 30

echo
echo Bounce the deployments to include sidecars
echo

kubectl patch deployment dj -nprod -p "{\"spec\":{\"template\":{\"metadata\":{\"labels\":{\"date\":\"`date +'%s'`\"}}}}}"
kubectl patch deployment metal-v1 -nprod -p "{\"spec\":{\"template\":{\"metadata\":{\"labels\":{\"date\":\"`date +'%s'`\"}}}}}"
kubectl patch deployment jazz-v1 -nprod -p "{\"spec\":{\"template\":{\"metadata\":{\"labels\":{\"date\":\"`date +'%s'`\"}}}}}"

echo
echo "Waiting for pods to come back up."
echo
sleep 40

kubectl get pods -n prod
echo "Hit enter to continue"
read -e
jazzpod=$(kubectl get pods -l app=jazz -o json -nprod | jq .items[0].metadata.name | sed 's/"//g')
kubectl describe pod -n prod ${jazzpod} | awk '/Containers/,/QoS/'
echo "Now we can see 3 containers running in each pod"
echo "Hit enter to continue"
read -e 
echo "Deploying wrk pods to send bulk traffic to metal and jazz backends"
kubectl apply -f 3_add_crds/load-generator-metal.yaml
kubectl apply -f 3_add_crds/load-generator-jazz.yaml
