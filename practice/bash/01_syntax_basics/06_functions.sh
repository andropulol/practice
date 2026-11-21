#!/bin/bash
# Практика «Основы Bash» — скрипт 6.
# Функции: аргументы, локальные переменные, коды возврата.

greet() {
    local who="$1"
    local greeting="${2:-Привет}"
    echo "$greeting, $who!"
}

is_number() {
    [[ "$1" =~ ^-?[0-9]+$ ]]
}

safe_divide() {
    local numerator="$1"
    local denominator="$2"

    if ! is_number "$numerator" || ! is_number "$denominator"; then
        echo "Оба аргумента должны быть числами." >&2
        return 2
    fi
    if (( denominator == 0 )); then
        echo "На ноль делить нельзя." >&2
        return 3
    fi

    echo "$((numerator / denominator))"
    return 0
}

greet "Андрей"
greet "Мария" "Добрый день"

quotient=$(safe_divide 10 2)
status=$?
echo "10 / 2 = $quotient"
echo "Код возврата: $status"

quotient=$(safe_divide 10 0 2>/dev/null)
status=$?
echo "10 / 0 = ${quotient:-нет результата}"
echo "Код возврата: $status"
