#!/bin/bash
# Счётчик от 1 до указанного числа.

if [ -n "$1" ]; then
    limit="$1"
else
    read -r -p "Считать до: " limit
fi

if [[ ! "$limit" =~ ^[0-9]+$ ]] || (( limit == 0 )); then
    echo "Ожидается натуральное число." >&2
    exit 1
fi

echo "Считаю от 1 до $limit:"
for (( index = 1; index <= limit; index++ )); do
    echo -n "$index "
    sleep 0.2
done
echo
echo "Готово."
