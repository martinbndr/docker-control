import os

from flask import Flask, render_template, request, redirect, url_for
from dotenv import load_dotenv

load_dotenv()

app = Flask(__name__)

@app.route("/", methods=["GET"])
def index():
    return "Test"

if __name__ == "__main__":
    debug_mode = True if os.getenv("DEBUG", "true").lower() == "true" else False
    app.run(
        host=os.getenv("HOST", "localhost"),
        port=os.getenv("PORT", "5000")
        )