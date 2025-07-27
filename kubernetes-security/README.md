# Kubernetes security

### Описание

Выполнены следующие действия:
- в namespace `homework` создан service account `monitoring` с доступами к ендпойнту `/metrics`
- в манифесте deployment поды запускаются под service account `monitoring`
- в namespace `homework` создан service account `cd`, ему выдана роль `admin`
в рамках namespace `homework`
- создан `kubeconfig` для service account `cd`
- сгенерирован для service account `cd` токен с временем действия 1 день и сохранен в файл `token`
- `*` модифицирован `deployment` из прошлых ДЗ, чтобы в процессе запуска pod происходило обраение к
эндпойнту `/metrics` кластера, и результат ответа сохраняется в файл metrics.html и содержимое этого 
файла можно получить при обращении по адресу `/metrics.html`

### Запуск

Применить все манифесты:
```
kubectl apply -f namespace.yaml -f sa-mon.yaml -f clusterrole-mon.yaml -f clusterrolebinding-mon.yaml -f configmap.yaml -f sa-cd.yaml -f role-cd.yaml -f rolebinding-cd.yaml -f secret-cd.yaml -f deployment.yaml
```

Сделать port-forward:
```
kubectl -n homework port-forward web-server-c65b4f4ff-5lwlz 8000
```

Проверить ручку `/metrics.html`:
```
curl 127.0.0.1:8000/metrics.html
```

Создать kubeconfig для `ca` service account:
```
./create-kubeconfig.sh
```

Проверить работу нового конфига:
```
kubectl --kubeconfig ./kubeconfig-for-cd get po
```
