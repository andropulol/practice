#!/bin/bash
# Поиск файлов по фрагменту имени в текущем каталоге и подкаталогах.

if [ -n "$1" ]; then
    fragment="$1"
else
    read -r -p "Фрагмент имени файла: " fragment
fi

if [ -z "$fragment" ]; then
    echo "Пустой шаблон искать бессмысленно." >&2
    exit 1
fi

echo "Поиск файлов, содержащих '$fragment':"
echo "----------------------------------------"

counter=0
while IFS= read -r found; do
    echo "  ${found#./}"
    counter=$((counter + 1))
done < <(find . -type f -name "*${fragment}*" 2>/dev/null | sort)

echo "----------------------------------------"
echo "Найдено файлов: $counter"

if (( counter == 0 )); then
    exit 1
fi
