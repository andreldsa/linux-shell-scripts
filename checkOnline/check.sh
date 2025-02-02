#!/bin/bash
# by André L. Abrantes - Agosto de 2016

TEMP="/tmp/siteCheck.out"

# Imprime as 10 palavras mais frequente do site
function imprime10Mais {
	echo -e ">> Top 10 palavras em $1:"
	tr -c '[:alnum:]' '[\n*]' < $TEMP | sort | uniq -c | sort -nr | head  -10
	echo -e "\n=============================\n"
}

# Varre a lista de sites passados como parâmetro em um arquivo
for site in $(cat $1); do
	codigo=$(curl -I $site 2> /dev/null | head -n 1 | cut -d' ' -f2)
	temp="/tmp/siteCheck.out"
	contains=1
	if [ $2 ]; then # Se existe um segundo parâmetro
		curl $site 2> /dev/null > $TEMP # Armazena o GET request do site
		for palavra in $(cat $2); do # Varre as palavras passadas como parâmetro em um arquivo
			num=$(cat $temp | grep -c -i $palavra) # Faz um grep -c pela palavra buscada
			contains=$(($contains*$num)) # Em caso de 0 palavras encontradas zera o contains
		done
	fi
	if [ $contains -gt 0 ]; then # Se todas as palavras foram encontradas no arquivo
		echo "$site $codigo OK!" # Imprime OK!
	else
		echo -e "$site $codigo" # Imprime default
	fi
	imprime10Mais $site
done
