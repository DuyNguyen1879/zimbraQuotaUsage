#!/bin/bash

###############################################################################
# Script made by M. Rodrigo Monteiro                                          #
# Any bug or request:                                                         #
#   E-mail: falecom@rodrigomonteiro.net                                       #
#   https://github.com/mrodrigom/                                             #
# Use at your own risk                                                        #
#                                                                             #
#                                                                             #
# Instructions:                                                               #
#   ./zimbraQuotaUsageDomain [-h]                                             #
#     -h human readable                                                       #
# Version 0.1 (10/10/2014)                                                    #
#   Begin                                                                     #
###############################################################################

version=0.1

# CHANGE HERE

zmprov="/opt/zimbra/bin/zmprov"
zmhostname="/opt/zimbra/bin/zmhostname"


# DO NOT CHANGE BELOW HERE

unalias rm 2> /dev/null
trap 'rm -f /tmp/$$*' 0 1 2 3 15

"${zmprov}" gqu "$(${zmhostname})" > /tmp/$$-conta
awk '{print $1}' /tmp/$$-conta | cut -d'@' -f2 | sort -u > /tmp/$$-dominio

while read dominio ; do
	grep "@${dominio} " /tmp/$$-conta | awk '{print $3}' > /tmp/$$-valor
	total=0
	while read valor ; do
		total="$(echo "${total} + ${valor}" | bc)"
	done < /tmp/$$-valor

	echo "${dominio} ${total}" >> /tmp/$$-quota
done < /tmp/$$-dominio

sort -n -r -k2 /tmp/$$-quota -o /tmp/$$-quota

case "${1}" in
	-h)
		while read dominio total ; do
			if [ "${total}" -gt 0 -a "${total}" -lt 1024 ] ; then
				total="${total}B"
			elif [ "${total}" -ge 1024 -a "${total}" -lt 1048576 ] ; then
				total="$(echo "scale=2; ${total} / 1024" | bc)KB"
			elif [ "${total}" -ge 1048576 -a "${total}" -lt 1073741824 ] ; then
				total="$(echo "scale=2; ${total} / 1048576" | bc)MB"
			elif [ "${total}" -ge 1073741824 ] ; then
				total="$(echo "scale=2; ${total} / 1073741824" | bc)GB"
			fi
			echo "${dominio} ${total}"
		done < /tmp/$$-quota
	;;
	*)
		cat /tmp/$$-quota
	;;
esac




