from flask import Flask, jsonify
import psycopg2
import os

app = Flask(__name__)

@app.route('/')
def home():
    return jsonify(message="Hello from Dockerized Flask App!")

@app.route('/db')
def db_check():
    try:
        conn = psycopg2.connect(
            dbname=os.getenv("POSTGRES_DB"),
            user=os.getenv("POSTGRES_USER"),
            password=os.getenv("POSTGRES_PASSWORD"),
            host="db"
        )
        cur = conn.cursor()
        cur.execute("SELECT version();")
        version = cur.fetchone()
        cur.close()
        conn.close()
        return jsonify(database_version=version)
    except Exception as e:
        return jsonify(error=str(e)), 500

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)
