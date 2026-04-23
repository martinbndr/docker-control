import os

from flask import Flask, render_template, request, redirect, url_for
from dotenv import load_dotenv
import docker

load_dotenv()

app = Flask(__name__)

@app.route("/", methods=["GET"])
def index():
    return "Test"

@app.route("/list", methods=["GET"])
def list():
    client = docker.from_env(version="auto")
    containers = client.containers.list()
    return [c.name for c in containers]
    

if __name__ == "__main__":
    debug_mode = True if os.getenv("DEBUG", "true").lower() == "true" else False
    app.run(
        host=os.getenv("HOST", "0.0.0.0"),
        port=os.getenv("PORT", "5000")
        )