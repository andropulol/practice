"""
Практическая работа №3. Первый маршрут Flask (Hello World).

Запуск:
    python main.py
Затем открыть в браузере http://127.0.0.1:5000
"""

from flask import Flask, jsonify

app = Flask(__name__)

PAGE = """<!DOCTYPE html>
<html lang="ru">
<head>
<meta charset="utf-8">
<title>Практика №3 — Flask</title>
<style>
  body { font-family: Verdana, sans-serif; max-width: 640px;
         margin: 60px auto; padding: 0 20px; color: #1f2933; }
  h1 { color: #0b6e4f; }
  a { color: #0b6e4f; }
  code { background: #eef2f3; padding: 2px 6px; border-radius: 4px; }
</style>
</head>
<body>
  <h1>Flask запущен и отвечает</h1>
  <p>Это главная страница учебного проекта.
     Сервер работает в режиме <code>debug=True</code>.</p>
  <p><a href="/about">О проекте</a> &middot;
     <a href="/status">Проверка состояния</a></p>
</body>
</html>"""


@app.route("/")
def home():
    return PAGE


@app.route("/about")
def about():
    return "Учебный проект по курсу «Клиент-серверные приложения», практика №3."


@app.route("/status")
def status():
    return jsonify({"app": "practice-03", "ok": True, "port": 5000})


if __name__ == "__main__":
    app.run(debug=True, port=5000)
