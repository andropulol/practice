#!/bin/bash
# Практика «Вычисления в Bash» — счётчик разными способами.

tick=0

tick=$((tick + 1))
echo "После прибавления единицы: $tick"

(( tick++ ))
echo "После tick++:              $tick"

(( tick += 5 ))
echo "После tick += 5:           $tick"

(( tick *= 2 ))
echo "После tick *= 2:           $tick"

tick=$((tick - 3))
echo "После вычитания трёх:      $tick"
