#!/bin/bash

# funçao para mostrar as opções ao utilizador
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

# função principal para filtrar, ordenar e mostrar o espaço nas na diretoria dada
spaceCheck() {
    local dir="$1"
    local name="$2"
    local datetime="$3"
    local size="$4"
    local reverse="$5"
    local alpha="$6"
    local limit="$7"

    # converte-se o tempo em segundo para se poder filtrar
    [ -n "$datetime" ] && timestamp=$(date -d "$datetime" +%s)

    # começa-se a construir o comando find para buscar por diretorias e/ou ficheiros,
    # basta alterar o type para f ou adicionar -o -type f se quiser os dois
    local cmd="find '$dir' -type d"

    # começa-se por adicionar ao comando filtro pelo nome, data de maxima modificação e tamanho
    [ -n "$name" ] && cmd="$cmd -name '$name'"
    [ -n "$timestamp" ] && cmd="$cmd -newermt '$datetime'"
    [ -n "$size" ] && cmd="$cmd -size +${size}c"

    # adiciona-se o comando du para exibir os tamanhos das diretorias/ficheiros pos filtros
    cmd="$cmd -exec du -b {} +"

    # ordena-se os resultados
    [ "$alpha" = "true" ] && cmd="$cmd | sort -k 2" 
    [ "$reverse" = "true" ] && cmd="$cmd |sort -k 2 | sort -r"

    # um contador de linhas
    local lineCount=0

    # Executar o comando
    eval "$cmd" | while IFS= read -r line; do # executa-se oo comando montado e redeciona-se a saida para while para ler linha a linha
        ((lineCount++))
        echo "$line"
        [ -n "$limit" ] && [ $lineCount -ge $limit ] && break # se na var limit estiver um valor e este for maior que line_count então o ciclo termina
    done
}

# guarda-se as opções em variaveis 
while getopts "n:t:s:ral:" opt; do
    case $opt in
        n) name="$OPTARG" n="-n $OPTARG" ;;

        t) datetime="$OPTARG" d="-d $OPTARG" ;;

        s) size="$OPTARG" s="-s $OPTARG" ;;

        r) reverse="true" r="-r";;

        a) alpha="true" a="-a";;

        l) limit="$OPTARG" l="-l $OPTARG";;
    esac

done

# remove-se as opções da lista de comandos
shift $((OPTIND - 1))

# verificar se foi dado alguma diretoria
if [ $# -eq 0 ]; then
    showHelp
    exit 1
fi

# printar o titulo
echo "SIZE   NAME" "$(date -d "$datetime" +%s)" "$n" "$d" "$s" "$r" "$a" "$l" "$@"


# executa-se a função para cada diretoria dada
for dir in "$@"; do
    spaceCheck  $pwd$dir "$name" "$datetime" "$size" "$reverse" "$alpha" "$limit"
done
