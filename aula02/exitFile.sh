#!/bin/bash
(( $# < 1 )) && { -e "indique o nome do ficheiro"; }
for i in $*; do { file -E $i ; echo "Exit code: $?"; } done

