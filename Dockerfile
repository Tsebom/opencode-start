
# Используем минимальный образ Node.js на базе Debian.
FROM node:22-bookworm-slim

# Устанавливаем необходимые системные утилиты,
# OpenCode и непривилегированного пользователя.
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
       git \
       ca-certificates \
       bash \
       tini \
    && npm install -g @opencode/cli \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* \
    && useradd --create-home --uid 10001 --shell /bin/bash agent

# Указываем домашний каталог пользователя внутри контейнера.
ENV HOME=/home/agent

# Настройки приложений XDG будут храниться внутри контейнера.
ENV XDG_CONFIG_HOME=/home/agent/.config
ENV XDG_DATA_HOME=/home/agent/.local/share
ENV XDG_CACHE_HOME=/home/agent/.cache

# Рабочий каталог проекта внутри контейнера.
WORKDIR /workspace

# Запускаем OpenCode не от root.
USER 10001:10001

# tini корректно обрабатывает сигналы и завершение процессов.
ENTRYPOINT ["tini", "--"]

# Команда по умолчанию при запуске контейнера.
CMD ["opencode"]
