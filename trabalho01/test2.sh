#!/bin/bash


# Função para mostrar a utilização do espaço
function check_space() {
    local dir=$1
    local name=$2
    local datetime=$3
    local size=$4
    local reverse=$5
    local alpha=$6
    local limit=$7

    # Converter a data e hora fornecidas para o formato de timestamp Unix
    if [ -n "$datetime" ]; then
        timestamp=$(date -d "$datetime" +%s)
    fi

    # Construir o comando find
    local cmd="find $dir -type d -o -type f"
    
    # Adicionar critérios de nome, data e tamanho, se fornecidos
    [ -n "$name" ] && cmd="$cmd -name $name"
    [ -n "$timestamp" ] && cmd="$cmd -newermt @$timestamp"
    [ -n "$size" ] && cmd="$cmd -size +${size}c"

    # Adicionar comando du para calcular o tamanho dos ficheiros encontrados
    cmd="$cmd -exec du -ch {} +"

    # Adicionar comandos sort para ordenar os resultados
    [ "$alpha" = "true" ] && cmd="$cmd | sort"
    [ "$reverse" = "true" ] && cmd="$cmd | sort -r"

    # Adicionar comando head para limitar o número de linhas, se fornecido
    [ -n "$limit" ] && cmd="$cmd | head -$limit"

    # Executar o comando
    eval $cmd
}

# Analisar opções de linha de comando
while getopts "n:t:s:ra:l:" opt; do
  case ${opt} in
    n ) name=$OPTARG;;
    t ) datetime=$OPTARG;;
    s ) size=$OPTARG;;
    r ) reverse=true;;
    a ) alpha=true;;
    l ) limit=$OPTARG;;
  esac
done

# Remover as opções da lista de argumentos
shift $((OPTIND -1))

# Verificar se algum argumento foi fornecido
if [ $# -eq 0 ]; then
  echo "Por favor, forneça uma diretoria como argumento."
  exit 1
fi



# Chamar a função para cada argumento fornecido
for dir in "$@"; do
  check_space $dir $name $date $size $reverse $alpha $limit
done

# Verificar se algum argumento foi fornecido
if [ $# -eq 0 ]; then
    echo "Por favor, forneça uma diretoria como argumento."
    exit 1
fi

# Chamar a função para cada argumento fornecido
for dir in "$@"; do
    check_space $dir
done