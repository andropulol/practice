"""
Практическая работа №2. CRUD-операции через консоль.

Скрипт сам создаёт базу и таблицу при первом запуске,
поэтому его можно запускать отдельно от других практик.

Возможности:
  1 — показать все задачи;
  2 — добавить задачу;
  3 — отметить задачу выполненной;
  4 — вернуть задачу в работу;
  5 — удалить задачу;
  0 — выход.

Быстрая проверка без ручного ввода:
    python console_crud.py demo
"""

import sqlite3
import sys
from pathlib import Path

DB_FILE = Path(__file__).resolve().parent / "app.db"

DDL = """
CREATE TABLE IF NOT EXISTS tasks (
    id     INTEGER PRIMARY KEY AUTOINCREMENT,
    title  TEXT    NOT NULL CHECK (length(trim(title)) > 0),
    status TEXT    NOT NULL DEFAULT 'new'
                  CHECK (status IN ('new', 'done'))
);
"""


# ------------------------------------------------------------------ #
#  Работа с базой                                                    #
# ------------------------------------------------------------------ #

def open_db() -> sqlite3.Connection:
    """Возвращает новое соединение с файлом базы."""
    return sqlite3.connect(DB_FILE)


def prepare_db() -> None:
    """Создаёт таблицу, если базы ещё нет."""
    link = open_db()
    try:
        link.execute(DDL)
        link.commit()
    finally:
        link.close()


def read_tasks():
    link = open_db()
    try:
        return link.execute(
            "SELECT id, title, status FROM tasks ORDER BY id"
        ).fetchall()
    finally:
        link.close()


def read_one(task_id: int):
    link = open_db()
    try:
        return link.execute(
            "SELECT id, title, status FROM tasks WHERE id = ?", (task_id,)
        ).fetchone()
    finally:
        link.close()


def insert_task(name: str) -> int:
    """Добавляет задачу и возвращает её id."""
    link = open_db()
    try:
        cur = link.execute("INSERT INTO tasks (title) VALUES (?)", (name,))
        new_id = cur.lastrowid
        link.commit()
        return new_id
    except sqlite3.Error:
        link.rollback()
        raise
    finally:
        link.close()


def set_status(task_id: int, state: str) -> int:
    """Меняет статус задачи. Возвращает число изменённых строк."""
    link = open_db()
    try:
        cur = link.execute(
            "UPDATE tasks SET status = ? WHERE id = ?", (state, task_id)
        )
        link.commit()
        return cur.rowcount
    except sqlite3.Error:
        link.rollback()
        raise
    finally:
        link.close()


def erase_task(task_id: int) -> int:
    link = open_db()
    try:
        cur = link.execute("DELETE FROM tasks WHERE id = ?", (task_id,))
        link.commit()
        return cur.rowcount
    except sqlite3.Error:
        link.rollback()
        raise
    finally:
        link.close()


# ------------------------------------------------------------------ #
#  Консольный интерфейс                                              #
# ------------------------------------------------------------------ #

MENU = """
========== СПИСОК ЗАДАЧ ==========
  1. Показать все задачи
  2. Добавить задачу
  3. Отметить задачу выполненной
  4. Вернуть задачу в работу
  5. Удалить задачу
  0. Выход
==================================
"""


def print_all() -> None:
    rows = read_tasks()
    if not rows:
        print("\nБаза пуста — добавьте первую задачу (пункт 2).")
        return

    print(f"\n{'ID':>3}  {'':<3} {'Название':<30} Статус")
    print("-" * 55)
    for task_id, name, state in rows:
        box = "[x]" if state == "done" else "[ ]"
        print(f"{task_id:>3}  {box:<3} {name:<30} {state}")
    print("-" * 55)
    print(f"Всего задач: {len(rows)}")


def ask_id(prompt: str):
    """Читает id, возвращает None при некорректном вводе."""
    raw = input(prompt).strip()
    if not raw.isdigit():
        print("Нужно целое положительное число.")
        return None
    return int(raw)


def cmd_add() -> None:
    name = input("Название новой задачи: ").strip()
    if not name:
        print("Название не может быть пустым.")
        return
    try:
        new_id = insert_task(name)
    except sqlite3.Error as err:
        print(f"Не удалось сохранить задачу: {err}")
        return
    print(f"Задача сохранена, её id = {new_id}.")


def cmd_complete() -> None:
    print_all()
    task_id = ask_id("\nКакую задачу отметить выполненной? id: ")
    if task_id is None:
        return
    if read_one(task_id) is None:
        print(f"Задачи с id={task_id} нет в базе.")
        return
    set_status(task_id, "done")
    print(f"Задача {task_id} отмечена выполненной.")


def cmd_reopen() -> None:
    print_all()
    task_id = ask_id("\nКакую задачу вернуть в работу? id: ")
    if task_id is None:
        return
    if read_one(task_id) is None:
        print(f"Задачи с id={task_id} нет в базе.")
        return
    set_status(task_id, "new")
    print(f"Задача {task_id} снова в статусе new.")


def cmd_delete() -> None:
    print_all()
    task_id = ask_id("\nКакую задачу удалить? id: ")
    if task_id is None:
        return
    answer = input(f"Удалить задачу {task_id} безвозвратно? (д/н): ").strip().lower()
    if answer not in ("д", "да", "y", "yes"):
        print("Удаление отменено.")
        return
    removed = erase_task(task_id)
    print(
        f"Задача {task_id} удалена."
        if removed
        else f"Задачи с id={task_id} нет в базе."
    )


def run_demo() -> None:
    """Сценарий для автоматической проверки без ручного ввода."""
    print("Демонстрационный сценарий Практической работы №2\n")
    for name in ("Проверить почту", "Сдать отчёт", "Позвонить в деканат"):
        print(f"+ добавлена задача id={insert_task(name)}: {name}")

    print("\nСодержимое таблицы после вставки:")
    print_all()

    print("\nОтмечаем выполненной задачу id=2 ...")
    set_status(2, "done")
    print_all()

    print("\nУдаляем задачу id=1 ...")
    erase_task(1)
    print_all()

    print("\nГотово: данные записаны в файл app.db.")


def interactive() -> None:
    prepare_db()
    while True:
        print(MENU)
        choice = input("Выберите пункт: ").strip()

        if choice == "1":
            print_all()
        elif choice == "2":
            cmd_add()
        elif choice == "3":
            cmd_complete()
        elif choice == "4":
            cmd_reopen()
        elif choice == "5":
            cmd_delete()
        elif choice == "0":
            print("Выход. До встречи!")
            break
        else:
            print("Такого пункта нет, попробуйте ещё раз.")


if __name__ == "__main__":
    prepare_db()
    try:
        if len(sys.argv) > 1 and sys.argv[1].lower() == "demo":
            run_demo()
        else:
            interactive()
    except (KeyboardInterrupt, EOFError):
        print("\nРабота прервана пользователем.")
