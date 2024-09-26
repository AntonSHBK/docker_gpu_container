# Используем базовый образ OpenVINO для Ubuntu 22.04
FROM openvino/ubuntu22_runtime:latest

# Переключаемся на root пользователя
USER root

# Устанавливаем необходимые пакеты для поддержки Intel GPU и OpenCL
RUN apt-get update && apt-get install -y \
    mesa-utils \
    intel-opencl-icd \
    clinfo \
    libva-dev \
    vainfo \
    libdrm2 \
    libgl1-mesa-dri \
    libxext6 \
    libxrender1 \
    libxtst6 \
    libvulkan1 \
    vulkan-tools \
    i965-va-driver \
    intel-media-va-driver-non-free \
    && rm -rf /var/lib/apt/lists/*

# Обновляем список пакетов и устанавливаем необходимые зависимости
RUN apt-get update && apt-get install -y \
    wget \
    gnupg2 \
    lsb-release \
    software-properties-common \
    && rm -rf /var/lib/apt/lists/*

# Добавляем репозиторий Intel и устанавливаем необходимые драйверы OpenCL
RUN wget -qO - https://repositories.intel.com/graphics/intel-graphics.key | apt-key add - \
    && add-apt-repository "deb [arch=amd64] https://repositories.intel.com/graphics/ubuntu $(lsb_release -cs) non-free" \
    && apt-get update \
    && apt-get install -y intel-opencl-icd intel-media-va-driver-non-free libmfx1 \
    && rm -rf /var/lib/apt/lists/*

# Устанавливаем переменные окружения для поддержки X11 и GPU
ENV DISPLAY=${DISPLAY}
ENV XAUTHORITY=${XAUTHORITY}
ENV LIBVA_DRIVER_NAME=i965
ENV LIBVA_DRIVERS_PATH=/usr/lib/x86_64-linux-gnu/dri

# Устанавливаем рабочую директорию
WORKDIR /app

ENV XDG_RUNTIME_DIR=/tmp/runtime-root
RUN mkdir -p /tmp/runtime-root && chmod 700 /tmp/runtime-root

# Запуск OpenVINO демо-приложения
# CMD ["/bin/bash", "-c", "source /opt/intel/openvino/setupvars.sh && clinfo && /opt/intel/openvino/install_dependencies/install_openvino_dependencies.sh"]
