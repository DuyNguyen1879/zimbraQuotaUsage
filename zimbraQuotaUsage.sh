#!/bin/bash
###############################################################################
# Script made by M. Rodrigo Monteiro                                          #
# Any bug or request, below is my blog and mail                               #
# http://www.rodrigomonteiro.net/blog/                                        #
# E-mail: falecom@rodrigomonteiro.net                                         #
# https://github.com/mrodrigom/zimbraBackup                                   #
# Use at your own risk                                                        #
#                                                                             #
# Instructions:                                                               #
#   Just run the script                                                       #
# Version 0.1 (10/10/2014)                                                    #
#   Begin                                                                     #
###############################################################################

version=0.1

# CHANGE HERE

zmprov="/opt/zimbra/bin/zmprov"
zmhostname="/opt/zimbra/bin/zmhostname"


# DO NOT CHANGE BELOW HERE

unalias rm 2> /dev/null
trap 'rm -f /tmp/$$' 0 1 2 3 15

"${zmprov}" gqu "$(${zmhostname})" | sort -n -k3 -r > /tmp/$$

while read email quota usage ; do
	if [ "${usage}" -gt 0 -a "${usage}" -le 1024 ] ; then
		usage="${usage}B"
	elif [ "${usage}" -gt 1024 -a "${usage}" -le 1048576 ] ; then
		usage="$(expr "${usage}" / 1024)KB"
	elif [ "${usage}" -gt 1048576 -a "${usage}" -le 1073741824 ] ; then
		usage="$(expr "${usage}" / 1048576)MB"
	elif [ "${usage}" -gt 1073741824 ] ; then
		usage="$(expr "${usage}" / 1073741824)GB"
	fi
	echo "${email} ${quota} ${usage}"
done < /tmp/$$

rm -f /tmp/$$
