#!/bin/bash
# Практика «Основы Bash» — скрипт 5.
# Циклы for и while.

echo "== for по списку =="
for tool in sqlite3 python3 flask curl; do
    echo "  инструмент: $tool"
done

echo
echo "== for по диапазону =="
for day in {1..5}; do
    echo "  день $day"
done

echo
echo "== while со счётчиком =="
step=1
while (( step <= 3 )); do
    echo "  шаг $step из 3"
    step=$((step + 1))
done

echo
echo "== while с чтением файла =="
config="/etc/hostname"
if [ -r "$config" ]; then
    line_no=0
    while IFS= read -r line; do
        line_no=$((line_no + 1))
        echo "  строка $line_no: $line"
    done < "$config"
else
    echo "  файл $config недоступен"
fi
