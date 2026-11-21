#!/bin/bash
# Практика «Основы Bash» — скрипт 4.
# Условные операторы: числа, строки, файлы.

read -r -p "Введите целое число: " value

if [[ ! "$value" =~ ^-?[0-9]+$ ]]; then
    echo "Это не число." >&2
    exit 1
fi

if (( value > 0 )); then
    echo "Число положительное."
elif (( value < 0 )); then
    echo "Число отрицательное."
else
    echo "Это ноль."
fi

if (( value % 2 == 0 )); then
    echo "Число чётное."
else
    echo "Число нечётное."
fi

# Проверка строки
message=""
if [ -z "$message" ]; then
    echo "Строка пустая."
fi

# Проверка файла
target="/etc/hosts"
if [ -f "$target" ] && [ -r "$target" ]; then
    echo "Файл $target существует и доступен для чтения."
else
    echo "Файл $target недоступен."
fi
