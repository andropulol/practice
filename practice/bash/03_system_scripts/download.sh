#!/bin/bash
# Загрузка файла из интернета с проверкой результата.

url="$1"
outfile="$2"

if [ -z "$url" ]; then
    read -r -p "URL: " url
fi
if [ -z "$outfile" ]; then
    outfile=$(basename "${url%%\?*}")
    read -r -p "Сохранить как [$outfile]: " answer
    [ -n "$answer" ] && outfile="$answer"
fi

if [ -z "$url" ] || [ -z "$outfile" ]; then
    echo "Нужны URL и имя файла." >&2
    exit 1
fi

if [ -e "$outfile" ]; then
    read -r -p "Файл '$outfile' существует. Перезаписать? (д/н): " reply
    if [[ "$reply" != "д" && "$reply" != "да" ]]; then
        echo "Отменено."
        exit 0
    fi
fi

echo "Загружаю $url ..."

if command -v curl >/dev/null 2>&1; then
    curl -fL --progress-bar -o "$outfile" "$url"
    status=$?
elif command -v wget >/dev/null 2>&1; then
    wget -O "$outfile" "$url"
    status=$?
else
    echo "Нет ни curl, ни wget." >&2
    exit 1
fi

if (( status == 0 )) && [ -s "$outfile" ]; then
    echo "Готово: $outfile ($(du -h "$outfile" | cut -f1))"
else
    echo "Загрузка не удалась (код $status)." >&2
    rm -f -- "$outfile"
    exit 1
fi
