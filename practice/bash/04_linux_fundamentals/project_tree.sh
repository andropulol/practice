#!/bin/bash
# Дополнительное задание 1: структура каталогов проекта.

project="myproject"

for folder in \
    "$project/src/main" \
    "$project/src/test" \
    "$project/docs" \
    "$project/logs" \
    "$project/backup"
do
    mkdir -p "$folder" || exit 1
done

echo "Создана структура:"
if command -v tree >/dev/null 2>&1; then
    tree "$project"
else
    find "$project" -print | sort | sed 's|[^/]*/|  |g'
fi
