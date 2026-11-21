#!/bin/bash
# Наблюдение за файлом в реальном времени (выход по Ctrl+C).

logfile="$1"
if [ -z "$logfile" ]; then
    read -r -p "Файл для наблюдения: " logfile
fi

if [ ! -f "$logfile" ]; then
    echo "Файл '$logfile' не найден." >&2
    exit 1
fi

if ! command -v tail >/dev/null 2>&1; then
    echo "Команда tail не найдена." >&2
    exit 1
fi

echo "Наблюдаю за $logfile. Выход — Ctrl+C."
echo "Последние пять строк:"
tail -n 5 "$logfile"
echo "----------------------------------------"

# -F переживает пересоздание файла (в отличие от -f).
trap 'echo; echo "Наблюдение остановлено."; exit 0' INT TERM
tail -n 0 -F "$logfile"
