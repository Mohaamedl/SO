#!/bin/bash 

 

# Função para exibir a ajuda 

show_help() { 

  echo "Uso: $0 [OPÇÕES] DIRETÓRIOS..." 

  echo "OPÇÕES:" 

  echo "  -n PATTERN  Filtra por nome (expressão regular)" 

  echo "  -d DATE    Filtra por data máxima de modificação" 

  echo "  -s SIZE    Filtra por tamanho mínimo (em bytes)" 

  echo "  -r         Ordena em ordem reversa" 

  echo "  -a         Ordena em ordem alfabética" 

  echo "  -l LIMIT   Limita o número de linhas na saída" 

  exit 1 

} 

 

# Inicialize as variáveis 

NAME_PATTERN=".*" 

DATE="" 

SIZE="" 

REVERSE=false 

ALPHABETICAL=false 

LIMIT="" 

 

# Processa as opções 

while getopts "n:d:s:rahl:" opt; do 

  case $opt in 

    n) NAME_PATTERN="$OPTARG" ;; 

    d) DATE="$OPTARG" ;; 

    s) SIZE="$OPTARG" ;; 

    r) REVERSE=true ;; 

    a) ALPHABETICAL=true ;; 

    l) LIMIT="$OPTARG" ;; 

    h) show_help ;; 

    \?) show_help ;; 

  esac 

done 

shift $((OPTIND-1)) 

 

# Se nenhum diretório for especificado, exiba a ajuda 

if [ $# -eq 0 ]; then 

  show_help 

fi 

 

# Cabeçalho da tabela 

echo "SIZE NAME" 

 

# Loop pelos diretórios 

for dir in "$@"; do 

  if [ -d "$dir" ]; then 

    find "$dir" -type f -name "$NAME_PATTERN" -newermt "$DATE" -size +"$SIZE"c -exec du -ch {} + | grep -E '\d+M|\d+G' | sort -k1,1n | tail -n "$LIMIT" 

  else 

    echo "NA $dir (Diretório inacessível)" 

  fi 

done 
