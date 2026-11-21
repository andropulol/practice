#!/bin/bash
# Дополнительное задание 3.
# Проверка числа: чётность, делимость на 3 и на 5.

if [ -z "$1" ]; then
    read -r -p "Введите целое число: " number
else
    number="$1"
fi

if [[ ! "$number" =~ ^-?[0-9]+$ ]]; then
    echo "Ошибка: '$number' не является целым числом." >&2
    exit 1
fi

echo "Число: $number"

if (( number % 2 == 0 )); then
    echo "  чётное"
else
    echo "  нечётное"
fi

if (( number % 3 == 0 )); then
    echo "  делится на 3"
else
    echo "  не делится на 3"
fi

if (( number % 5 == 0 )); then
    echo "  делится на 5"
else
    echo "  не делится на 5"
fi
