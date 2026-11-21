#!/bin/bash
# Автопроверка заданий 1-4 проверочной работы.
# Запускать из каталога, где лежат greeting.sh и остальные скрипты.

check_dir=$(mktemp -d)
trap 'rm -rf "$check_dir"' EXIT

echo "== greeting.sh =="
printf 'Иванов Иван\n' | ./greeting.sh

echo
echo "== calculator.sh =="
printf '10\n5\n*\n' | ./calculator.sh
printf '10\n4\n/\n' | ./calculator.sh

echo
echo "== check_number.sh =="
./check_number.sh -5
./check_number.sh 0
./check_number.sh 7

echo
echo "== list_files.sh =="
echo "первый" > "$check_dir/one.txt"
echo "второй" > "$check_dir/two.txt"
echo "не txt" > "$check_dir/note.md"
./list_files.sh "$check_dir"

echo
echo "== обработка ошибок =="
./check_number.sh || echo "  (нет аргумента — ошибка обработана)"
./list_files.sh /nonexistent || echo "  (нет каталога — ошибка обработана)"

echo
echo "Проверка завершена."
