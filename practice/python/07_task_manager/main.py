"""
Практическая работа №7. Мини-проект «Список задач».

Полный CRUD в браузере:
    C — добавление задачи формой;
    R — список задач с фильтром (все / в работе / выполненные);
    U — переключение статуса кнопкой;
    D — удаление с подтверждением.

Дополнительно:
    * счётчики по статусам;
    * массовая очистка выполненных задач;
    * защита соединений через try/except/finally;
    * параметризованные SQL-запросы.

Запуск:
    python main.py
"""

import sqlite3
from pathlib import Path

from flask import Flask, abort, redirect, render_template, request, url_for

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
    ("Подготовить отчёт по практике", "new"),
    ("Повторить JOIN и GROUP BY", "done"),
    ("Проверить работу Flask-сервера", "new"),
]

VIEWS = ("all", "active", "done")


# ------------------------------------------------------------------ #
#  Слой доступа к данным                                             #
# ------------------------------------------------------------------ #

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
                "INSERT INTO tasks (title, status) VALUES (?, ?)", DEMO_ROWS
            )
        link.commit()
    except sqlite3.Error as err:
        link.rollback()
        print(f"[подготовка] {err}")
    finally:
        link.close()


def fetch_tasks(view: str = "all"):
    sql = "SELECT id, title, status FROM tasks"
    if view == "active":
        sql += " WHERE status = 'new'"
    elif view == "done":
        sql += " WHERE status = 'done'"
    sql += " ORDER BY id"

    link = connect_db()
    try:
        return link.execute(sql).fetchall()
    except sqlite3.Error as err:
        print(f"[выборка] {err}")
        return []
    finally:
        link.close()


def status_stats() -> dict:
    link = connect_db()
    try:
        rows = link.execute(
            "SELECT status, COUNT(*) AS amount FROM tasks GROUP BY status"
        ).fetchall()
        stats = {row["status"]: row["amount"] for row in rows}
        stats["all"] = stats.get("new", 0) + stats.get("done", 0)
        return stats
    except sqlite3.Error as err:
        print(f"[статистика] {err}")
        return {"all": 0, "new": 0, "done": 0}
    finally:
        link.close()


def create_task(name: str):
    link = connect_db()
    try:
        link.execute("INSERT INTO tasks (title) VALUES (?)", (name,))
        link.commit()
        return True, ""
    except sqlite3.Error as err:
        link.rollback()
        print(f"[вставка] {err}")
        return False, "Не удалось добавить задачу."
    finally:
        link.close()


def flip_status(task_id: int) -> int:
    """Меняет new на done и наоборот. Возвращает число строк."""
    link = connect_db()
    try:
        cur = link.execute(
            """
            UPDATE tasks
               SET status = CASE WHEN status = 'done' THEN 'new' ELSE 'done' END
             WHERE id = ?
            """,
            (task_id,),
        )
        link.commit()
        return cur.rowcount
    except sqlite3.Error as err:
        link.rollback()
        print(f"[обновление] {err}")
        return 0
    finally:
        link.close()


def remove_task(task_id: int) -> int:
    link = connect_db()
    try:
        cur = link.execute("DELETE FROM tasks WHERE id = ?", (task_id,))
        link.commit()
        return cur.rowcount
    except sqlite3.Error as err:
        link.rollback()
        print(f"[удаление] {err}")
        return 0
    finally:
        link.close()


def remove_completed() -> int:
    link = connect_db()
    try:
        cur = link.execute("DELETE FROM tasks WHERE status = 'done'")
        link.commit()
        return cur.rowcount
    except sqlite3.Error as err:
        link.rollback()
        print(f"[очистка] {err}")
        return 0
    finally:
        link.close()


# ------------------------------------------------------------------ #
#  Маршруты                                                          #
# ------------------------------------------------------------------ #

def render_board(view: str = "all", error: str = ""):
    if view not in VIEWS:
        view = "all"
    return render_template(
        "board.html",
        tasks=fetch_tasks(view),
        view=view,
        stats=status_stats(),
        error=error,
    )


@app.route("/", methods=["GET", "POST"])
def home():
    view = request.args.get("view", "all")

    if request.method == "POST":
        title = request.form.get("title", "").strip()

        if not title:
            return render_board(view, "Название задачи не может быть пустым.")
        if len(title) > 200:
            return render_board(view, "Слишком длинное название (максимум 200).")

        ok, message = create_task(title)
        if not ok:
            return render_board(view, message)

        return redirect(url_for("home", view=view))

    return render_board(view)


@app.post("/toggle/<int:task_id>")
def toggle_done(task_id):
    view = request.args.get("view", "all")
    if flip_status(task_id) == 0:
        return render_board(view, f"Задача №{task_id} не найдена.")
    return redirect(url_for("home", view=view))


@app.post("/delete/<int:task_id>")
def delete_one(task_id):
    view = request.args.get("view", "all")
    if remove_task(task_id) == 0:
        return render_board(view, f"Задача №{task_id} не найдена.")
    return redirect(url_for("home", view=view))


@app.post("/clear-completed")
def clear_completed():
    view = request.args.get("view", "all")
    amount = remove_completed()
    if amount == 0:
        return render_board(view, "Выполненных задач нет.")
    return redirect(url_for("home", view=view))


@app.route("/task/<int:task_id>")
def task_card(task_id):
    link = connect_db()
    try:
        row = link.execute(
            "SELECT id, title, status FROM tasks WHERE id = ?", (task_id,)
        ).fetchone()
    finally:
        link.close()

    if row is None:
        abort(404)
    return render_template("card.html", task=row)


prepare_storage()

if __name__ == "__main__":
    app.run(debug=True, port=5000)
