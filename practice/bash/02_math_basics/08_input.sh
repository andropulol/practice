#!/bin/bash
# Практика «Вычисления в Bash» — ввод двух чисел с проверкой.

is_integer() {
    [[ "$1" =~ ^-?[0-9]+$ ]]
}

read -r -p "Первое число:  " num1
read -r -p "Второе число:  " num2

if ! is_integer "$num1" || ! is_integer "$num2"; then
    echo "Ошибка: нужно ввести два целых числа." >&2
    exit 1
fi

echo "-----------------------------"
echo "Сумма:        $((num1 + num2))"
echo "Разность:     $((num1 - num2))"
echo "Произведение: $((num1 * num2))"

if (( num2 != 0 )); then
    echo "Частное:      $((num1 / num2))"
    echo "Остаток:      $((num1 % num2))"
else
    echo "Деление невозможно: второе число равно нулю."
fi
