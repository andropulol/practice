#!/bin/bash
# shellcheck disable=SC2012
# Информация о файле или каталоге.
# Аргумент можно передать сразу: ./fileinfo.sh /etc/hosts

target="$1"

if [ -z "$target" ]; then
    read -r -p "Путь к файлу или каталогу: " target
fi

if [ ! -e "$target" ]; then
    echo "Объект '$target' не найден." >&2
    exit 1
fi

echo "===== СВЕДЕНИЯ ОБ ОБЪЕКТЕ ====="
echo "Имя:  $(basename "$target")"
echo "Путь: $(cd "$(dirname "$target")" && pwd)"

if [ -d "$target" ]; then
    kind="каталог"
    amount=$(find "$target" -mindepth 1 -maxdepth 1 | wc -l)
    echo "Тип:  $kind (элементов внутри: $amount)"
elif [ -f "$target" ]; then
    kind="обычный файл"
    echo "Тип:  $kind"
    echo "Строк в файле: $(wc -l < "$target" 2>/dev/null || echo 'н/д')"
else
    echo "Тип:  специальный файл"
fi

if command -v stat >/dev/null 2>&1; then
    echo "Права:   $(stat -c '%A (%a)' "$target")"
    echo "Размер:  $(stat -c '%s' "$target") байт"
    echo "Владелец: $(stat -c '%U:%G' "$target")"
else
    echo "Права:   $(ls -ld "$target" | awk '{print $1}')"
    echo "Размер:  $(du -sh "$target" | cut -f1)"
fi
