#!/bin/bash
# Практика «Вычисления в Bash» — задание 4.
# Калькулятор: +, -, *, /, %.

read -r -p "Первое число: " operand1
read -r -p "Второе число: " operand2
read -r -p "Операция (+, -, *, /, %): " action

if [[ ! "$operand1" =~ ^-?[0-9]+$ ]] || [[ ! "$operand2" =~ ^-?[0-9]+$ ]]; then
    echo "Оба значения должны быть целыми числами." >&2
    exit 1
fi

case "$action" in
    +)
        echo "$operand1 + $operand2 = $((operand1 + operand2))"
        ;;
    -)
        echo "$operand1 - $operand2 = $((operand1 - operand2))"
        ;;
    \*)
        echo "$operand1 * $operand2 = $((operand1 * operand2))"
        ;;
    /)
        if (( operand2 == 0 )); then
            echo "Ошибка: деление на ноль." >&2
            exit 1
        fi
        echo "$operand1 / $operand2 = $((operand1 / operand2))"
        ;;
    %)
        if (( operand2 == 0 )); then
            echo "Ошибка: остаток от деления на ноль." >&2
            exit 1
        fi
        echo "$operand1 % $operand2 = $((operand1 % operand2))"
        ;;
    *)
        echo "Неизвестная операция: $action" >&2
        exit 1
        ;;
esac
