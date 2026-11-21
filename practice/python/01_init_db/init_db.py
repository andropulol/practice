"""
Практическая работа №1. Инициализация базы данных SQLite.

Скрипт создаёт рядом с собой файл app.db и таблицу tasks.
Повторный запуск безопасен: используется IF NOT EXISTS,
поэтому скрипт идемпотентен.
"""

import sqlite3
from pathlib import Path

DB_FILE = Path(__file__).resolve().parent / "app.db"

# Структура таблицы описана отдельной константой,
# чтобы её можно было переиспользовать в других скриптах.
DDL = """
CREATE TABLE IF NOT EXISTS tasks (
    id     INTEGER PRIMARY KEY AUTOINCREMENT,
    title  TEXT    NOT NULL CHECK (length(trim(title)) > 0),
    status TEXT    NOT NULL DEFAULT 'new'
                  CHECK (status IN ('new', 'done'))
);
"""


def create_schema(db_file: Path = DB_FILE) -> None:
    """Открывает базу и создаёт таблицу, если её ещё нет."""
    link = sqlite3.connect(db_file)
    try:
        link.execute(DDL)
        link.commit()
    finally:
        link.close()


def main() -> None:
    create_schema()
    print("База данных успешно подготовлена.")
    print(f"Файл базы: {DB_FILE}")
    print("Таблица: tasks (id, title, status)")


if __name__ == "__main__":
    main()
