#!/bin/bash
# Практика «Вычисления в Bash» — задание 5.
# Расчёт скидки с предупреждением при скидке больше 50%.

read -r -p "Цена товара: " price
read -r -p "Скидка в процентах: " percent

if [[ ! "$price" =~ ^[0-9]+$ ]] || [[ ! "$percent" =~ ^[0-9]+$ ]]; then
    echo "Нужны неотрицательные целые числа." >&2
    exit 1
fi

if (( percent > 100 )); then
    echo "Скидка не может быть больше 100%." >&2
    exit 1
fi

if (( percent > 50 )); then
    echo "Внимание: скидка больше половины цены!"
fi

saved=$((price * percent / 100))
to_pay=$((price - saved))

echo "-----------------------------"
echo "Цена без скидки: $price руб."
echo "Скидка $percent%: $saved руб."
echo "К оплате:        $to_pay руб."
