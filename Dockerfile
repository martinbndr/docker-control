FROM python:3.12-slim as base

ENV DEBUG=$(DEBUG)

RUN apt-get update &&  \
    apt-get install --no-install-recommends -y && \
    git && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

RUN mkdir -p /home/app
COPY . /home/app

WORKDIR /home/app

RUN python -m pip install --root-user-action=ignore --no-cache-dir --upgrade pip wheel
RUN pip install -r requirements.txt --root-user-action=ignore --no-cache-dir

EXPOSE 5000

CMD ["python", "main.py"]