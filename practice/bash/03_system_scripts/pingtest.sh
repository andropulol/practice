#!/bin/bash
# Проверка доступности узла через ping.

host="$1"
if [ -z "$host" ]; then
    read -r -p "Адрес (домен или IP): " host
fi

if ! command -v ping >/dev/null 2>&1; then
    echo "Команда ping не найдена." >&2
    exit 1
fi

echo "Проверяю $host (4 пакета)..."
echo "----------------------------------------"

reply_count=0
while IFS= read -r row; do
    case "$row" in
        *"bytes from"*)
            reply_count=$((reply_count + 1))
            delay=$(printf '%s\n' "$row" | sed -n 's/.*time=\([0-9.]*\).*/\1/p')
            echo "  ответ #$reply_count: ${delay:-?} мс"
            ;;
        *"packet loss"*)
            echo "  $row"
            ;;
        *"unknown host"*|*"Name or service not known"*)
            echo "  Узел не найден."
            exit 1
            ;;
    esac
done < <(ping -c 4 -W 2 "$host" 2>&1)

if (( reply_count > 0 )); then
    echo "----------------------------------------"
    echo "Узел отвечает. Успешных ответов: $reply_count из 4."
else
    echo "Ответов нет — узел недоступен." >&2
    exit 1
fi
