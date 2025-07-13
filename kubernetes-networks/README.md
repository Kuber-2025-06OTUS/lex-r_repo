# Kubernetes networks

### Описание

Выполнены следующие действия:
- изменена `readiness-проба` в манифесте `deployment.yaml` из 
[прошлого ДЗ](/kubernetes-controllers/deployment.yaml) на `httpGet`,
вызывающая URL `/index.html`
- добавлен манифест `service.yaml`, описывающий сервис типа `ClusterIP`, который направляет трафик на поды,
управляемые `deployment`
- установлен `ingress-контроллер` `nginx` в кластер (`minikube addons enable ingress`)
- добавлен манифест `ingress.yaml`, в котором описан объект типа `ingress`, направляющий
все http запросы к хосту `homework.otus` на созданный сервис
- `*` в манифест `ingress.yaml` добавлены rewrite-правила для форвардинга запросов с `/homepage` на `/`

### Запуск

Применить все манифесты:
```shell
kubectl apply -f namespace.yaml -f configmap.yaml -f deployment.yaml -f service.yaml -f ingress.yaml
```
Для запуска на `minikube` нужно установить ingress-контроллер:
```shell
minikube addons enable ingress
```
и запустить тоннель:
```shell
minikube tunnel --bind-address=127.0.0.1
```
Добавить хост `homework.otus` в `/etc/hosts`.

Для проверки перейти по адресу http://homework.otus. Чтобы проверить
форвардинг, перейти на http://homework.otus/homepage
