ns:
	kubectl apply -f ns.yml

crd:
	kubectl apply -f https://raw.githubusercontent.com/prometheus-operator/prometheus-operator/release-0.38/example/prometheus-operator-crd/monitoring.coreos.com_alertmanagers.yaml
	kubectl apply -f https://raw.githubusercontent.com/prometheus-operator/prometheus-operator/release-0.38/example/prometheus-operator-crd/monitoring.coreos.com_podmonitors.yaml
	kubectl apply -f https://raw.githubusercontent.com/prometheus-operator/prometheus-operator/release-0.38/example/prometheus-operator-crd/monitoring.coreos.com_prometheuses.yaml
	kubectl apply -f https://raw.githubusercontent.com/prometheus-operator/prometheus-operator/release-0.38/example/prometheus-operator-crd/monitoring.coreos.com_prometheusrules.yaml
	kubectl apply -f https://raw.githubusercontent.com/prometheus-operator/prometheus-operator/release-0.38/example/prometheus-operator-crd/monitoring.coreos.com_servicemonitors.yaml
	kubectl apply -f https://raw.githubusercontent.com/prometheus-operator/prometheus-operator/release-0.38/example/prometheus-operator-crd/monitoring.coreos.com_thanosrulers.yaml

prom-patch:
	kubectl patch -n prometheus-stack prometheus   prometheus-stack-prometheus --type merge -p '{"spec":{"serviceMonitorNamespaceSelector": null}}'
	kubectl patch -n prometheus-stack prometheus   prometheus-stack-prometheus --type merge -p '{"spec":{"serviceMonitorSelector": null}}'
	kubectl patch -n prometheus-stack prometheus   prometheus-stack-prometheus --type merge -p '{"spec":{"ruleNamespaceSelector": null}}'
	kubectl patch -n prometheus-stack prometheus   prometheus-stack-prometheus --type merge -p '{"spec":{"ruleSelector": null}}'

	kubectl patch -n prometheus-stack prometheus   prometheus-stack-prometheus --type merge -p '{"spec":{"serviceMonitorNamespaceSelector": {}}}'
	kubectl patch -n prometheus-stack prometheus   prometheus-stack-prometheus --type merge -p '{"spec":{"serviceMonitorSelector": {}}}'
	kubectl patch -n prometheus-stack prometheus   prometheus-stack-prometheus --type merge -p '{"spec":{"ruleNamespaceSelector": {}}}'
	kubectl patch -n prometheus-stack prometheus   prometheus-stack-prometheus --type merge -p '{"spec":{"ruleSelector": {}}}'

prom:
	helm upgrade --install -n prometheus-stack prometheus-stack prometheus-community/kube-prometheus-stack -f values.yml

prom-uninstall:
	helm uninstall -n prometheus-stack prometheus-stack

reload:
	curl -X POST https://prometheus.k8s.sikademo.com/-/reload
