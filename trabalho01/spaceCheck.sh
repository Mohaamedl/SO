#!/bin/bash

# Função para mostrar as opções ao usuário
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

# Função principal para filtrar, ordenar e mostrar o espaço nas diretórias dadas
spaceCheck() {
  local dir="$1"
  local name="$2"
  local datetime="$3"
  local size="$4"
  local reverse="$5"
  local alpha="$6"

  # Converter a data em segundos para poder filtrar
  [ -n "$datetime" ] && timestamp=$(date -d "$datetime" +%s)

  # Construir o comando find para buscar por arquivos
  local cmd="find '$dir' -type f"

  # Adicionar ao comando filtro por nome, data de modificação máxima e tamanho
  [ -n "$name" ] && cmd="$cmd -name '$name'"
  [ -n "$timestamp" ] && cmd="$cmd -newermt '$datetime'"
  [ -n "$size" ] && cmd="$cmd -size +${size}c"

  # Adicionar o comando du para exibir os tamanhos dos arquivos após os filtros
  cmd="$cmd -exec du -bs {} +"
  

  # Executar o comando e processar a saída
  eval "$cmd" | awk -v name="$name" '
    BEGIN {
      FS = "\t";
    }
    {
      fileDir = $2;
      sub(/\/[^/]+$/, "", fileDir);  # Obter o diretório pai removendo o nome do arquivo

      # Inicializar os totais para cada diretório
      if (!(fileDir in dirTotals)) {
        dirTotals[fileDir] = 0;
      }

      dirTotals[fileDir] += $1;
    }
    END {
      # Imprimir os totais por diretório
      for (dir in dirTotals) {
        printf "%-10s%s\n", dirTotals[dir], dir;
      }
    }' # ordenar caso tenha sido pedido
}

# Guardar as opções em variáveis
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
sorting="sort -k1,1nr" # ordena por tamanho por padrao
  
  # ordena pelas opçoes
[ "$alpha" = "true" ] && sorting="sort -k 2"
[ "$reverse" = "true" ] && sorting="sort -r"

# Remover as opções da lista de comandos
shift $((OPTIND - 1))

# Verificar se foi fornecida alguma diretoria
if [ $# -eq 0 ]; then
  showHelp
  exit 1
fi

# Printar o título
echo "SIZE      NAME" "$(date -d "$datetime" +%s)" "$n" "$d" "$s" "$r" "$a" "$l" "$@"

# por fim basta executar a funçao por cada diretoria dada
for dir in "$@"; do
  spaceCheck "$dir" "$name" "$datetime" "$size" "$reverse" "$alpha"
done | (if [ -n "$limit" ]; then head -n "$limit"; else cat; fi) | $sorting 
