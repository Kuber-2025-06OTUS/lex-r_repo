# Kubernetes intro

### Описание

Выполнены следующие действия:
- добавлен манифест `namespace.yaml` для `namespace` с именем `homework`
- добавлен манифест `pod.yaml` который:
    - создается в `namespace` `homework`
    - имеет контейнер с веб-сервером на `8000` порту и отдающий содержимое директории 
    /homework внутри этого контейнера
    - имеет init-контейнер, скачивающий `index.html` с сайта `www.rancher.com` и сохраняющий
    его в директорию `/init`
    - имеет общий том (volume) для основного и init-контейнера, монтируемый в директорию 
    `/homework` первого и `/init` второго
    - удаляет файл `index.html` из директории /homework основного контейнера, перед его завершением с помощью `preStop` `lifecycle` хука
- добавлен манифест `configmap.yaml` для конфигурирования nginx

### Запуск

Применить манифесты:
```shell
kubectl apply -f '*.yaml'
```

Убедиться, что под запустился:
```shell
kubectl -n homework get po web-server
# под должен быть в статусе Running
```

Пробросить порты из пода на localhost:
```shell
kubectl -n homework port-forward pods/web-server 8000 8000
```

Зайти в браузере по адресу http://127.0.0.1:8000/ и убедиться, что выдается скачанная страница:
```shell
# можно через curl
curl http://127.0.0.1:8000
```
