#!/bin/bash
# Практика «Вычисления в Bash» — задание 2.
# Считает операции для двух чисел, а также квадрат и куб.

first=25
second=4

echo "Числа: $first и $second"
echo "Сумма:           $((first + second))"
echo "Разность:        $((first - second))"
echo "Произведение:    $((first * second))"
echo "Частное:         $((first / second))"
echo "Остаток:         $((first % second))"
echo "Квадрат первого: $((first ** 2))"
echo "Куб второго:     $((second ** 3))"
