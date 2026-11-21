#!/bin/bash
# Практика «Вычисления в Bash» — все основные операции.

first=23
second=6

echo "first  = $first"
echo "second = $second"
echo "-----------------------------"
echo "Сложение:  $first + $second = $((first + second))"
echo "Вычитание: $first - $second = $((first - second))"
echo "Умножение: $first * $second = $((first * second))"
echo "Деление:   $first / $second = $((first / second))  (только целая часть)"
echo "Остаток:   $first % $second = $((first % second))"
echo "Степень:   2 ^ 10 = $((2 ** 10))"
