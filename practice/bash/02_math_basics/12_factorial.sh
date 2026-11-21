#!/bin/bash
# Практика «Вычисления в Bash» — задание 7 (вариант с произведением).
# Факториал числа N.

read -r -p "Введите N: " limit

if [[ ! "$limit" =~ ^[0-9]+$ ]]; then
    echo "Ошибка: N должно быть целым неотрицательным числом." >&2
    exit 1
fi

product=1
factor=2

while (( factor <= limit )); do
    product=$((product * factor))
    factor=$((factor + 1))
done

echo "$limit! = $product"
