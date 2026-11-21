#!/bin/bash
# Практика «Основы Bash» — скрипт 1.
# Показывает, как работают переменные и подстановка команд.

student="Кривцов Андрей Сергеевич"
group="3ИСП9-54"
now=$(date '+%d.%m.%Y, %H:%M')
folder=$(pwd)

echo "Студент:    $student"
echo "Группа:     $group"
echo "Сейчас:     $now"
echo "Каталог:    $folder"
echo "Оболочка:   $SHELL"
echo "Пользователь: $USER"
