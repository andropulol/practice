"""
Практическая работа №5. Добавление задачи через веб-форму.

Реализован полный цикл:
    форма -> POST -> проверка -> INSERT + commit -> redirect -> GET

Проект автономный, база создаётся при старте.

Запуск:
    python main.py
"""

import sqlite3
from pathlib import Path

from flask import Flask, redirect, render_template, request, url_for

BASE_DIR = Path(__file__).resolve().parent
DB_FILE = BASE_DIR / "app.db"

app = Flask(__name__)

DDL = """
CREATE TABLE IF NOT EXISTS tasks (
    id     INTEGER PRIMARY KEY AUTOINCREMENT,
    title  TEXT    NOT NULL CHECK (length(trim(title)) > 0),
    status TEXT    NOT NULL DEFAULT 'new'
                  CHECK (status IN ('new', 'done'))
);
"""

STARTER = [
    ("Прочитать главу 5", "new"),
    ("Сделать зарядку", "done"),
]


def connect_db() -> sqlite3.Connection:
    link = sqlite3.connect(DB_FILE)
    link.row_factory = sqlite3.Row
    return link


def prepare_storage() -> None:
    link = connect_db()
    try:
        link.execute(DDL)
        if link.execute("SELECT COUNT(*) AS c FROM tasks").fetchone()["c"] == 0:
            link.executemany(
                "INSERT INTO tasks (title, status) VALUES (?, ?)", STARTER
            )
        link.commit()
    finally:
        link.close()


def load_tasks():
    link = connect_db()
    try:
        return link.execute(
            "SELECT id, title, status FROM tasks ORDER BY id"
        ).fetchall()
    finally:
        link.close()


def store_task(name: str) -> None:
    link = connect_db()
    try:
        link.execute("INSERT INTO tasks (title) VALUES (?)", (name,))
        link.commit()
    finally:
        link.close()


@app.route("/", methods=["GET", "POST"])
def home():
    if request.method == "POST":
        # get() безопаснее прямого обращения по ключу: не будет KeyError.
        name = request.form.get("title", "").strip()
        if not name:
            return render_template(
                "tasks.html",
                tasks=load_tasks(),
                error="Поле не должно быть пустым.",
            )
        if len(name) > 200:
            return render_template(
                "tasks.html",
                tasks=load_tasks(),
                error="Название длиннее 200 символов.",
            )

        store_task(name)
        # Post/Redirect/Get: обновление страницы не создаст дубликат.
        return redirect(url_for("home"))

    return render_template("tasks.html", tasks=load_tasks())


prepare_storage()

if __name__ == "__main__":
    app.run(debug=True, port=5000)
