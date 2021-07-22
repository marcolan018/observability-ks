# observability-non-ocp

1. Update csv "advanced-cluster-management.v2.3.0" in hub cluster. Replace the image to "blue0/multicluster-observability-operator:ks" in the deployment "multicluster-observability-operator". This patched image will remove the restriction that observability only enabled in OpenShift platform.

2. Import the cluster into hub cluster.

3. In the imported cluster, after "open-cluster-management-addon-observability" namespace created, run command below to create collector. Replace the value for BASE_DOMAIN with hub cluster's domain, value for CLUSTER_NAME with managed cluster name.
```
export CLUSTER_NAME=eks
export BASE_DOMAIN=obs-china-aws-4616-7vn4f.dev05.red-chesterfield.com
./deploy_collector.sh
```

4. Install prometheus and exporters using command below:
```
./deploy_prometheus.sh
```