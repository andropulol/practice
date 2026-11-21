#!/bin/bash
# DNS-информация о домене.

domain="$1"
if [ -z "$domain" ]; then
    read -r -p "Домен (например, example.com): " domain
fi

if [ -z "$domain" ]; then
    echo "Домен не указан." >&2
    exit 1
fi

echo "===== DNS ДЛЯ $domain ====="

if command -v dig >/dev/null 2>&1; then
    echo "-- A-записи --"
    result=$(dig +short A "$domain" 2>/dev/null)
    if [ -n "$result" ]; then
        printf '%s\n' "$result" | sed 's/^/  /'
    else
        echo "  A-записи не найдены."
    fi
elif command -v getent >/dev/null 2>&1; then
    echo "-- Адреса --"
    getent ahosts "$domain" 2>/dev/null | awk '{print $1}' | sort -u | sed 's/^/  /'
else
    echo "Нет утилит dig/getent." >&2
    exit 1
fi

echo
echo "-- Серверы имён --"
if command -v nslookup >/dev/null 2>&1; then
    nslookup "$domain" 2>/dev/null | sed -n '/Name:/,$p' | sed 's/^/  /'
else
    echo "  nslookup недоступен."
fi
