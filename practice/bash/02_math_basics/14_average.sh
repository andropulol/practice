#!/bin/bash
# Практика «Вычисления в Bash» — задание 8.
# Среднее арифметическое трёх чисел через bc.

if ! command -v bc >/dev/null 2>&1; then
    echo "Утилита bc не установлена. Установите: sudo apt install bc" >&2
    exit 1
fi

read -r -p "Первое число:  " one
read -r -p "Второе число:  " two
read -r -p "Третье число:  " three

for value in "$one" "$two" "$three"; do
    if [[ ! "$value" =~ ^-?[0-9]+([.][0-9]+)?$ ]]; then
        echo "Ошибка: '$value' не является числом." >&2
        exit 1
    fi
done

average=$(echo "scale=2; ($one + $two + $three) / 3" | bc)

echo "-----------------------------"
echo "Среднее арифметическое: $average"
