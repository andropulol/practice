#!/bin/bash
# Показ локальных и внешнего IP-адресов.

echo "===== ЛОКАЛЬНЫЕ АДРЕСА ====="

if command -v ip >/dev/null 2>&1; then
    ip -4 addr show 2>/dev/null | awk '/inet / {print $2}' | cut -d'/' -f1 |
    while IFS= read -r addr; do
        [ "$addr" = "127.0.0.1" ] && continue
        echo "  $addr"
    done
elif command -v hostname >/dev/null 2>&1; then
    hostname -I 2>/dev/null | tr ' ' '\n' | while IFS= read -r addr; do
        [ -n "$addr" ] && echo "  $addr"
    done
else
    echo "  Не удалось определить: нет команд ip/hostname."
fi

echo
echo "===== ВНЕШНИЙ АДРЕС ====="
external=""

if command -v curl >/dev/null 2>&1; then
    external=$(curl -fsS --max-time 5 https://ifconfig.me 2>/dev/null)
elif command -v wget >/dev/null 2>&1; then
    external=$(wget -qO- --timeout=5 https://ifconfig.me 2>/dev/null)
fi

if [ -n "$external" ]; then
    echo "  $external"
else
    echo "  Недоступен (нет интернета или утилит curl/wget)."
fi
