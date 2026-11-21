#!/bin/bash
# Дополнительное задание 2: пять самых больших .log-файлов.
# Поиск идёт в каталоге, переданном аргументом (по умолчанию — текущий).

search_root="${1:-.}"

if [ ! -d "$search_root" ]; then
    echo "Каталог '$search_root' не существует." >&2
    exit 1
fi

echo "Пять самых больших .log-файлов в $search_root:"
echo "----------------------------------------"

find "$search_root" -type f -name "*.log" -printf '%s %p\n' 2>/dev/null |
    sort -rn |
    head -n 5 |
    while read -r size name; do
        human=$(numfmt --to=iec "$size" 2>/dev/null || echo "${size} B")
        printf '%8s  %s\n' "$human" "$name"
    done

echo "----------------------------------------"
