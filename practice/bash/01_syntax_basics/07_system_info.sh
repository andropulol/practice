#!/bin/bash
# Практика «Основы Bash» — скрипт 7.
# Мониторинг системы: дата, пользователь, память, диск, процессы.

echo "===== СОСТОЯНИЕ СИСТЕМЫ ====="
echo "Дата:        $(date '+%d.%m.%Y %H:%M:%S')"
echo "Хост:        $(hostname)"
echo "Пользователь: $USER"
echo

echo "----- Загрузка CPU -----"
if command -v uptime >/dev/null 2>&1; then
    uptime
else
    echo "Команда uptime не найдена."
fi
echo

echo "----- Память -----"
if command -v free >/dev/null 2>&1; then
    free -h
else
    echo "Команда free не найдена."
fi
echo

echo "----- Диск -----"
df -h / 2>/dev/null | tail -n 2
echo

echo "----- Пять самых активных процессов -----"
if command -v ps >/dev/null 2>&1; then
    ps -eo pid,comm,%cpu --sort=-%cpu 2>/dev/null | head -n 6
else
    echo "Команда ps не найдена."
fi
