#!/bin/bash
# Упрощённый тест скорости: задержка и скорость загрузки.

echo "===== ТЕСТ СЕТИ ====="

if command -v ping >/dev/null 2>&1; then
    echo "Задержка до 8.8.8.8:"
    ping -c 3 -W 2 8.8.8.8 2>/dev/null | tail -n 2 | sed 's/^/  /'
else
    echo "  ping недоступен."
fi

echo
echo "Скорость загрузки (тестовый файл 1 МБ):"

if ! command -v curl >/dev/null 2>&1; then
    echo "  Для теста нужен curl." >&2
    exit 1
fi

probe="https://speedtest.tele2.net/1MB.zip"
bytes_per_sec=$(curl -sL -o /dev/null --max-time 20 \
    -w '%{speed_download}' "$probe" 2>/dev/null)

if [ -z "$bytes_per_sec" ] || [ "$bytes_per_sec" = "0" ]; then
    echo "  Не удалось измерить (нет доступа к тестовому серверу)." >&2
    exit 1
fi

if command -v bc >/dev/null 2>&1; then
    mbps=$(echo "scale=2; $bytes_per_sec * 8 / 1000000" | bc)
    echo "  Скорость: $mbps Мбит/с"
else
    mbps=$(( ${bytes_per_sec%.*} * 8 / 1000000 ))
    echo "  Скорость: примерно $mbps Мбит/с"
fi
