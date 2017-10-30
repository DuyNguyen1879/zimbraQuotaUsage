#!/bin/bash

###############################################################################
# Script made by M. Rodrigo Monteiro                                          #
# Any bug or request:                                                         #
#   E-mail: falecom@rodrigomonteiro.net                                       #
#   https://github.com/mrodrigom/                                             #
# Use at your own risk                                                        #
#                                                                             #
# Instructions:                                                               #
#   ./zimbraQuotaUsageDomain [-h]                                             #
#		-h human readable                                                     #
# Version 0.1 (10/10/2014)                                                    #
#   Begin                                                                     #
# Version 0.2 (10/12/2014)                                                    #
#   Added option to view in human readable                                    #
###############################################################################

version=0.2

# CHANGE HERE

zmprov="/opt/zimbra/bin/zmprov"
zmhostname="/opt/zimbra/bin/zmhostname"


# DO NOT CHANGE BELOW HERE

unalias rm 2> /dev/null
trap 'rm -f /tmp/$$' 0 1 2 3 15

"${zmprov}" gqu "$(${zmhostname})" | sort -n -k3 -r > /tmp/$$


while read email quota usage ; do
	case "${1}" in
		-h)
			if [ "${quota}" -gt 0 -a "${quota}" -lt 1024 ] ; then
				quota="${quota}B"
			elif [ "${quota}" -ge 1024 -a "${quota}" -lt 1048576 ] ; then
				quota="$(echo "scale=2; ${quota} / 1024" | bc)KB"
			elif [ "${quota}" -ge 1048576 -a "${quota}" -lt 1073741824 ] ; then
				quota="$(echo "scale=2; ${quota} / 1048576" | bc)MB"
			elif [ "${quota}" -ge 1073741824 ] ; then
				quota="$(echo "scale=2; ${quota} / 1073741824" | bc)GB"
			fi
			
			if [ "${usage}" -gt 0 -a "${usage}" -lt 1024 ] ; then
				usage="${usage}B"
			elif [ "${usage}" -ge 1024 -a "${usage}" -lt 1048576 ] ; then
				usage="$(echo "scale=2; ${usage} / 1024" | bc)KB"
			elif [ "${usage}" -ge 1048576 -a "${usage}" -lt 1073741824 ] ; then
				usage="$(echo "scale=2; ${usage} / 1048576" | bc)MB"
			elif [ "${usage}" -ge 1073741824 ] ; then
				usage="$(echo "scale=2; ${usage} / 1073741824" | bc)GB"
			fi
		;;
		*)
		;;
	esac
	echo "${email} ${quota} ${usage}"
done < /tmp/$$


