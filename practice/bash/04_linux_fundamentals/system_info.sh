#!/bin/bash
# Дополнительное задание 3: сведения о системе.

echo "===== СВЕДЕНИЯ О СИСТЕМЕ ====="
echo "Имя хоста:        $(hostname)"
echo "Ядро:             $(uname -r)"
echo "Архитектура:      $(uname -m)"
echo "Пользователь:     $(whoami)"
echo "Домашний каталог: $HOME"
echo

echo "----- Время работы -----"
uptime 2>/dev/null || echo "нет данных"
echo

echo "----- Память -----"
if command -v free >/dev/null 2>&1; then
    free -h
else
    echo "free недоступен"
fi
echo

echo "----- Запущенные процессы (первые 10) -----"
ps -eo pid,user,comm,%cpu,%mem --sort=-%cpu 2>/dev/null | head -n 11
echo

echo "----- Диски -----"
df -h 2>/dev/null | head -n 6
