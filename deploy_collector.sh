sed 's/BASE_DOMAIN/'"${BASE_DOMAIN}"'/g'  collector.yaml > collector_temp.yaml
sed -i -e 's/CLUSTER_NAME/'"${CLUSTER_NAME}"'/g'  collector_temp.yaml

kubectl apply -f collector_temp.yaml
rm collector_temp.yaml*