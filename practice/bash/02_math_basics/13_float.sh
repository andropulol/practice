#!/bin/bash
# Практика «Вычисления в Bash» — дробные вычисления через bc.
# Площадь круга по радиусу.

if ! command -v bc >/dev/null 2>&1; then
    echo "Утилита bc не установлена. Установите: sudo apt install bc" >&2
    exit 1
fi

read -r -p "Радиус круга: " radius

if [[ ! "$radius" =~ ^[0-9]+([.][0-9]+)?$ ]]; then
    echo "Ошибка: радиус должен быть положительным числом." >&2
    exit 1
fi

area=$(echo "scale=2; 3.14159 * $radius * $radius" | bc)
length=$(echo "scale=2; 2 * 3.14159 * $radius" | bc)

echo "-----------------------------"
echo "Радиус:          $radius"
echo "Площадь круга:   $area"
echo "Длина окружности: $length"
