#!/bin/bash

# All right reserved to C-SOTERIA ltd.
# This script purpose is to scan entire network segment for first reconissance.
# You may use or alter the script as your need.
# C-SOTERIA is not resposniable for any misuse of the script, 
#   ${red}       Red color for the shell
#   ${green}     Green color for the shell
#   ${Yellow}    Yellow color for the shell
#   ${reset}     Reset the color for the shell


red=`tput setaf 1`
green=`tput setaf 2`
Yellow=`tput setaf 3`
reset=`tput sgr0`

if [ ! -d "/root/AutoScan" ]; then
		echo "${red}[+] Create dir /root/AutoScan"
        mkdir /root/AutoScan
fi
cd ~/AutoScan
echo "${Yellow}[+] get list of host to file hosts"
# Change IP address subnet as needed
nmap -sn -n 10.11.1.118-254 | grep for | cut -f 5 -d ' ' > hosts;
echo "${green}[+] Done!";

for host in $(cat hosts); do echo "${Yellow}[+] Start scan host $host";
smbflag=0
# Get two last ocatate of the IP, create folder and insert the scan files inside

IFS='. ' read -r -a LastIP <<< "$host"; 
if [ ! -d "${LastIP[2]}.${LastIP[3]}" ]; then
		echo "${red}[+] Create dir ${LastIP[2]}.${LastIP[3]}"
        mkdir "${LastIP[2]}.${LastIP[3]}";
fi				    
echo "${green}[+] Result to this machine will be located in folder -  /root/AutoScan/${LastIP[2]}.${LastIP[3]}";
echo "${Yellow}[+] Start nmap scan...${reset}";
nmap -sV -p 0-10000 -A --open -oN ${LastIP[2]}.${LastIP[3]}/nmapScan.txt $host;
cat ${LastIP[2]}.${LastIP[3]}/nmapScan.txt | grep open | grep -v "scan initiated" | grep -v "Warning"  | cut -f 1 -d / > ${LastIP[2]}.${LastIP[3]}/openPorts.txt ;

echo "${green}[+] Nmap finish! two file has created.";
echo "${red}[+] NmapScan.txt";
echo "${red}[+] openPorts";
echo "${Yellow}[+] Start the program enum4linux!${reset}";
enum4linux -a $host >> ${LastIP[2]}.${LastIP[3]}/enum4linux.txt; 
echo "${green}[+] finish scan with program enum4linux";
echo "${Yellow}[+] Get port list from Nmap result";
echo "${green}[+] Done!";

for port in $(cat ${LastIP[2]}.${LastIP[3]}/openPorts.txt); do echo "${Yellow}[+] The next port is: $port";
if [ $port -eq 80 ]; then
echo "${Yellow}[+] Start scan port 80"
echo "${Yellow}Nikto scan will start now...${reset}"
nikto -h http://$host -o ${LastIP[2]}.${LastIP[3]}/NiktoScan.txt
echo "${green}[+] Nikto scan has finished"
echo "${Yellow}[+] Starting dirb scan${reset}"
dirb http://$host -o ${LastIP[2]}.${LastIP[3]}/DirbScan.txt
echo "${green}[+] dirb scan has finished"
echo "${Yellow}[+] Get list of password string by CEWL${reset}"
cewl -w ${LastIP[2]}.${LastIP[3]}/CewlPassWord.txt http://$host
echo "${green}[+] CEWL has finished the scan -- may be false positive without the right path"
echo "${Yellow}[+] Start scan the following NSE Script -- http-apache-server-status.nse${reset}"
nmap -p 80  --script="http-apache-server-status.nse" -oN ${LastIP[2]}.${LastIP[3]}/http-apache-server-status.txt $host
echo "${green}[+] The scan of -- http-apache-server-status.nse -- Done!"
echo "${Yellow}[+] Start scan the following NSE Script -- http-auth.nse${reset}"
nmap -p 80  --script="http-auth.nse" -oN ${LastIP[2]}.${LastIP[3]}/http-auth.txt $host
echo "${green}[+] The scan of -- http-auth.nse -- Done!"
echo "${Yellow}[+] Start scan the following NSE Script -- http-brute.nse${reset}"
nmap -p 80  --script="http-brute.nse" -oN ${LastIP[2]}.${LastIP[3]}/http-brute.txt $host
echo "${green}[+] The scan of -- http-brute.nse -- Done!"
echo "${Yellow}[+] Start scan the following NSE Script -- http-comments-displayer.nse${reset}"
nmap -p 80  --script="http-comments-displayer.nse" -oN ${LastIP[2]}.${LastIP[3]}/http-comments-displayer.txt $host
echo "${green}[+] The scan of -- http-comments-displayer.nse -- Done!"
echo "${Yellow}[+] Start scan the following NSE Script -- http-default-accounts.nse${reset}"
nmap -p 80  --script="http-default-accounts.nse" -oN ${LastIP[2]}.${LastIP[3]}/http-default-accounts.txt $host
echo "${green}[+] The scan of -- http-default-accounts.nse -- Done!"
echo "${Yellow}[+] Start scan the following NSE Script -- http-phpmyadmin-dir-traversal.nse${reset}"
nmap -p 80  --script="http-phpmyadmin-dir-traversal.nse" -oN ${LastIP[2]}.${LastIP[3]}/http-phpmyadmin-dir-traversal.txt $host
echo "${green}[+] The scan of -- http-phpmyadmin-dir-traversal.nse -- Done!"
echo "${Yellow}[+] Start scan the following NSE Script -- http-robots.txt.nse${reset}"
nmap -p 80  --script="http-robots.txt.nse" -oN ${LastIP[2]}.${LastIP[3]}/http-robots.txt $host
echo "${green}[+] The scan of -- http-robots.txt.nse -- Done!"
echo "${Yellow}[+] Start scan the following NSE Script -- http-vuln*"
nmap -p 80  --script="http-vuln*" -oN ${LastIP[2]}.${LastIP[3]}/http-vuln.txt $host
echo "${green}[+] The scan of -- http-vuln* -- Done!"
echo "${Yellow}[+] Start scan the following NSE Script -- http-wordpress-enum.nse${reset}"
nmap -p 80  --script="http-wordpress-enum.nse" -oN ${LastIP[2]}.${LastIP[3]}/http-wordpress-enum.txt $host
echo "${green}[+] The scan of -- http-wordpress-enum.nse -- Done!${reset}"
echo "${Yellow}[+] Start scan the following NSE Script -- http-enum.nse"
nmap -p 80  --script="http-enum.nse" -oN ${LastIP[2]}.${LastIP[3]}/http-enum.nse $host
echo "${green}[+] The scan of -- http-enum.nse -- Done!"
fi
http-enum.nse

if [ $port -eq 21 ]; then
echo "${Yellow}[+] Start scan port 21"
echo "${Yellow}[+] Start scan the following NSE Script -- ftp${reset}"
nmap -p 21  --script="ftp*" -oN ${LastIP[2]}.${LastIP[3]}/ftp.txt $host
echo "${green}[+] The scan of -- ftp-- Done!"

fi

if [ $port -eq 22 ]; then
echo "${Yellow}[+] Start scan port 22"
echo "${Yellow}[+] Start scan the following NSE Script -- ssh-brute.nse${reset}"
nmap -p 22  --script="ssh-brute.nse" -oN ${LastIP[2]}.${LastIP[3]}/ssh-brute.txt $host
echo "${green}[+] The scan of -- ssh-brute.nse -- Done!"
echo "${Yellow}[+] Start scan the following NSE Script -- ssh-run.nse${reset}"
nmap -p 22  --script="ssh-run.nse" -oN ${LastIP[2]}.${LastIP[3]}/ssh-run.txt $host
echo "${green}[+] The scan of -- ssh-run.nse -- Done!"
fi
if [ $port -eq 25 ]; then
echo "${Yellow}[+] Start scan port 25${reset}"
smtp-user-enum  -M VRFY -U -t $host
echo "${Yellow}[+] Start scan the following NSE Script -- smtp-brute.nse${reset}"
nmap -p 25 --script="smtp-brute.nse" -oN ${LastIP[2]}.${LastIP[3]}/smtp-brute.txt $host
echo "${green}[+] The scan of -- smtp-brute.nse -- Done!"
echo "${Yellow}[+] Start scan the following NSE Script -- smtp-vuln-cve2010-4344.nse${reset}"
nmap -p 25 --script="smtp-vuln-cve2010-4344.nse" -oN ${LastIP[2]}.${LastIP[3]}/smtp-vuln-cve2010-4344.txt $host
echo "${green}[+] The scan of -- smtp-vuln-cve2010-4344.nse -- Done!"
echo "${Yellow}[+] Start scan the following NSE Script -- smtp-vuln-cve2011-1720.nse${reset}"
nmap -p 25 --script="smtp-vuln-cve2011-1720.nse" -oN ${LastIP[2]}.${LastIP[3]}/smtp-vuln-cve2011-1720.txt $host
echo "${green}[+] The scan of -- smtp-vuln-cve2011-1720.nse -- Done!"
echo "${Yellow}[+] Start scan the following NSE Script -- smtp-vuln-cve2011-1764.nse${reset}"
nmap -p 25 --script="smtp-vuln-cve2011-1764.nse" -oN ${LastIP[2]}.${LastIP[3]}/smtp-vuln-cve2011-1764.txt $host
echo "${green}[+] The scan of -- smtp-vuln-cve2011-1764.nse -- Done!"
fi
if [ $port -eq 3389 ]; then
echo "${Yellow}[+] Start scan port 3389"
echo "${Yellow}[+] Start scan the following NSE Script -- rdp-enum-encryption.nse${reset}"
nmap -p 3389  --script="rdp-enum-encryption.nse" -oN ${LastIP[2]}.${LastIP[3]}/rdp-enum-encryption.txt $host
echo "${green}[+] The scan of -- rdp-enum-encryption.nse -- Done!${reset}"

echo "${Yellow}[+] Start scan the following NSE Script -- rdp-vuln-ms12-020.nse${reset}"
nmap -p 3389  --script="rdp-vuln-ms12-020.nse" -oN ${LastIP[2]}.${LastIP[3]}/rdp-vuln-ms12-020.txt $host
echo "${green}[+] The scan of -- rdp-vuln-ms12-020.nse -- Done!${reset}"

fi
if [ $port -eq 110 ]; then
echo "${Yellow}[+] Start scan port 110"
echo "${Yellow}[+] Start scan the following NSE Script -- pop3-brute.nse${reset}"
nmap -p 110  --script="pop3-brute.nse" -oN ${LastIP[2]}.${LastIP[3]}/pop3-brute.txt $host
echo "${green}[+] The scan of -- pop3-brute.nse -- Done!${reset}"
echo "${Yellow}[+] Start scan the following NSE Script -- pop3-capabilities.nse${reset}"
nmap -p 110  --script="pop3-capabilities.nse" -oN ${LastIP[2]}.${LastIP[3]}/pop3-capabilities.txt $host
echo "${green}[+] The scan of -- pop3-capabilities.nse -- Done!"
echo "${Yellow}[+] Start scan the following NSE Script -- pop3-ntlm-info.nse${reset}"
nmap -p 110  --script="pop3-ntlm-info.nse" -oN ${LastIP[2]}.${LastIP[3]}/pop3-ntlm-info.txt $host
echo "${green}[+] The scan of -- pop3-ntlm-info.nse -- Done!"
fi
if [ $port -eq 445 ]; then
if [ $smbflag -eq 0 ]; then
smbflag=1
echo "${Yellow}[+] Start scan port 445"
echo "${Yellow}[+] Start scan the following NSE Script -- smb-psexec.nse${reset}"
nmap -p 445  --script="smb-psexec.nse" -oN ${LastIP[2]}.${LastIP[3]}/smb-psexec.txt $host
echo "${green}[+] The scan of -- smb-psexec.nse -- Done!"
echo "${Yellow}[+] Start scan the following NSE Script -- smb-brute.nse${reset}"
nmap -p 445  --script="smb-brute.nse" -oN ${LastIP[2]}.${LastIP[3]}/smb-brute.txt $host
echo "${green}[+] The scan of -- smb-brute.nse -- Done!"
echo "${Yellow}[+] Start scan the following NSE Script -- smb-enum-processes.nse${reset}"
nmap -p 445  --script="smb-enum-processes.nse" -oN ${LastIP[2]}.${LastIP[3]}/smb-enum-processes.txt $host
echo "${green}[+] The scan of -- smb-enum-processes.nse -- Done!"
echo "${Yellow}[+] Start scan the following NSE Script -- smb-enum-shares.nse${reset}"
nmap -p 445  --script="smb-enum-shares.nse" -oN ${LastIP[2]}.${LastIP[3]}/smb-enum-shares.txt $host
echo "${green}[+] The scan of -- smb-enum-shares.nse -- Done!"
echo "${Yellow}[+] Start scan the following NSE Script -- smb-enum-users.nse${reset}"
nmap -p 445  --script="smb-enum-users.nse" -oN ${LastIP[2]}.${LastIP[3]}/smb-enum-users.txt $host
echo "${green}[+] The scan of -- smb-enum-users.nse -- Done!"
echo "${Yellow}[+] Start scan the following NSE Script -- smb-os-discovery.nse${reset}"
nmap -p 445  --script="smb-os-discovery.nse" -oN ${LastIP[2]}.${LastIP[3]}/smb-os-discovery.txt $host
echo "${green}[+] The scan of -- smb-os-discovery.nse -- Done!"
echo "${Yellow}[+] Start scan the following NSE Script -- smb-vuln-*${reset} "
nmap -p 445  --script="smb-vuln-*" -oN ${LastIP[2]}.${LastIP[3]}/smb-vuln.txt $host
echo "${green}[+] The scan of -- smb-vuln-* -- Done!${reset}"
fi
fi
if [ $port -eq 139 ]; then
if [ $smbflag -eq 0 ]; then
smbflag=1
echo "${Yellow}[+] Start scan port 139"
echo "${Yellow}[+] Start scan the following NSE Script -- smb-psexec.nse${reset}"
nmap -p 139  --script="smb-psexec.nse" -oN ${LastIP[2]}.${LastIP[3]}/smb-psexec.txt $host
echo "${green}[+] The scan of -- smb-psexec.nse -- Done!"
echo "${Yellow}[+] Start scan the following NSE Script -- smb-brute.nse${reset}"
nmap -p 139  --script="smb-brute.nse" -oN ${LastIP[2]}.${LastIP[3]}/smb-brute.txt $host
echo "${green}[+] The scan of -- smb-brute.nse -- Done!"
echo "${Yellow}[+] Start scan the following NSE Script -- smb-enum-processes.nse${reset}"
nmap -p 139  --script="smb-enum-processes.nse" -oN ${LastIP[2]}.${LastIP[3]}/smb-enum-processes.txt $host
echo "${green}[+] The scan of -- smb-enum-processes.nse -- Done!"
echo "${Yellow}[+] Start scan the following NSE Script -- smb-enum-shares.nse${reset}"
nmap -p 139  --script="smb-enum-shares.nse" -oN ${LastIP[2]}.${LastIP[3]}/smb-enum-shares.txt $host
echo "${green}[+] The scan of -- smb-enum-shares.nse -- Done!"
echo "${Yellow}[+] Start scan the following NSE Script -- smb-enum-users.nse${reset}"
nmap -p 139  --script="smb-enum-users.nse" -oN ${LastIP[2]}.${LastIP[3]}/smb-enum-users.txt $host
echo "${green}[+] The scan of -- smb-enum-users.nse -- Done!"
echo "${Yellow}[+] Start scan the following NSE Script -- smb-os-discovery.nse${reset}"
nmap -p 139  --script="smb-os-discovery.nse" -oN ${LastIP[2]}.${LastIP[3]}/smb-os-discovery.txt $host
echo "${green}[+] The scan of -- smb-os-discovery.nse -- Done!"
echo "${Yellow}[+] Start scan the following NSE Script -- smb-vuln-*${reset}"
nmap -p 139  --script="smb-vuln-*" -oN ${LastIP[2]}.${LastIP[3]}/smb-vuln.txt $host
echo "${green}[+] The scan of -- smb-vuln-* -- Done!${reset} "
fi
fi
done
done
