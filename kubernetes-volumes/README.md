# Kubernetes volumes

### Описание

Выполнены следующие действия:
- создан манифест `pvc.yaml`, описывающий `PersistentVolumeClaim`, запрашивающий
хранилище с `storageClass` по-умолчанию
- создан манифест `configmap.yaml` для объекта типа `configMap`, описывающий
конфиг для nginx и дополнительный набор пар ключ-значение
- в манифесте `deployment.yaml` изменена спецификация volume типа `emptyDir`, 
который монтируется в init и основной контейнер, на `pvc`, созданный в 
предыдущем пункте
- в манифесте `deployment.yaml` добавлено монтирование ранее созданного configMap
как volume к основному контейнеру пода в директорию `/homework/conf`, так, чтобы 
его содержимое можно было получить, обратившись по url `/conf/key`
- `*` создан манифест storageClass.yaml, описывающий объкт типа storageClass с
provisioner `k8s.io/minikube-hostpath` и `reclaimPolicy` `Retain`
- `*` изменен манифест pvc.yaml так, чтобы в нем запрашивалось хранилище,
созданное в предыдущем пункте

### Запуск

Применить все манифесты:
```shell
kubectl apply -f namespace.yaml -f configmap.yaml -f storageClass.yaml -f pvc.yaml -f deployment.yaml -f service.yaml -f ingress.yaml
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

Для проверки:
- перейти по адресу http://homework.otus
- перейти по адресу http://homework.otus/conf/key
