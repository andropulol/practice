"""
Контрольная работа по МДК.09.01, задание 12.
Функция delete_task_by_id(task_id) с гарантированным закрытием соединения.

Требования задания:
  1. открыть соединение с app.db;
  2. выполнить DELETE параметризованным запросом;
  3. зафиксировать изменения (commit);
  4. закрыть соединение в любом случае (finally);
  5. при ошибке сделать rollback и вернуть 0;
  6. вернуть число удалённых строк.
"""

import sqlite3
from pathlib import Path

DB_FILE = Path(__file__).resolve().parent / "app.db"


def delete_task_by_id(task_id: int) -> int:
    """Удаляет задачу по id. Возвращает количество удалённых строк."""
    link = sqlite3.connect(DB_FILE)
    try:
        cursor = link.execute("DELETE FROM tasks WHERE id = ?", (task_id,))
        link.commit()
        return cursor.rowcount
    except sqlite3.Error as err:
        link.rollback()
        print(f"[delete_task_by_id] ошибка: {err}")
        return 0
    finally:
        link.close()


def _demo() -> None:
    """Самопроверка на временной таблице."""
    DB_FILE.unlink(missing_ok=True)

    setup = sqlite3.connect(DB_FILE)
    try:
        setup.execute(
            """
            CREATE TABLE tasks (
                id    INTEGER PRIMARY KEY AUTOINCREMENT,
                title TEXT NOT NULL
            )
            """
        )
        setup.executemany(
            "INSERT INTO tasks (title) VALUES (?)",
            [("Первая",), ("Вторая",), ("Третья",)],
        )
        setup.commit()
    finally:
        setup.close()

    print("Удаление id=2 ->", delete_task_by_id(2), "(ожидается 1)")
    print("Повторное удаление id=2 ->", delete_task_by_id(2), "(ожидается 0)")
    print("Удаление id=999 ->", delete_task_by_id(999), "(ожидается 0)")

    check = sqlite3.connect(DB_FILE)
    try:
        left = check.execute("SELECT id, title FROM tasks ORDER BY id").fetchall()
    finally:
        check.close()
    print("Осталось в базе:", left)

    # Проверка, что соединение не осталось открытым: файл можно удалить.
    DB_FILE.unlink()
    print("Файл базы удалён без ошибки — блокировки нет.")


if __name__ == "__main__":
    _demo()
