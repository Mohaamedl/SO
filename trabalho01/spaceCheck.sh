#!/bin/bash
#----------------------------- funçoes --------------------------------------
# funçao para mostrar as opçoes
showHelp() {
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

# funçao principal para filtrar por cada diretoria
spaceCheck() {
    local dir="$1"
    local name="$2"
    local datetime="$3"
    local size="$4"
    # convertemos data para segundos
    [ -n "$datetime" ] && timestamp=$(date -d "$datetime" +%s)

    # começamos por contruir o comando com find
    local cmd="find '$dir' -type f"

    # filtramos por nome, tamanho e data de modificaçao/criaçao
    [ -n "$name" ] && cmd="$cmd -name '$name'"
    [ -n "$timestamp" ] && cmd="$cmd -newermt '$datetime'"
    [ -n "$size" ] && cmd="$cmd -size +${size}b"

    # usamos du para mostrar os tamanhos em bytes
    cmd="$cmd -exec du -bs {} +"
    
    # executamos o comando e tratamos a saida
    eval "$cmd" | awk -v name="$name" '
      BEGIN {
        FS = "\t";
      }
      {
        fileDir = $2;
        sub(/\/[^/]+$/, "", fileDir);  # obtemos a diretoria
        
        if (!(fileDir in dirTotals)) { # iniciamos um total vazio por cada diretoria diferente
          dirTotals[fileDir] = 0;
        }
        dirTotals[fileDir] += $1;
      }
      END {
        # imorimimos o total de cada diretoria, com espaçamento fixo
        for (dir in dirTotals) {
          printf "%-10s%s\n", dirTotals[dir], dir;
        }
      }'
}


#-------------------------- main-------------------------------


# começamos por guardar as opçoes em variaveis
while getopts "n:d:s:ral:" opt; do
  case $opt in
    n) name="$OPTARG" n="-n $OPTARG" ;;
    d) datetime="$OPTARG" d="-d $OPTARG" ;;
    s) size="$OPTARG" s="-s $OPTARG" ;;
    r) reverse="true" r="-r" ;;
    a) alpha="true" a="-a" ;;
    l) limit="$OPTARG" l="-l $OPTARG" ;;
  esac
done
sorting="sort -k1,1nr" # varivel para ordenar por tamanho (por padrao)
  
# ordena pelas opçoes
[ "$alpha" = "true" ] && sorting="sort -k2,2"
[ "$reverse" = "true" ] && sorting="sort -k2,2r"

# removemos as opçoes
shift $((OPTIND - 1))

# verificamos se foi dado algum argumento, no caso, diretoria
if [ $# -eq 0 ]; then
  showHelp
  exit 1
fi

# mostra-se o titulo
echo "SIZE      NAME" "$(date -d "$datetime" +%s)" "$n" "$d" "$s" "$r" "$a" "$l" "$@"

# por fim basta executar a funçao por cada diretoria dada, e ao resultado limitar as linhas e ordenar se for pedido
for dir in "$@"; do
  spaceCheck "$dir" "$name" "$datetime" "$size" 
done | (if [ -n "$limit" ]; then head -n "$limit"; else cat; fi) | $sorting 
