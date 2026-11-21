#!/bin/bash
# Дополнительное задание 4.
# Игра «угадай число».

secret=$((RANDOM % 10 + 1))
attempt=1
limit=3

echo "Я загадал число от 1 до 10. У вас $limit попытки."

while (( attempt <= limit )); do
    read -r -p "Попытка $attempt. Ваш вариант: " guess

    if [[ ! "$guess" =~ ^[0-9]+$ ]]; then
        echo "Нужно ввести число от 1 до 10."
        continue
    fi

    if (( guess == secret )); then
        echo "Победа! Вы угадали с попытки $attempt."
        exit 0
    elif (( guess < secret )); then
        echo "Загаданное число больше."
    else
        echo "Загаданное число меньше."
    fi

    attempt=$((attempt + 1))
done

echo "Не угадали. Было загадано число $secret."
exit 1
