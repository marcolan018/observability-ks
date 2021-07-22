sed_command='sed -i-e -e'
if [[ "$(uname)" == "Darwin" ]]; then
    sed_command='sed -i '-e' -e'
fi

deploy_prometheus_operator() {
    echo "Install prometheus"
    git clone https://github.com/coreos/kube-prometheus.git
    pushd kube-prometheus
    git checkout release-0.8
    popd

    #kubectl create namespace openshift-monitoring
    echo "Replace namespace with open-cluster-management-addon-observability"
    $sed_command "s~namespace: monitoring~namespace: open-cluster-management-addon-observability~g" kube-prometheus/manifests/*.yaml
    $sed_command "s~namespace: monitoring~namespace: open-cluster-management-addon-observability~g" kube-prometheus/manifests/setup/*.yaml
    $sed_command "s~name: monitoring~name: open-cluster-management-addon-observability~g" kube-prometheus/manifests/setup/*.yaml
    $sed_command "s~replicas:.*$~replicas: 1~g" kube-prometheus/manifests/prometheus-prometheus.yaml
    
    # remove unused resources
    rm -rf kube-prometheus/manifests/alertmanager-*.yaml
    rm -rf kube-prometheus/manifests/grafana-*.yaml
    rm -rf kube-prometheus/manifests/blackbox-exporter-*.yaml
    rm -rf kube-prometheus/manifests/prometheus-adapter-*.yaml

    # change interval from 5m to 1m for node exporter rules
    $sed_command "s/5m/1m/g" kube-prometheus/manifests/node-exporter-prometheusRule.yaml

    kubectl create -f kube-prometheus/manifests/setup
    until kubectl get servicemonitors --all-namespaces ; do date; sleep 1; echo ""; done
    kubectl create -f kube-prometheus/manifests/
    #rm -rf kube-prometheus
}

deploy_prometheus_operator