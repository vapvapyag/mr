#!/bin/bash
# Bot Marlboro Coded By Achon666ju5t - Demeter16
GREEN='\e[38;5;82m'
CYAN='\e[38;5;39m'
RED='\e[38;5;196m'
YELLOW='\e[93m'
PING='\e[38;5;198m'
BLUE='\033[0;34m'
NC='\033[0m'
BLINK='\e[5m'
HIDDEN='\e[8m'
header(){
printf "${GREEN}"
printf "     ___        __                _____ _____ _____   _       ________    \n"
printf "    /   | _____/ /_  ____  ____  / ___// ___// ___/  (_)_  __/ ____/ /_   \n"
printf "   / /| |/ ___/ __ \/ __ \/ __ \/ __ \/ __ \/ __ \  / / / / /___ \/ __/   \n"
printf "  / ___ / /__/ / / / /_/ / / / / /_/ / /_/ / /_/ / / / /_/ /___/ / /_     \n"
printf " /_/  |_\___/_/ /_/\____/_/ /_/\____/\____/\____/_/ /\__,_/_____/\__/     \n"
printf "=========Cek Voucher Aldmic====================/___/======================\n"
}
echo -n 'Started at: '
date +%R
function login(){
	curl -s -X POST --compressed \
	--url 'https://www.marlboro.id/auth/login?ref_uri=/profile'\
	-H 'Accept-Language: en-US,en;q=0.9' \
	-H 'Connection: keep-alive' \
	-H 'Content-Type: application/x-www-form-urlencoded; charset=UTF-8' \
	-H 'Host: www.marlboro.id' \
	-H 'Origin: https://www.marlboro.id' \
	-H 'Referer: https://www.marlboro.id/' \
	-H 'User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/72.0.3626.119 Safari/537.36' \
	-H 'X-Requested-With: XMLHttpRequest' \
	--data-urlencode 'email='$1'' \
	--data-urlencode 'password='$2''\
	--data-urlencode 'decide_csrf='$3'' \
	--data-urlencode 'ref_uri=%252Fprofile0' \
	--cookie-jar $cok -b $cok
}
function get_csrf(){
	curl -s 'https://www.marlboro.id/auth/login?ref_uri=/profile' --cookie-jar $cok | grep -Po "(?<=name\=\"decide_csrf\" value\=\").*?(?=\" />)" | head -1
}
function my-voucher(){
	curl -s 'https://www.marlboro.id/aldmic/my-voucher?_='$(date +%s)'' -b $cok --cookie-jar $cok
}
list=$(grep -lr '@')
y=$(gawk -F: '{ print $1 }' $list)
x=$(gawk -F: '{ print $2 }' $list)
IFS=$'\r\n' GLOBIGNORE='*' command eval  'email=($y)'
IFS=$'\r\n' GLOBIGNORE='*' command eval  'passw=($x)'
for ((i=0;i<"10";i++)); do
	user="n@achonk-just.com"
	cok="${user}$(cat /dev/urandom | tr -dc a-z | fold -w 10 | head -1).txt"
	pw="3xcr3w-ID123"
	csrf=`get_csrf`
	login $user $pw $csrf &> /dev/null
	v=$(my-voucher | jq .data.url | tr -d \")
	if [[ "$v" != 'null' ]]; then
		clear
		header
		curl -s $v -b $cok -c $cok \
		-H 'Origin: https://www.marlboro.id' \
		-H 'Referer: https://www.marlboro.id/' -L &> /dev/null
		for ((d=0;d<"10";d++)); do
			list_voucher=$(curl -s -b $cok -c $cok 'https://loyalty.aldmic.com/catalog/'$d)
			nama_vouchers=$(echo "$list_voucher" | grep -Po "(?<=\<h4>).*?(?=\</h4>)")
			link_voucher=$(echo "$list_voucher" | grep -Po "(?<=\<a data-href=\").*?(?=\")")
			IFS=$'\r\n' GLOBIGNORE='*' command eval  'nv=($nama_vouchers)'
			IFS=$'\r\n' GLOBIGNORE='*' command eval  'lv=($link_voucher)'
			for ((i=0;i<"${#nv[@]}";i++)); do
				link="${lv[$i]}"
				nama="${nv[$i]}"
				ps="${pr[$i]}"
				if [[ "$link" == '#' ]]; then
					echo -e "${RED}$nama ${YELLOW}| ${RED}Out Of Stock ${NC}"
				else
					echo -e "${YELLOW}$nama | ${CYAN}$link${NC}"
				fi
			done
		done
			break
	else
		echo -e "${RED}[!] Cannot Get Session [!][+]${YELLOW} Try Again[+]${NC}"
		continue
	fi
	rm $cok
done
wait
