#!/bin/bash

BLINK="\033[5m"
BBLINK="\033[25m"
RED="\033[37m"
GREEN="\033[32m"
BLUE="\033[38m"
WHITE="\033[34m"
BROWN="\033[33m"
END="\033[0m"
YELLOW="\033[93m"

function line(){
	echo ""
	local symbol=$1
	local count=$2
	count=${count:-"80"}
	symbol=${symbol:-"="}
	local i=0

	for (( i=0;i<count;i++  ))
	do
		printf "$symbol"
	done
	echo ""
}

message(){
	local i=0
	local M
	M="By using this script/tool you aggree that you will not use it for malicious purposes under any circumstance.
	1. DON'T use this tool/script for CRACKING.
	2. DON'T use this tool/script for DESTROYING someone's PRIVACY.
	3. DON'T use this tool/script against GOVERNMENT WEBSITES, SERVERS OR ANY INTERNET RELATED SERVICES.
	4. DON'T use this tool/script against PEOPLE OR PERSON(S), WITHOUT INFORMING THEM.

	USE THIS TOOL/SCRIPT ETHICALLY...
	
	Live Healthy, Live Wealthy ;)"

	
	echo -e "${WHITE}"
	for (( i=0;i<${#M};i++  ))
	do
		c=${M:$i:1}
		printf "$c"
		if [ "$c" == " " ];then
			sleep 0.09
		else
			sleep 0.05
		fi
	done
	echo -e "${END}${YELLOW}"
	echo "														-Spectre"
	echo -e "${END}"
	echo "Starting Please Wait....."
	sleep 3
}


trap 'echo -e "${RED}Terminating";sleep 1;exit 127' SIGINT
function usage(){
	echo -e "${GREEN}Usage:${END} "
	echo " $0 [OPTIONS]:"
	echo "-h* : ipaddress  "
	echo "-c* : code"
	echo "      HINT :-  4 is NMAP scan, 2 is Directory bruteforce and 1 is Nikto scan.     "
	echo " 	       code = SUM of scan the to perform"
	echo ""
	echo "      EXAMPLE :- code = 7 , for full scan. Code is 3 for DBce and Nikto Scan and Code is 1 for Just Nmap scan"
	echo "-p* : port number"
      	echo "NOTE: * requires arguments to be passsed"
	line
}


if [ $# -lt 1 ]
then 
	usage
	exit 0
fi

#========================================================STARTING THE MAIN SCRIPT==========================================

#=======================ARGUMENT CHECKING==============================


message

line 


echo -e "${RED}======================================${YELLOW}FOOTPRINT.sh${RED}==========================================="
echo -e "${BROWN}Author:${WHITE}${BLINK}SPECTRE ${BBLINK}"
echo -e "${RED}======================================}${YELLOW}FOOTPRINT.sh${RED}==========================================="


#COLOR CODES=======================

#DEFAULT VALUES IF PARAMETERS IS NOT PASSED
COUNT=0
HOST="127.0.0.1"
PORT="80"
CODE="7"
STATUS=0
while (( "$#" ))
do
	if [ "${1:0:1}" == "-" ]
	then
		case $1 in
			"-u"	)shift; HOST=$1; STATUS=1	;;
			
			"-c"	)shift; CODE=$1			;;
				
			"-p"	)shift; PORT=$1			;;

			*	)printf "${RED}INVALID PARAMETER:${END}$1\n" ; 
				 usage
				 line
				 exit 1				;;
		esac

	else
		shift;
	
	fi
	
done	

#=======checking if HOST parameter is passed

if [ $STATUS -ne 1 ]
then
	echo -e "${RED}HOST NAME NOT PASSED! RUN AGAIN BY PASSING:${WHITE} -u IPADDRESS $END "
	line
	exit 3
fi

STAT=true

if [ $UID -ne 0 ]
then
	echo -e "${BROWN}[+] ${END}You are not root so some lookups and  scans will not be done. Run as sudo for safe scans(SYN)."
	STAT=false; echo ""
fi
#=====================================================================================================================







#=====================================================================================================================
echo -e "${YELLOW}DETAILS:${END}"
line "-" 70
printf  "${WHITE}"
echo "DATE : `date +%F`"; 
echo "TIME : `date +"%T"`"
echo "HOST : $HOST"
echo "PORT : $PORT"
echo "CODE : $CODE"
printf "${END}"

#=======================================================#################################################

(ping -c 1 -W 5  $HOST  1>/dev/null 2>/dev/null;) #CHECKING THE STATUS OF THE HOST
STATUS=$?
if [ $STATUS -ne 0 ]
then	
	if [ $STATUS -eq  1 ]
	then
		echo -e " ${RED}ERROR: ${WHITE}Connection request timed out! NO REPLY FROM HOST [${HOST}]${END}"; 
		line
		exit 1
	elif [ $STATUS -eq 2 ]
	then
		echo -e " ${RED}ERROR: ${WHITE}Invalid host name [${HOST}]${END}"; 

		line 
		exit 2
	else
		echo -e  "${RED}ERROR : ${WHITE}Invalid Host [$HOST]${END}  "
		line                                                                   		
		usage
		exit 2
	fi
fi






#=================================================FUNCTION FOR NMAP SCAN===============================

function NMAP(){
	line '-' 80
	#MAIN NMAP SCAN==============================================
	if [ $STAT ] #==IF USER IS ROOT THEN
	then
		echo -e "${YELLOW}Nmap NORMAL SCAN ${END}${WHITE}"
		echo ""
		(nmap -Pn ${IPADDRESS})
	else
		echo -e  "${YELLOW}Nmap AGRESSIVE SCAN ${END} ${WHITE}"
		echo ""
		(nmap -Pn -A  ${IPADDRESS})
	fi

	
}

#=============================================ENDS HERE================================================
IPADDRESS=$HOST
#=============================CONVERTING DOMAIN NAME TO IPADDRESS FOR PREVENTING ERRORS=====================
function MAPPER(){
	line "-" 80
	if [[ ${IPADDRESS:0:1} != [1-9] ]]
	then
		IPADDRESS=$"`host -4 ${HOST} | grep -m 1 "address" | awk '{print $4}'`"
	    echo -e "${GREEN}[+]${WHITE}The DOMAIN name : ${BROWN}${HOST} ${WHITE}has been resolved to :${BROWN} ${IPADDRESS}  ${END}"
	fi
}

DOMAIN=${HOST:4:${#HOST}} #FINDING THE CORRECT DOMAIN NAME FOR DNSENUM========================


#=================================================================nslookup UTILITY=====================================
NSLOOKUP(){
line "-" 80
	printf "\n${YELLOW}NSLOOKUP:\n\n"
	echo -e "${WHITE}IPADDRESS ADDRESS: ${IPADDRESS}"

	printf   "\n(`nslookup ${IPADDRESS}`)"
	echo -e "${END}"
	sleep 2
}


#===============================================================TRACEROUTE UTILITY======================================
TRACEROUTE(){
line "-" 80
	printf "\n${YELLOW}TRACEROUTE:\n\n"
	echo -e "${WHITE}IPADDRESS ADDRESS: ${IPADDRESS}"
	echo ""
	if [ $UID -eq 0 ]
	then
		printf "(`traceroute -4 -T ${IPADDRESS}`)"
	else
		printf "(` traceroute -4 ${IPADDRESS} `)"
	fi
	echo -e "${END}"
}
#==================================================================DNSENUM==========================================
DNSENUM(){
line "-" 80
	printf "\n${YELLOW}DNSENUM:\n\n"
	echo -e "${WHITE}IPADDRESS DOMAIN: ${DOMAIN}"
	echo ""
	printf "(`dnsenum ${DOMAIN}`)"
	echo -e "${END}"
}

#===========================================================NIKTO SCAN=============================================
NIKTO(){
	printf "\n${YELLOW}NIKTO SCAN:\n\n"
	echo -e "${WHITE}TARGET ADDRESS: ${IPADDRESS}"
	echo ""
	printf "(`nikto -host ${IPADDRESS} -port ${PORT} -Display on `)"
	echo -e "${END}"
}
#=================================================STARTING SCRIPT===========================================

MAPPER
TRACEROUTE
NSLOOKUP
DNSENUM
NMAP
NIKTO




#=====================================END OF SCRIPT==============
line

sleep 2
