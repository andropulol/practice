#!/bin/bash
# Практика «Вычисления в Bash» — сумма чисел от 1 до N.

read -r -p "Введите N: " limit

if [[ ! "$limit" =~ ^[0-9]+$ ]]; then
    echo "Ошибка: N должно быть целым неотрицательным числом." >&2
    exit 1
fi

acc=0
current=1

while (( current <= limit )); do
    acc=$((acc + current))
    current=$((current + 1))
done

echo "Сумма чисел от 1 до $limit = $acc"
echo "Проверка по формуле: $((limit * (limit + 1) / 2))"
