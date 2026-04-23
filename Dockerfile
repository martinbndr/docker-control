FROM python:3.12-slim as base

RUN apt-get update &&  \
    apt-get install --no-install-recommends -y \
    libcairo2 && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* && \


WORKDIR /opt/app

COPY requirements.txt .

RUN pip install --root-user-action=ignore --no-cache-dir --upgrade pip wheel && \
    pip install --no-cache-dir --upgrade -r requirements.txt

FROM base
WORKDIR /opt/app´


# Copy app source code
COPY . .

ENV PYTHONUNBUFFERED=1 \
    PYTHONDONTWRITEBYTECODE=1 \
    PATH=/opt/app/.venv/bin:$PATH

EXPOSE 5000

CMD ["python", "main.py"]