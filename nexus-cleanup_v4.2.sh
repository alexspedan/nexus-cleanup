#!/bin/bash

registrys=(
$REGISTRY
)
cat /dev/null > .credentials
cat /dev/null > tags
cat /dev/null > sorted.tags
for registry in $registrys  #for registry in $registrys  #Из списка репозиториев добавляем переменные в файл для авторизации на сервере
do
    echo "nexus_host = $NEXUS_HOST
    nexus_username = $USERNAME
    nexus_password = $USER_PASSWORD
    nexus_repository = 'docker-template'" > .credentials
    images=$(nexus-cli image ls | awk '!/Total/')
    for image in $images
    do
        nexus-cli image tags -name "$image" | awk '!/There/' > tags
        sort -Vr tags | sed '1,2d' > sorted.tags 
        for t in $(cat sorted.tags) 
        do
            nexus-cli image info -name "$image" -tag "$t"
            nexus-cli image delete -name "$image" -tag "$t"
        done
    done
done
