"""
Проверка результата Практической работы №1.

Скрипт читает системную таблицу sqlite_master и выводит
список таблиц и описание колонок. Ничего не изменяет.
"""

import sqlite3
from pathlib import Path

DB_FILE = Path(__file__).resolve().parent / "app.db"


def describe(db_file: Path = DB_FILE) -> None:
    if not db_file.exists():
        print("Файл app.db не найден. Сначала запустите init_db.py")
        return

    link = sqlite3.connect(db_file)
    link.row_factory = sqlite3.Row
    try:
        names = link.execute(
            """
            SELECT name
            FROM sqlite_master
            WHERE type = 'table' AND name NOT LIKE 'sqlite_%'
            ORDER BY name
            """
        ).fetchall()

        print(f"Файл: {db_file}")
        print(f"Найдено таблиц: {len(names)}")
        for row in names:
            table = row["name"]
            print(f"\nТаблица: {table}")
            print(f"{'колонка':<10}{'тип':<10}{'NOT NULL':<10}{'по умолчанию'}")
            print("-" * 45)
            for col in link.execute(f"PRAGMA table_info({table})"):
                print(
                    f"{col['name']:<10}"
                    f"{col['type']:<10}"
                    f"{('да' if col['notnull'] else 'нет'):<10}"
                    f"{col['dflt_value'] if col['dflt_value'] is not None else '-'}"
                )
    finally:
        link.close()


if __name__ == "__main__":
    describe()
