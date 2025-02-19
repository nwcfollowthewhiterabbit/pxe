#!/bin/bash
set -e

echo "Запуск PXE-сервера..."

# Проверяем, работает ли Docker
if ! systemctl is-active --quiet docker; then
    echo "Docker не запущен, стартуем..."
    sudo systemctl start docker
fi

# Запускаем контейнеры
cd /home/pxe
docker-compose up -d

echo "PXE-сервер работает!"
