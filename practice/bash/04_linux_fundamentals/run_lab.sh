#!/bin/bash
# shellcheck disable=SC2016,SC2012
# Практическая работа «Основы работы с Linux».
# Скрипт последовательно выполняет все команды лабораторной
# в отдельном каталоге ~/linux_practice и печатает результат.
# Удобно для скриншотов отчёта.

WORK="$HOME/linux_practice"

section() {
    echo
    echo "=================================================="
    echo "  $1"
    echo "=================================================="
}

run() {
    echo "\$ $*"
    "$@" 2>&1 || echo "  (команда завершилась с ошибкой)"
}

mkdir -p "$WORK"
cd "$WORK" || exit 1

section "Часть 1.1. Навигация и создание структуры"
run pwd
echo "\$ ls ~"
ls ~ 2>/dev/null | head -n 5
run mkdir -p documents projects downloads
run pwd
run ls -1

section "Часть 1.2. Создание и работа с файлами"
echo '$ echo "Моя первая практическая работа" > readme.txt'
echo "Моя первая практическая работа" > readme.txt
run cat readme.txt
echo '$ echo "Дата выполнения: $(date)" >> readme.txt'
echo "Дата выполнения: $(date '+%d.%m.%Y %H:%M')" >> readme.txt
run cat readme.txt
echo '$ for i in {1..10}; do echo "Число $i" >> numbers.txt; done'
for i in {1..10}; do echo "Число $i" >> numbers.txt; done
run cat numbers.txt

section "Часть 1.3. Копирование и перемещение"
run cp readme.txt documents/
run ls -1 documents
run mv numbers.txt downloads/
run ls -1 downloads
run ls -1
run cp -r documents projects/
run ls -1 projects

section "Часть 2.1. Поиск файлов"
run touch file1.txt file2.log file3.txt document.pdf image.jpg
echo '$ find . -name "*.txt"'
find . -name "*.txt" | sort
echo '$ find . -name "file*"'
find . -name "file*" | sort
echo '$ find . -size +1k'
find . -size +1k | sort
echo '$ find . -mmin -10  (изменённые за последние 10 минут)'
find . -mmin -10 -type f | sort

section "Часть 2.2. Поиск текста (grep)"
cat > data.txt <<'EOF'
Иванов Иван 25
Петров Петр 30
Сидоров Сидор 28
Иванова Мария 22
Петрова Анна 35
EOF
run cat data.txt
echo '$ grep "Петров" data.txt'
grep "Петров" data.txt
echo '$ grep -E "[3-9][0-9]" data.txt  (возраст 30+)'
grep -E "[3-9][0-9]" data.txt
echo '$ grep -v "Иван" data.txt  (строки без "Иван")'
grep -v "Иван" data.txt
echo '$ grep -c "Иванов" data.txt'
grep -c "Иванов" data.txt

section "Часть 2.3. Конвейеры"
run head -5 data.txt
run tail -3 data.txt
run sort data.txt
echo "\$ awk '{print \$1}' data.txt"
awk '{print $1}' data.txt
echo "\$ awk '{print \$1}' data.txt | sort | uniq"
awk '{print $1}' data.txt | sort | uniq
echo "\$ awk '{print \$1}' data.txt | sort | uniq -c"
awk '{print $1}' data.txt | sort | uniq -c

section "Часть 3. Права доступа"
cat > script.sh <<'EOF'
#!/bin/bash
echo "Hello, World!"
date
EOF
run ls -l script.sh
run chmod +x script.sh
run ls -l script.sh
run ./script.sh
run chmod -r script.sh
run ls -l script.sh
echo '$ cat script.sh  (после снятия права на чтение)'
cat script.sh 2>&1 || echo "  Прочитать файл не удалось — сработала защита прав."
run chmod 644 script.sh
run ls -l script.sh

section "Часть 4.1. Сеть"
echo '$ ping -c 4 127.0.0.1'
ping -c 4 127.0.0.1 2>&1 | tail -n 3 || echo "  ping недоступен"
echo '$ ping -c 4 ya.ru'
ping -c 4 -W 2 ya.ru 2>&1 | tail -n 3 || echo "  нет доступа в интернет"
echo '$ ip addr | grep inet'
ip addr 2>/dev/null | grep inet || echo "  команда ip недоступна"
echo '$ ss -tuln | head -10'
ss -tuln 2>/dev/null | head -n 10 || echo "  команда ss недоступна"
echo '$ curl -s ifconfig.me'
curl -fsS --max-time 5 https://ifconfig.me 2>/dev/null || echo "  внешний IP недоступен"
echo

section "Часть 4.2. DNS и загрузка"
echo '$ nslookup google.com'
nslookup google.com 2>&1 | head -n 8 || echo "  nslookup недоступен"
echo '$ dig +short google.com'
dig +short google.com 2>/dev/null || echo "  dig недоступен"
echo '$ curl -o test.html https://example.com'
curl -fsSL --max-time 10 -o test.html https://example.com 2>/dev/null &&
    echo "  файл загружен" || echo "  загрузка недоступна"
echo '$ head -10 test.html'
head -n 10 test.html 2>/dev/null || echo "  файла нет"
echo '$ curl -I https://example.com'
curl -fsSI --max-time 10 https://example.com 2>/dev/null | head -n 8 ||
    echo "  заголовки недоступны"

section "Готово"
echo "Все команды выполнены в каталоге $WORK"
