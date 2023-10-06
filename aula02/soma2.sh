(( $# == 2 )) || { echo -e "Indique dois numeros\n";exit 1; }
echo " $1 + $2 = $(( $1 + $2 ))"
