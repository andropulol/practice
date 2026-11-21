"""
Контрольная работа по МДК.09.01, задание 11.
Исправленный вариант фрагмента из задания.

Исходный код:
    def add_task(title):
        conn = sqlite3.connect('app.db')
        cursor = conn.cursor()
        cursor.execute("INSERT INTO tasks (title) VALUES (?)", title)
        return True

Найдены три ошибки:
  1. В execute() передан одиночный аргумент вместо кортежа.
  2. Нет conn.commit() — запись не попадёт на диск.
  3. Нет conn.close() — соединение остаётся открытым.
  (дополнительно: нет обработки исключений и rollback)

Ниже — исправленная версия и самопроверка.
"""

import sqlite3
from pathlib import Path

DB_FILE = Path(__file__).resolve().parent / "task11.db"

DDL = """
CREATE TABLE IF NOT EXISTS tasks (
    id    INTEGER PRIMARY KEY AUTOINCREMENT,
    title TEXT NOT NULL
);
"""


def add_task(title: str) -> bool:
    """Добавляет задачу. Возвращает True при успехе."""
    link = sqlite3.connect(DB_FILE)
    try:
        link.execute(DDL)
        # Ошибка 1 исправлена: значение передаётся кортежем (title,).
        link.execute("INSERT INTO tasks (title) VALUES (?)", (title,))
        # Ошибка 2 исправлена: фиксируем транзакцию.
        link.commit()
        return True
    except sqlite3.Error as err:
        link.rollback()
        print(f"Не удалось добавить задачу: {err}")
        return False
    finally:
        # Ошибка 3 исправлена: соединение закрывается всегда.
        link.close()


if __name__ == "__main__":
    DB_FILE.unlink(missing_ok=True)

    print("add_task('Проверка') ->", add_task("Проверка"))
    print("add_task('Ещё одна') ->", add_task("Ещё одна"))

    link = sqlite3.connect(DB_FILE)
    try:
        rows = link.execute("SELECT id, title FROM tasks ORDER BY id").fetchall()
    finally:
        link.close()

    print("Содержимое таблицы:", rows)
    print("Строк в базе:", len(rows))
