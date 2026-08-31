#!/bin/sh
GREEN='\033[32m'   
BLUE='\033[34m'   
RESET='\033[0m'
RED='\033[31m'

echo -e "\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n"

if [ ! -f /tmp/userdata/startup.sh ]; then
    echo -e "${RED}Error: ${RESET}Patch AutoRun not found"
    echo "Go to this link below to install"
    echo "https://github.com/DenySystem/vnptmodemresearch/tree/master/Integrations/autorun"
    exit 1
fi

echo -e "\033[31;43mScript Make By AppleSang With <3\033[0m\n"
echo -e "${RED}############################################################\n"
echo -e "${GREEN} https://github.com/DenySystem/vnptmodemresearch\n"
echo -e "${RED}############################################################\n"
echo -e "        ${YELLOW}Press enter to confirm for patch ${CYAN}AdGuardHome${RESET}"
read _
echo -e "Starting installation..."
mkdir -p /tmp/userdata/AdGuard
cd /tmp/userdata/AdGuard
/userfs/bin/curl -s -k -o AdGuard.sh https://raw.githubusercontent.com/DenySystem/vnptmodemresearch/refs/heads/master/Integrations/AdGuard/startup.sh
chmod +x AdGuard.sh
/userfs/bin/curl -s -k -o accvraiz1.crt https://raw.githubusercontent.com/DenySystem/vnptmodemresearch/refs/heads/main/Integrations/AdGuard/accvraiz1.crt
export SSL_CERT_FILE=/tmp/userdata/AdGuard/accvraiz1.crt
echo -e "\033[32m[OK]\033[0m Loaded certificate!"
cd /tmp/SafeGate
/userfs/bin/curl -s -fSL -o AdGuardHome_linux_armv5.tar.gz https://github.com/AdguardTeam/AdGuardHome/releases/latest/download/AdGuardHome_linux_armv5.tar.gz
echo -e "\033[32m[OK]\033[0m Downloaded AdGuard!"
tar -xzf AdGuardHome_linux_armv5.tar.gz
rm AdGuardHome_linux_armv5.tar.gz
cd AdGuardHome
chmod +x AdGuardHome
kill -9 $(pidof dnsmasq)
echo -e "\033[32m[OK]\033[0m Finish Install AdGuardHome to your VNPT router!"
echo -e "\033[31;43mPlease visit http://$(ip addr show br0 | grep 'inet ' | awk '{print $2}' | cut -d/ -f1):3000 to finish setup!\033[0m"
echo -e "\033[32mJust close this terminal, not Ctrl+C!\033[0m"
rm /tmp/userdata/AdGuard.sh
grep -q "^sh /tmp/userdata/AdGuard/AdGuard.sh$" /tmp/userdata/startup.sh || \
echo "sh /tmp/userdata/AdGuard/AdGuard.sh" >> /tmp/userdata/startup.sh
./AdGuardHome -c /tmp/userdata/AdGuard/AdGuardHome.yaml -w /tmp/SafeGate >/dev/null 2>&1 &
