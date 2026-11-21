"""
Практическая работа №6. Обработка ошибок и защита соединений.

Все операции с базой построены по схеме:
    соединение -> try -> commit -> except -> rollback -> finally -> close

Дополнительно добавлен маршрут /simulate-error, который специально
нарушает ограничение NOT NULL. Это позволяет увидеть обработку ошибки
в браузере, не правя код вручную.

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
    ("Проверить журнал", "new"),
    ("Сделать резервную копию", "done"),
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
    except sqlite3.Error as err:
        link.rollback()
        print(f"[подготовка базы] {err}")
    finally:
        link.close()


def load_tasks():
    """Возвращает список задач или пустой список при сбое."""
    link = connect_db()
    try:
        return link.execute(
            "SELECT id, title, status FROM tasks ORDER BY id"
        ).fetchall()
    except sqlite3.Error as err:
        print(f"[чтение] {err}")
        return []
    finally:
        link.close()


def save_task(name):
    """Пытается сохранить задачу. Возвращает (успех, текст ошибки)."""
    link = connect_db()
    try:
        link.execute("INSERT INTO tasks (title) VALUES (?)", (name,))
        link.commit()
        return True, ""
    except sqlite3.Error as err:
        link.rollback()
        print(f"[запись] {err}")
        return False, "Сохранить задачу не удалось, изменения отменены."
    finally:
        link.close()


def save_broken_row() -> str:
    """Намеренно вставляет NULL в NOT NULL-колонку и возвращает текст ошибки."""
    link = connect_db()
    try:
        link.execute("INSERT INTO tasks (title) VALUES (?)", (None,))
        link.commit()
        return "Ошибки не произошло (так быть не должно)."
    except sqlite3.Error as err:
        link.rollback()
        return f"Перехвачено исключение: {err}"
    finally:
        link.close()


@app.route("/", methods=["GET", "POST"])
def home():
    if request.method == "POST":
        name = request.form.get("title", "").strip()
        if not name:
            return render_template(
                "tasks.html",
                tasks=load_tasks(),
                error="Название задачи не может быть пустым.",
            )

        ok, message = save_task(name)
        if not ok:
            return render_template("tasks.html", tasks=load_tasks(), error=message)
        return redirect(url_for("home"))

    return render_template("tasks.html", tasks=load_tasks())


@app.post("/simulate-error")
def simulate_error():
    detail = save_broken_row()
    return render_template(
        "tasks.html",
        tasks=load_tasks(),
        error=f"Проверка обработки ошибок: {detail}",
        note="Соединение закрыто в finally, таблица не повреждена.",
    )


prepare_storage()

if __name__ == "__main__":
    app.run(debug=True, port=5000)
