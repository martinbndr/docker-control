FROM python:3.12-slim as base

RUN apt-get update &&  \
    apt-get install --no-install-recommends -y \
    libcairo2 && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* && \
    useradd --shell /usr/sbin/nologin --create-home -d /opt/app app

FROM base as builder

COPY requirements.txt .

RUN pip install --root-user-action=ignore --no-cache-dir --upgrade pip wheel && \
    python -m venv /opt/app/.venv && \
    . /opt/app/.venv/bin/activate && \
    pip install --no-cache-dir --upgrade -r requirements.txt

FROM base

# Copy the entire venv.
COPY --from=builder --chown=app:app /opt/app/.venv /opt/app/.venv

# Copy repository files.
WORKDIR /opt/app
USER app:app
COPY --chown=app:app . .

# This sets some Python runtime variables and disables the internal auto-update.
ENV PYTHONUNBUFFERED=1 \
    PYTHONDONTWRITEBYTECODE=1 \
    PATH=/opt/app/.venv/bin:$PATH

CMD ["python", "main.py"]