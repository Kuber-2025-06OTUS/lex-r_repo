# Kubernetes monitoring

### Описание

Выполнены следующие действия:
- установлен в кластер `prometheus-operator` через helm-chart
- создан deployment, запускающий под с двумя контейнерами:
  - nginx с ендпойнтом, отдающим метрики
  - nginx prometheus exporter, собирающий метрики с nginx
- создан service
- создан манифест service-monitor, описывающий сбор метрик с пода nginx

### Запуск

Установить prometheus stack:
```shell
./install-prometheus-stack.sh
```

Применить манифесты:
```shell
kubectl apply -f configmap.yaml -f deployment.yaml -f service.yaml
```

Применить манифест service-monitor в неймспейсе monitoring:
```shell
kubectl -n monitoring apply -f service-monitor.yaml
```

Для проверки корректности настройки, нужно убедиться, что метрики собираются. 
Для начала выполнить форвардинг порта:
```shell
kubectl -n monitoring port-forward pods/prometheus-prometheus-kube-prometheus-prometheus-0 9090
```
В браузере зайти на http://127.0.0.1:9090/targets и посмотреть, что в таргетах есть наш под с метриками.
После этого можно зайти на http://127.0.0.1:9090/query и посмотреть наличие метрики `nginx_up`. 
