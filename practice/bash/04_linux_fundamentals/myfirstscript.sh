#!/bin/bash
# Комплексное задание: мини-отчёт о системе.
# Создаёт каталог logs и файл logs/info.log.

report_dir="logs"
log_file="$report_dir/info.log"
mkdir -p "$report_dir" || exit 1

echo "=== Текущая дата и время ==="
date '+%d.%m.%Y %H:%M:%S'

echo
echo "=== Текущий каталог ==="
pwd
ls -la

echo
echo "=== Сбор информации ==="
{
    echo "Дата: $(date '+%d.%m.%Y %H:%M:%S')"
    echo "Пользователь: $(whoami)"
    echo "Хост: $(hostname)"
    echo "Система: $(uname -srm)"
    echo "Каталог: $(pwd)"
} > "$log_file"

echo "Файл $log_file создан:"
cat "$log_file"

echo
echo "=== Проверка сети ==="
if ping -c 2 -W 2 8.8.8.8 >/dev/null 2>&1; then
    echo "Сеть доступна."
else
    echo "Сеть недоступна."
fi

echo
echo "=== Свободное место ==="
df -h "$HOME" 2>/dev/null | tail -n 2

echo
echo "=== Готово ==="
