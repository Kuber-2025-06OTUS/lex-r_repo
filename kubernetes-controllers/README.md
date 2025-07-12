# Kubernetes controllers

### Описание

Выполнены следующие действия:
- добавлен манифест `namespace.yaml` для `namespace` с именем `homework`
- добавлен манифест `deployment.yaml`, который:
    - создается в `namespace` `homework`
    - запускает 3 экземпляра пода, аналогичных по спецификации из
    задания [kubernetes-intro](/kubernetes-intro/pod.yaml)
    - в дополнение к этому поды имеют `readiness пробу`, проверяющую 
    наличие файла `/homework/index.html`
    - имеет стратегию обновления `RollingUpdate`, настроенная так, что в 
    процессе обновления может быть недоступен максимум 1 под
    - `*` добавлен `nodeSelector`, обеспечивающий запуск подов только на
    ноде, имеющей лейбл `homework=true`

### Запуск

Применить манифесты:
```shell
kubectl apply -f namespace.yaml -f configmap.yaml -f deployment.yaml
```

Поды будут находится в статусе `Pending`, т.к. в кластере нет нод с лейблом `homework=true`.
Нужно добавить лейбл на любую ноду:
```shell
kubectl label node kind-worker homework=true
```

После этого поды назначатся на эту ноду и запустятся на ней, можно убедиться:
```shell
kubectl -n homework get po
```

Для проверки раскатки деплоя, можно поменять версию контейнера в описании
пода и посмотреть как это будет раскатываться:
```shell
kubectl -n homework set image deployments web-server nginx-container=nginx:1.28
kubectl -n homework get po -w
```

Для проверки работы `readiness пробы` можно удалить файл `/homework/index.html` в каком-нибудь
поде и увидеть, что проба провалится:
```shell
kubectl -n homework exec web-server-7b77d94ddf-f6tf8 -c nginx-container -- bash -c "rm /homework/index.html"
```
