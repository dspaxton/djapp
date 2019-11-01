for log in $(aws logs describe-log-groups --region eu-west-1 |grep logGroupName | awk '{ print $2}' | cut -f1 -d, | grep appmesh | cut -f2 -d\")
do
aws logs delete-log-group --log-group-name $log
done
