#!/bin/bash
# vamos verificar se o numero dado é menor que 10 e maior que 5
if (( $1 >=5 && $1<=10 )) ; then
	echo "o numero $1  está no intervalo"
else
	echo "o numero $1 nao esta no invalo"
fi
