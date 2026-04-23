FROM python:3.12-slim as base

RUN apt-get update &&  \
    apt-get install --no-install-recommends -y \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* && \
    useradd --shell /usr/sbin/nologin --create-home -d /opt/app app

ARG DOCKER_GID
RUN groupadd -g ${DOCKER_GID} docker || true && \
    usermod -aG docker app

FROM base as builder
WORKDIR /opt/app

COPY requirements.txt .

RUN pip install --root-user-action=ignore --no-cache-dir --upgrade pip wheel && \
    python -m venv /opt/app/.venv && \
    . /opt/app/.venv/bin/activate && \
    pip install --no-cache-dir --upgrade -r requirements.txt

FROM base
WORKDIR /opt/app

# Copy venv
COPY --from=builder --chown=app:app /opt/app/.venv /opt/app/.venv

# Copy app source code
COPY --chown=app:app . .

USER app:app

ENV PYTHONUNBUFFERED=1 \
    PYTHONDONTWRITEBYTECODE=1 \
    PATH=/opt/app/.venv/bin:$PATH

EXPOSE 5000

CMD ["python", "main.py"]