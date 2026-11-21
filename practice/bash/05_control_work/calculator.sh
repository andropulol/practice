#!/bin/bash
# Проверочная работа по Bash — задание 2.
# Калькулятор: два числа и операция.
# Расчёты выполняет awk, поэтому bc не требуется.

is_number() {
    [[ "$1" =~ ^-?[0-9]+([.][0-9]+)?$ ]]
}

read -r -p "Введите первое число:  " number_a
read -r -p "Введите второе число:  " number_b
read -r -p "Введите операцию (+, -, *, /): " operator

if ! is_number "$number_a" || ! is_number "$number_b"; then
    echo "Ошибка: оба значения должны быть числами." >&2
    exit 1
fi

case "$operator" in
    +|-|\*|/) ;;
    *)
        echo "Ошибка: неизвестная операция '$operator'." >&2
        exit 1
        ;;
esac

if [ "$operator" = "/" ]; then
    if awk -v divisor="$number_b" 'BEGIN { exit !(divisor == 0) }'; then
        echo "Ошибка: деление на ноль невозможно." >&2
        exit 1
    fi
fi

result=$(awk -v x="$number_a" -v y="$number_b" -v op="$operator" 'BEGIN {
    if (op == "+")      value = x + y;
    else if (op == "-") value = x - y;
    else if (op == "*") value = x * y;
    else                value = x / y;
    printf "%.10g", value;
}')

echo "Результат: $number_a $operator $number_b = $result"
