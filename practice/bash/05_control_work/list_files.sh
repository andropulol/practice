#!/bin/bash
# Проверочная работа по Bash — задание 4.
# Выводит .txt-файлы каталога и их размеры.

if [ -z "$1" ]; then
    echo "Использование: $0 <путь к каталогу>" >&2
    exit 1
fi

directory="$1"

if [ ! -e "$directory" ]; then
    echo "Ошибка: '$directory' не существует." >&2
    exit 1
fi

if [ ! -d "$directory" ]; then
    echo "Ошибка: '$directory' — это файл, а не каталог." >&2
    exit 1
fi

echo "Найдены .txt файлы в $directory:"

found=0
while IFS= read -r file; do
    size=$(du -h "$file" | cut -f1)
    echo "- $(basename "$file") ($size)"
    found=$((found + 1))
done < <(find "$directory" -maxdepth 1 -type f -name "*.txt" | sort)

if (( found == 0 )); then
    echo "  (файлов с расширением .txt нет)"
else
    echo "Всего файлов: $found"
fi
