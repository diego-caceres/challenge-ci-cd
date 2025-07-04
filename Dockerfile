FROM python:3.12.8-slim

#Do not use env as this would persist after the build and would impact your containers, children images
ARG DEBIAN_FRONTEND=noninteractive

# force the stdout and stderr streams to be unbuffered.
ENV PYTHONUNBUFFERED=1

RUN apt-get -y update \
    && apt-get -y upgrade \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Crear usuario sin privilegios
RUN useradd --uid 10000 -ms /bin/bash runner

# Establecer WORKDIR
WORKDIR /home/runner/app

# Copiar código fuente
COPY ./ ./

# Dar permisos a runner
RUN chown -R runner:runner /home/runner

# Instalar Poetry como root
RUN pip install --upgrade pip \
    && pip install --no-cache-dir poetry

# Cambiar a usuario sin privilegios
USER 10000
ENV PATH="${PATH}:/home/runner/.local/bin"

# Instalar dependencias del proyecto
RUN poetry config virtualenvs.create false \
    && poetry install --only main

EXPOSE 8000

ENTRYPOINT [ "poetry", "run" ]

# YOUR CODE HERE
CMD uvicorn app.main:app --host 0.0.0.0 --port $PORT
