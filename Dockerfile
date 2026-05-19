# Используем официальный образ как основу
FROM apache/airflow:2.7.1

# Переключаемся на root для установки дополнительных пакетов
USER root

# Установка системных зависимостей (если нужны для дополнительных библиотек)
RUN apt-get update && apt-get install -y --no-install-recommends \
    gcc \
    g++ \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Переключаемся обратно на пользователя airflow
USER airflow

# Установка дополнительных Python пакетов
RUN pip install --no-cache-dir \
    # Редактор кода в UI
    airflow-code-editor \
    # Форматирование кода
    black \
    # Поддержка облачных хранилищ
    fs-s3fs \
    fs-gcsfs \
    # Дополнительные провайдеры (опционально)
    apache-airflow-providers-amazon \
    apache-airflow-providers-google \
    # Утилиты для разработки
    pytest \
    ipython

# Копируем кастомные плагины (если есть)
COPY --chown=airflow:airflow ./plugins /opt/airflow/plugins

# Копируем скрипт инициализации (если нужно кастомное поведение)
COPY --chown=airflow:airflow ./scripts /opt/airflow/scripts

# Делаем скрипт исполняемым
USER root
RUN chmod +x /opt/airflow/scripts/*.sh 2>/dev/null || true
USER airflow

# Установка переменных окружения для плагинов
ENV AIRFLOW__CORE__PLUGINS_FOLDER=/opt/airflow/plugins
