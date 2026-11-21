#!/bin/bash
# Практика «Основы Bash» — скрипт 3.
# Ввод данных: обычный, с подсказкой и скрытый.

read -r -p "Ваше имя: " visitor
echo "Здравствуйте, $visitor!"

read -r -p "Ваш возраст: " years
if [[ "$years" =~ ^[0-9]+$ ]]; then
    echo "Через год вам будет $((years + 1))."
else
    echo "Возраст должен быть числом."
fi

read -rs -p "Придумайте пароль: " secret
echo
echo "Длина пароля: ${#secret} символов."
