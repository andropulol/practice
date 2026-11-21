#!/bin/bash
# Практика «Основы Bash» — скрипт 2.
# Переменные, кавычки и вычисления.

city="Москва"
temperature=21
readonly CURRENCY="руб."

# Двойные кавычки подставляют значение, одинарные — нет.
echo "Город: $city"
echo "Температура: $temperature градусов"
echo "Валюта: $CURRENCY"

# Арифметика через $(( ))
double_temp=$((temperature * 2))
echo "Удвоенная температура: $double_temp"

# Изменять readonly-переменную нельзя — раскомментируйте и проверьте:
# CURRENCY="USD"

echo "Строка с обратными кавычками: $(date +%Y)"
