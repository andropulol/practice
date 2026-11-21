#!/bin/bash
# Практика «Вычисления в Bash» — задание 6.
# Перевод секунд в часы/минуты/секунды.
# Число берётся из аргумента, а если его нет — запрашивается.

total="$1"

if [ -z "$total" ]; then
    read -r -p "Количество секунд: " total
fi

if [[ ! "$total" =~ ^[0-9]+$ ]]; then
    echo "Ошибка: ожидается целое неотрицательное число секунд." >&2
    exit 1
fi

hours=$((total / 3600))
tail_after_hours=$((total % 3600))
minutes=$((tail_after_hours / 60))
seconds=$((tail_after_hours % 60))

printf '%d секунд = %d ч %d мин %d с\n' "$total" "$hours" "$minutes" "$seconds"
