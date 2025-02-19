#!/bin/bash
set -e

# Проверяем, установлен ли Docker
if ! command -v docker &> /dev/null; then
    echo "Устанавливаем Docker..."
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
    echo "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
    sudo apt update && sudo apt install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin
    sudo usermod -aG docker $USER
    newgrp docker
fi

# Проверяем, установлен ли git
if ! command -v git &> /dev/null; then
    echo "Устанавливаем Git..."
    sudo apt install -y git
fi

# Проверяем, существует ли netboot
if [ ! -d "/home/pxe/netboot" ]; then
    echo "Клонируем netboot.xyz..."
    git clone https://github.com/netbootxyz/netboot.xyz.git /home/pxe/netboot
else
    echo "Обновляем netboot.xyz..."
    cd /home/pxe/netboot && git pull origin main
fi

# Запускаем PXE сервер
cd /home/pxe
docker-compose up -d

echo "Установка завершена! PXE-сервер запущен."
