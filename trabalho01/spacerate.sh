#!/bin/bash

# verifica se foram dados dois argumentos
if [ $# -lt 2 ] || [ $# -gt 3 ]; then
    echo "É necessário fornecer dois ou três argumentos"
    exit 1
fi

option=$1
file1=$2
file2=$3

if [ $# -eq 2 ]; then
    file1=$1
    file2=$2
fi

# retira o tamanho e o diretório correspondente em cada linha
# declara o valor size à chave diretório no array size_file1 e guarda na variável file1
declare -A sizesFile1
output=""
while IFS= read -r line || [[ -n "$line" ]]; do
    if [[ "$line" =~ ^SIZE\ NAME.* ]] || [[ -z "$line" ]]; then
        continue
    fi
    dir=$(echo "$line" | awk '{print $2}')
    size=$(echo "$line" | awk '{print $1}')
    sizesFile1["$dir"]=$size
done < "$file1"

# repetição para file2
declare -A sizesFile2
while IFS= read -r line || [[ -n "$line" ]]; do
    if [[ "$line" =~ ^SIZE\ NAME.* ]] || [[ -z "$line" ]]; then
        continue
    fi
    dir=$(echo "$line" | awk '{print $2}')
    size=$(echo "$line" | awk '{print $1}')
    sizesFile2["$dir"]=$size
done < "$file2"

# caso não exista diretório no file 1 , será mostrado novo diretório NEW e o seu tamanho
for dir in "${!sizesFile2[@]}"; do
    if [[ ! ${sizesFile1[$dir]} ]]; then
        output+="${sizesFile2[$dir]} $dir NEW"
        unset sizesFile2["$dir"]
        if [[ ${#sizesFile2[@]} -gt 0 ]]; then
            output+="\n"
        fi
    fi
done

# caso não exista diretório no file 2 , será mostrado antigo diretório REMOVED e o tamanho apagado
for dir in "${!sizesFile1[@]}"; do
    if [[ ! ${sizesFile2[$dir]} ]]; then
        output+="-${sizesFile1[$dir]} $dir REMOVED"
        unset sizesFile1["$dir"]
        if [[ ${#sizesFile1[@]} -gt 0 ]]; then
            output+="\n"
        fi
    fi
done

# caso exista o diretório em ambos os ficheiros calcula diferença dos tamanhos 
for dir in "${!sizesFile1[@]}"; do
    if [[ ${sizesFile2[$dir]} ]]; then
        diff=$((sizesFile2[$dir] - sizesFile1[$dir]))
        output+="$diff $dir"
        unset sizesFile1["$dir"]
        unset sizesFile2["$dir"]
        if [[ ${#sizesFile1[@]} -gt 0 ]]; then
            output+="\n"
        fi
    fi
done

# ordena a saída conforme a opção fornecida
echo "SIZE NAME"
if [ "$option" == "-r" ]; then
    echo -e "$output" | sort -k1,1n
elif [ "$option" == "-a" ]; then
    echo -e "$output" | sort -k2,2
else
    echo -e "$output" | sort -k1,1nr
fi