#!/bin/bash
# Дополнительное задание 2.
# Доход по вкладу за один год (простые проценты).

read -r -p "Сумма вклада: " deposit
read -r -p "Годовая ставка, %: " rate

if [[ ! "$deposit" =~ ^[0-9]+$ ]] || [[ ! "$rate" =~ ^[0-9]+([.][0-9]+)?$ ]]; then
    echo "Ошибка: сумма — целое число, ставка — число." >&2
    exit 1
fi

if command -v bc >/dev/null 2>&1; then
    income=$(echo "scale=2; $deposit * $rate / 100" | bc)
    total=$(echo "scale=2; $deposit + $income" | bc)
else
    income=$((deposit * ${rate%.*} / 100))
    total=$((deposit + income))
fi

echo "----------------------------------------"
echo "Вклад:         $deposit руб."
echo "Ставка:        $rate% годовых"
echo "Доход за год:  $income руб."
echo "Итого на счёте: $total руб."
