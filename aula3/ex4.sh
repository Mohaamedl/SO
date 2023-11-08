space=$(df -h | awk '{print $5}' | grep % | grep -v Use | sort -n | tail -1 | cut -d "%" -f1)
echo "largest occupied space = $space%"
case $space in
	[0-9]|[1-6]?)
		Message="All ok"
		;;
	[7-8]?)
		Message="bb"
		;;

esac
echo $Message

