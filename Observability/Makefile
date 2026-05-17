.PHONY: up down status password-creation start stop

up:
	helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
	helm repo update

	kubectl create namespace monitoring --dry-run=client -o yaml | kubectl apply -f -

	helm upgrade --install monitoring prometheus-community/kube-prometheus-stack \
		--namespace monitoring

	kubectl wait --for=condition=Ready pods --all -n monitoring --timeout=300s

	$(MAKE) status

	@echo
	@echo "Grafana + Prometheus installed successfully"
	@echo

	@echo "Grafana Password:"
	$(MAKE) password-creation

	@echo
	@echo "Username: admin"
	@echo "Grafana URL: http://localhost:3000"
	@echo "Grafana is now starting in background"
	@echo

	$(MAKE) start


down:
	helm uninstall monitoring -n monitoring || true
	kubectl delete namespace monitoring --ignore-not-found


status:
	kubectl get pods -n monitoring


password-creation:
	@kubectl get secret monitoring-grafana -n monitoring -o jsonpath="{.data.admin-password}" | base64 --decode && echo


start:
	@nohup kubectl port-forward svc/monitoring-grafana 3000:80 -n monitoring > grafana.log 2>&1 &


stop:
	@pkill -f "kubectl port-forward svc/monitoring-grafana"