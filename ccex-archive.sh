#!/bin/bash

# download https://c-cex.com/?id=h&arch=1
# and supply the HTML file as the argument to this script.

table=`sed -n '/<div class="block2">/,/div/p' "$1"\
	| grep -E '<tr>|</td>'\
	| sed -e 's,</tr>,,g' -e 's,<td>,,g' -e 's,</td>,,g'\
	| tr '\n' ','\
	| sed -e 's/<tr>,/\n/g' -e 's/,\n/\n/g' -e 's/,$//g'\
`
while IFS='' read -r line
do
	if [[ $line = *"Deposit"* ]]
	then
		line=`sed -e 's,<td.*>.*(,,' -e 's,),,' <<< $line`
	elif [[ $line = *"Withdrawal"* ]]
	then
		line=`sed -e 's,<td.*>.*to ,,' <<< $line`
	else
		line=`sed -e 's/<td.*$//' <<< $line`
	fi
	line=`sed -e 's/ /,/3' -e 's/ /,/2' <<< $line`
	if [[ $line = "Date/time,Type,In,Out,Info" ]]
	then
		line="Date/time,Type,In,In-Currency,Out,Out-Currency,Info"
	fi
	echo $line
done <<< "$table"
