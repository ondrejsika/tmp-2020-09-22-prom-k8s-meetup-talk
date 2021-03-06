helm:
	helm repo add ondrejsika https://helm.oxs.cz
	helm repo add hashicorp https://helm.releases.hashicorp.com
	helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
	helm repo add stable https://kubernetes-charts.storage.googleapis.com/
	helm repo update

longhorn:
	kubectl delete sc --all
	kubectl apply -f https://raw.githubusercontent.com/longhorn/longhorn/master/deploy/longhorn.yaml
	kubectl patch storageclass longhorn -p '{"metadata": {"annotations":{"storageclass.kubernetes.io/is-default-class":"true"}}}'

consul:
	kubectl apply -f k8s/ns-consul.yml
	helm upgrade --install \
		consul hashicorp/consul \
		-n consul \
		-f values/consul/general.yml

ingress:
	kubectl apply -f https://raw.githubusercontent.com/ondrejsika/kubernetes-ingress-traefik/master/ingress-traefik-consul.yml

maildev:
	kubectl apply -f k8s/ns-maildev.yml
	helm upgrade --install -n maildev maildev ondrejsika/maildev --set host=mail.k8s.sikademo.com

crd:
	kubectl apply -f https://raw.githubusercontent.com/prometheus-operator/prometheus-operator/release-0.38/example/prometheus-operator-crd/monitoring.coreos.com_alertmanagers.yaml
	kubectl apply -f https://raw.githubusercontent.com/prometheus-operator/prometheus-operator/release-0.38/example/prometheus-operator-crd/monitoring.coreos.com_podmonitors.yaml
	kubectl apply -f https://raw.githubusercontent.com/prometheus-operator/prometheus-operator/release-0.38/example/prometheus-operator-crd/monitoring.coreos.com_prometheuses.yaml
	kubectl apply -f https://raw.githubusercontent.com/prometheus-operator/prometheus-operator/release-0.38/example/prometheus-operator-crd/monitoring.coreos.com_prometheusrules.yaml
	kubectl apply -f https://raw.githubusercontent.com/prometheus-operator/prometheus-operator/release-0.38/example/prometheus-operator-crd/monitoring.coreos.com_servicemonitors.yaml
	kubectl apply -f https://raw.githubusercontent.com/prometheus-operator/prometheus-operator/release-0.38/example/prometheus-operator-crd/monitoring.coreos.com_thanosrulers.yaml

copy-example-values:
	cp values/prom/ingress.example.yml values/prom/ingress.yml
	cp values/prom/alertmanager-config.example.yml values/prom/alertmanager-config.yml

prom:
	kubectl apply -f k8s/ns-prom.yml
	helm upgrade --install \
		prometheus-stack prometheus-community/kube-prometheus-stack \
		-n prometheus-stack \
		-f values/prom/general.yml \
		-f values/prom/ingress.yml \
		-f values/prom/alertmanager-config.yml

prom-uninstall:
	helm uninstall -n prometheus-stack prometheus-stack

reload:
	curl -X POST https://prometheus.k8s.sikademo.com/-/reload
	curl -X POST https://alertmanager.k8s.sikademo.com/-/reload
