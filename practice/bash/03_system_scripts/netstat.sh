#!/bin/bash
# Активные сетевые соединения.

if ! command -v ss >/dev/null 2>&1; then
    echo "Команда ss недоступна. Установите iproute2." >&2
    exit 1
fi

echo "===== АКТИВНЫЕ СОЕДИНЕНИЯ ====="
printf '%-22s %-22s %s\n' "ОТКУДА" "КУДА" "СОСТОЯНИЕ"
echo "---------------------------------------------------------------"

active=0
while IFS= read -r row; do
    state=$(printf '%s\n' "$row" | awk '{print $1}')
    case "$state" in
        ESTAB|SYN-SENT|SYN-RECV|FIN-WAIT-1|FIN-WAIT-2|TIME-WAIT|CLOSE-WAIT|LAST-ACK|CLOSING)
            src=$(printf '%s\n' "$row" | awk '{print $5}')
            dst=$(printf '%s\n' "$row" | awk '{print $6}')
            printf '%-22s %-22s %s\n' "$src" "$dst" "$state"
            active=$((active + 1))
            ;;
    esac
done < <(ss -tun 2>/dev/null | tail -n +2)

echo "---------------------------------------------------------------"
echo "Всего активных соединений: $active"
