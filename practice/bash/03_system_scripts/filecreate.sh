#!/bin/bash
# Создание файла с выбранным содержимым.

echo "Что нужно создать?"
echo "  1) пустой файл"
echo "  2) файл с введённым текстом"
echo "  3) файл с текущей датой"
read -r -p "Пункт (1-3): " variant

if [[ ! "$variant" =~ ^[1-3]$ ]]; then
    echo "Нет такого пункта." >&2
    exit 1
fi

read -r -p "Имя файла: " fname

if [ -e "$fname" ]; then
    read -r -p "Файл уже есть. Перезаписать? (д/н): " confirm
    if [[ "$confirm" != "д" && "$confirm" != "да" ]]; then
        echo "Отменено."
        exit 0
    fi
fi

case "$variant" in
    1)
        : > "$fname"
        echo "Создан пустой файл: $fname"
        ;;
    2)
        read -r -p "Текст: " payload
        printf '%s\n' "$payload" > "$fname"
        echo "Записано в $fname:"
        cat "$fname"
        ;;
    3)
        date '+%d.%m.%Y %H:%M:%S' > "$fname"
        echo "В $fname записана дата:"
        cat "$fname"
        ;;
esac
