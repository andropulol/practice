#!/bin/bash
# shellcheck disable=SC2012
# Просмотр и изменение прав доступа к файлу.

path="$1"
if [ -z "$path" ]; then
    read -r -p "Путь к файлу: " path
fi

if [ ! -e "$path" ]; then
    echo "Файл '$path' не найден." >&2
    exit 1
fi

show_rights() {
    if command -v stat >/dev/null 2>&1; then
        stat -c 'Права: %A (%a)' "$path"
    else
        ls -ld "$path" | awk '{print "Права: " $1}'
    fi
}

show_rights

echo "Что сделать?"
echo "  1) добавить право на выполнение"
echo "  2) оставить только чтение (444)"
echo "  3) вернуть стандартные права (644)"
echo "  4) ничего не менять"
read -r -p "Пункт (1-4): " mode_choice

case "$mode_choice" in
    1) chmod +x "$path" && echo "Файл теперь исполняемый." ;;
    2) chmod 444 "$path" && echo "Файл только для чтения." ;;
    3) chmod 644 "$path" && echo "Права сброшены на 644." ;;
    4) echo "Изменений нет."; exit 0 ;;
    *) echo "Неверный пункт." >&2; exit 1 ;;
esac

show_rights
