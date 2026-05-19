#!/bin/bash

# Создание необходимых директорий
mkdir -p dags plugins logs scripts

# Установка прав (для Linux)
chmod -R 777 logs

# Запуск контейнеров
docker-compose up -d --build

# Ожидание готовности веб-сервера
echo "Waiting for webserver to be ready..."
until curl -s http://localhost:8080/health > /dev/null; do
    sleep 5
done

echo "Airflow is ready!"
echo "Webserver: http://localhost:8080 (admin/admin)"
echo "Flower: http://localhost:5555 (для мониторинга Celery)"
