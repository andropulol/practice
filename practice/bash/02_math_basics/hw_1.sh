#!/bin/bash
# Дополнительное задание 1.
# Площадь пола, площадь стен и объём комнаты.

if ! command -v bc >/dev/null 2>&1; then
    echo "Для расчётов нужна утилита bc: sudo apt install bc" >&2
    exit 1
fi

read -r -p "Длина комнаты (м):  " room_length
read -r -p "Ширина комнаты (м): " room_width
read -r -p "Высота комнаты (м): " room_height

for value in "$room_length" "$room_width" "$room_height"; do
    if [[ ! "$value" =~ ^[0-9]+([.][0-9]+)?$ ]]; then
        echo "Ошибка: все размеры должны быть положительными числами." >&2
        exit 1
    fi
done

floor_area=$(echo "scale=2; $room_length * $room_width" | bc)
wall_area=$(echo "scale=2; 2 * ($room_length + $room_width) * $room_height" | bc)
volume=$(echo "scale=2; $room_length * $room_width * $room_height" | bc)

echo "----------------------------------------"
echo "Площадь пола:  $floor_area м2"
echo "Площадь стен:  $wall_area м2"
echo "Объём комнаты: $volume м3"
