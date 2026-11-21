#!/bin/bash
# Простое меню с системными командами.

pause() {
    read -r -p "Нажмите Enter, чтобы продолжить..." _
}

while true; do
    clear 2>/dev/null || true
    cat <<'MENU'
==============================
        ГЛАВНОЕ МЕНЮ
==============================
  1. Текущая дата и время
  2. Кто работает в системе
  3. Свободное место на дисках
  4. Пять самых тяжёлых процессов
  0. Выход
MENU

    read -r -p "Пункт: " item
    echo

    case "$item" in
        1)
            date '+%d.%m.%Y %H:%M:%S (%A)'
            pause
            ;;
        2)
            if command -v who >/dev/null 2>&1; then
                who
            else
                echo "Команда who недоступна."
            fi
            pause
            ;;
        3)
            df -h
            pause
            ;;
        4)
            ps -eo pid,user,comm,%cpu,%mem --sort=-%cpu 2>/dev/null | head -n 6
            pause
            ;;
        0)
            echo "Выход из меню."
            exit 0
            ;;
        *)
            echo "Такого пункта нет."
            pause
            ;;
    esac
done
