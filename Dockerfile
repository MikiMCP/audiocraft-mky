# docker compose up -d
FROM nvidia/cuda:12.1.0-base-ubuntu22.04

# Para evitar interacciones durante la instalación
ENV DEBIAN_FRONTEND=noninteractive

# Instalar dependencias de sistema
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        build-essential \
        subversion \
        libsndfile1-dev \
        python3 \
        python3-pip \
        python3-venv \
        ffmpeg \
        libsndfile1 \
        git \
        python3-dev \
        libasound2-dev \
        cmake \
    && rm -rf /var/lib/apt/lists/*

# Alias de python3 a python
RUN update-alternatives --install /usr/bin/python python /usr/bin/python3 1

# Actualizar pip
RUN python -m pip install --no-cache-dir --upgrade pip

# Clonar Audiocraft si se quiere la última versión:
# RUN git clone https://github.com/facebookresearch/audiocraft.git /app
# RUN pip install torch==2.1.0 gradio==4.44.1

# En este caso, utilizamos la clonación del mismo repositorio (evitando las actualizaciones del repositorio principal):
COPY . ./app

WORKDIR /app

# Instalar Audiocraft
RUN pip install setuptools wheel
RUN pip install --no-cache-dir -e .

# Generación de música:
CMD ["python", "-m", "demos.musicgen_app", "--share", "--listen", "0.0.0.0", "--server_port", "7860"]

# Generación de aurio, p.e.: un perro ladrando:
# CMD ["python", "-m", "demos.magnet_app", "--share", "--listen", "0.0.0.0", "--server_port", "7860"]