"""
Практическая работа №4. Чтение данных из SQLite в шаблон Jinja2.

Проект автономный: при первом запуске создаётся app.db,
таблица tasks и три демонстрационные записи.

Запуск:
    python main.py
Страница:
    http://127.0.0.1:5000
"""

import sqlite3
from pathlib import Path

from flask import Flask, render_template

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

DEMO_ROWS = [
    ("Сверить показания счётчиков", "done"),
    ("Записаться на консультацию", "new"),
    ("Проверить домашнее задание", "new"),
]


def connect_db() -> sqlite3.Connection:
    """Соединение с доступом к колонкам по имени."""
    link = sqlite3.connect(DB_FILE)
    link.row_factory = sqlite3.Row
    return link


def prepare_storage() -> None:
    """Создаёт таблицу и наполняет её примерами при первом запуске."""
    link = connect_db()
    try:
        link.execute(DDL)
        amount = link.execute("SELECT COUNT(*) AS c FROM tasks").fetchone()["c"]
        if amount == 0:
            link.executemany(
                "INSERT INTO tasks (title, status) VALUES (?, ?)", DEMO_ROWS
            )
        link.commit()
    finally:
        link.close()


def select_tasks():
    link = connect_db()
    try:
        return link.execute(
            "SELECT id, title, status FROM tasks ORDER BY id"
        ).fetchall()
    finally:
        link.close()


@app.route("/")
def home():
    return render_template("tasks.html", tasks=select_tasks())


# База готова ещё до первого запроса — удобно и при запуске через flask run.
prepare_storage()

if __name__ == "__main__":
    app.run(debug=True, port=5000)
