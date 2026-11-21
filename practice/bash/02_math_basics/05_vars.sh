#!/bin/bash
# Практика «Вычисления в Bash» — переменные и подстановка.

unit_cost=180
items=3

order_sum=$((unit_cost * items))

echo "Цена за единицу: $unit_cost руб."
echo "Количество:      $items шт."
echo "Стоимость:       $order_sum руб."
echo "--------------------------------"

items=5
order_sum=$((unit_cost * items))

echo "Количество изменилось на $items шт."
echo "Новая стоимость: $order_sum руб."
