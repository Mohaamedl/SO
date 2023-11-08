#!/bin/bash 



# Função para comparar o uso do espaço entre dois arquivos spacecheck.sh 
compare_space() { 

    local file1="$1" 

    local file2="$2" 

    local reverse="$3" 

    local alpha="$4" 



    # Extrair os dados relevantes dos arquivos spacecheck.sh 

    local data1=($(awk '{print $1}' "$file1")) 

    local data2=($(awk '{print $1}' "$file2")) 

    local paths1=($(awk '{print $2}' "$file1")) 

    local paths2=($(awk '{print $2}' "$file2")) 



    # Criar uma lista única de todos os caminhos 

    local all_paths=($(echo "${paths1[@]}" "${paths2[@]}" | tr ' ' '\n' | sort -u)) 



    # Loop através dos caminhos e comparar o uso do espaço 

    for path in "${all_paths[@]}"; do
        local idx1=-1 

        local idx2=-1 



        # Encontrar os índices correspondentes para o caminho nos arquivos 

        for i in "${!paths1[@]}"; do 

            if [ "${paths1[i]}" == "$path" ]; then 

                idx1=$i 

                break 

            fi 

        done 



        for i in "${!paths2[@]}"; do 

            if [ "${paths2[i]}" == "$path" ]; then 

                idx2=$i 

                break 

            fi 

        done 



        # Calcular a diferença no uso do espaço 

        local diff=0 

        if [ "$idx1" -ne -1 ] && [ "$idx2" -ne -1 ]; then 

            # Extrair apenas o valor numérico e remover unidades como "K", "M", etc. 

            size1=$(echo "${data1[idx1]}" | tr -d 'A-Za-z') 

            size2=$(echo "${data2[idx2]}" | tr -d 'A-Za-z') 

            # Calcular a diferença 

            diff=$((size2 - size1)) 

        elif [ "$idx1" -ne -1 ]; then 

            size1=$(echo "${data1[idx1]}" | tr -d 'A-Za-z') 

            diff=$((0 - size1)) 

        elif [ "$idx2" -ne -1 ]; then
            size2=$(echo "${data2[idx2]}" | tr -d 'A-Za-z') 

            diff=$((size2 - 0)) 

        fi 



        # Exibir a diferença no uso do espaço, marcando como "NEW" ou "REMOVED" 

        if [ "$diff" -lt 0 ]; then 

            echo "$diff $path REMOVED" 

        elif [ "$diff" -gt 0 ]; then 

            echo "$diff $path NEW" 

        fi 

    done 

} 



# Analisar opções de linha de comando
while getopts "ra" opt; do 

    case $opt in 

        r) reverse="true" ;; 

        a) alpha="true" ;; 

    esac 

done 



# Remover as opções da lista de argumentos
shift $((OPTIND - 1)) 



# Verificar se foram fornecidos dois argumentos (arquivos de resultados do spacecheck.sh)
if [ $# -ne 2 ]; then 

    echo "Por favor, forneça dois arquivos spacecheck.sh para comparação." 

    exit 1 

fi
#Chamar a função para comparar os arquivos
compare_space "$1" "$2" "$reverse" "$alpha"