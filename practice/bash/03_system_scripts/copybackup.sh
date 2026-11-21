#!/bin/bash
# Копирование файла с автоматическим бэкапом старой версии.

origin="$1"
destination="$2"

if [ -z "$origin" ]; then
    read -r -p "Что копируем: " origin
fi
if [ -z "$destination" ]; then
    read -r -p "Куда копируем: " destination
fi

if [ ! -f "$origin" ]; then
    echo "Исходный файл '$origin' не существует." >&2
    exit 1
fi

dest_dir=$(dirname "$destination")
if [ ! -d "$dest_dir" ]; then
    echo "Каталога '$dest_dir' нет. Создаю..." >&2
    mkdir -p "$dest_dir" || exit 1
fi

if [ -f "$destination" ]; then
    stamp=$(date '+%Y%m%d-%H%M%S')
    reserve="${destination}.bak-${stamp}"
    cp -- "$destination" "$reserve" || exit 1
    echo "Старая версия сохранена: $reserve"
fi

if cp -- "$origin" "$destination"; then
    echo "Скопировано: $origin -> $destination"
    echo "Размер: $(du -h "$destination" | cut -f1)"
else
    echo "Копирование не удалось." >&2
    exit 1
fi
