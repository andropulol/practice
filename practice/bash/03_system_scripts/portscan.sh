#!/bin/bash
# Просмотр слушающих TCP/UDP портов.

if command -v ss >/dev/null 2>&1; then
    tool="ss"
elif command -v netstat >/dev/null 2>&1; then
    tool="netstat"
else
    echo "Нет ни ss, ни netstat." >&2
    exit 1
fi

service_name() {
    local port="$1"
    if command -v getent >/dev/null 2>&1; then
        getent services "$port" 2>/dev/null | awk '{print $1}' | head -n 1
    fi
}

echo "===== СЛУШАЮЩИЕ TCP-ПОРТЫ ====="
if [ "$tool" = "ss" ]; then
    ss -tln 2>/dev/null | awk 'NR > 1 {print $4}' | while IFS= read -r endpoint; do
        port="${endpoint##*:}"
        label=$(service_name "$port")
        printf '  %-6s %s\n' "$port" "${label:-неизвестный сервис}"
    done

    echo
    echo "===== СЛУШАЮЩИЕ UDP-ПОРТЫ ====="
    ss -uln 2>/dev/null | awk 'NR > 1 {print $4}' | while IFS= read -r endpoint; do
        port="${endpoint##*:}"
        label=$(service_name "$port")
        printf '  %-6s %s\n' "$port" "${label:-неизвестный сервис}"
    done
else
    netstat -tuln 2>/dev/null | awk '/^(tcp|udp)/ {print $1, $4}' |
    while IFS=' ' read -r proto endpoint; do
        port="${endpoint##*:}"
        printf '  %-4s %-6s %s\n' "$proto" "$port" "$(service_name "$port")"
    done
fi
