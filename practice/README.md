# Практические работы — Кривцов Андрей Сергеевич, 3ИСП9-54

Собрание выполненных практических, проверочных и контрольных работ
по Python/Flask, SQLite, Bash и Linux. Каждый проект автономен: сам создаёт
базу данных и демонстрационные записи, поэтому запускается «из коробки».

## Структура

```
practice_VV/
├── python/                  # практики 1–7
│   ├── 01_init_db/          # создание БД и таблицы
│   ├── 02_console_crud/     # консольный CRUD
│   ├── 03_flask_hello/      # первый Flask-сервер
│   ├── 04_flask_read/       # чтение данных в Flask
│   ├── 05_flask_create/     # форма добавления задачи
│   ├── 06_flask_errors/     # обработка ошибок и rollback
│   └── 07_task_manager/     # итоговый мини-проект
├── bash/
│   ├── 01_syntax_basics/    # синтаксис Bash
│   ├── 02_math_basics/      # арифметика
│   ├── 03_system_scripts/   # системные скрипты
│   ├── 04_linux_fundamentals/ # лабораторная по Linux
│   └── 05_control_work/     # проверочная работа по Bash
├── control_work/            # контрольная по МДК.09.01
└── reports/                 # отчёты по каждой работе
```

## Требования

- Python 3.10 или новее (проверено на 3.11.9);
- Flask 3.x (проверено на 3.1.3):

```bash
python -m pip install -r requirements.txt
```

- Для Bash-скриптов — Linux, WSL или Git Bash с `bash`, `awk`, `find`.

## Python-практики

Все команды выполняются из корня `practice_VV`.

### 01. Создание базы данных

```bash
cd python/01_init_db
python init_db.py
python inspect_db.py
```

Создаёт `tasks.db`, таблицу `tasks` и выводит её содержимое.

### 02. Консольный CRUD

```bash
cd python/02_console_crud
python console_crud.py          # интерактивное меню
python console_crud.py demo     # автоматическая демонстрация
```

### 03–07. Flask-приложения

```bash
cd python/03_flask_hello
python main.py
```

Приложение слушает `http://127.0.0.1:5000`. Для остальных проектов команда
та же:

| Проект | Что показывает |
|---|---|
| `03_flask_hello` | приветственная страница, шаблоны и статика |
| `04_flask_read` | список задач из SQLite |
| `05_flask_create` | форму добавления и сохранение в базу |
| `06_flask_errors` | валидацию, `NOT NULL`, `rollback`, страницы ошибок |
| `07_task_manager` | полный CRUD: фильтры, карточка, переключение статуса, удаление |

Полезные адреса `07_task_manager`:

- `/` — список задач;
- `/?view=active` и `/?view=done` — фильтры;
- `/task/<id>` — карточка задачи;
- `POST /toggle/<id>` — смена статуса;
- `POST /delete/<id>` — удаление.

Порт задан в конце `main.py` (`app.run(debug=True, port=5000)`).
Если 5000 занят, измените число в этой строке или запустите через CLI:
`flask --app main run --port 5001`.

При первом запуске каждый проект создаёт свою базу и наполняет её
демонстрационными данными. Повторный запуск использует существующую базу.

## Bash-практики

```bash
cd bash/01_syntax_basics
chmod +x *.sh
./01_hello.sh
```

В каждом каталоге есть `README.md` с перечнем скриптов и примерами запуска.

### Лабораторная по Linux

```bash
cd bash/04_linux_fundamentals
chmod +x *.sh
./run_lab.sh            # все команды частей 1–4
./myfirstscript.sh      # комплексное задание
./system_info.sh        # сведения о системе
./project_tree.sh      # структура myproject в текущем каталоге
./top_logs.sh /var/log  # 5 самых больших .log
```

`run_lab.sh` работает в отдельном каталоге `~/linux_practice`
и не удаляет пользовательские файлы.

### Проверочная работа по Bash

```bash
cd bash/05_control_work
chmod +x *.sh

./greeting.sh
./calculator.sh
./check_number.sh -5
./list_files.sh ~/Documents
./selfcheck.sh          # автоматический прогон всех заданий
```

## Контрольная по МДК.09.01

```bash
cd control_work
python task11_fixed.py   # исправленный код задания 11
python task12_delete.py  # функция удаления задания 12
```

Ответы на тест и пояснения — в `control_work/answers.md`.

## Отчёты

Каталог `reports/` содержит отдельный отчёт по каждой работе:

- `Отчет_Практика_1_SQLite_…`
- `Отчет_Практика_2_CRUD_…`
- `Отчет_Практика_3_Flask_…`
- `Отчет_Практика_4_Flask_SQLite_…`
- `Отчет_Практика_5_Форма_…`
- `Отчет_Практика_6_Ошибки_…`
- `Отчет_Практика_7_Мини-проект_…`
- `Отчет_Bash_Синтаксис_…`
- `Отчет_Bash_Арифметика_…`
- `Отчет_Bash_Скрипты_…`
- `Отчет_Linux_…`
- `Отчет_Bash_Контрольная_…`
- `Отчет_Контрольная_МДК09.01_…`

В отчётах отмечены места для скриншотов; их нужно вставить после запуска
соответствующих команд.

## Проверка

- Python: 24 автотеста через `Flask.test_client`, пять серверов запущены
  и вернули HTTP 200.
- Bash: все скрипты прошли `bash -n` и ShellCheck 0.10.0 без замечаний.
- Контрольная: оба Python-файла выполнены, результаты совпали с ожидаемыми.

## Примечание

Bash-скрипты рассчитаны на Linux. На Windows их удобнее запускать в WSL:

```powershell
wsl bash -lc "cd /mnt/c/Users/<user>/.../practice_VV/bash/05_control_work && ./selfcheck.sh"
```
