#!/bin/bash
# Практика «Вычисления в Bash» — задание 3.
# Площадь и периметр прямоугольника.

width=8
height=5

area=$((width * height))
perimeter=$((2 * (width + height)))

echo "Прямоугольник ${width} x ${height}"
echo "Площадь:  $area"
echo "Периметр: $perimeter"
