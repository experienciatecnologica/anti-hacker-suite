#!/bin/bash

# Cores
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

# Verificar root
if [ "$(id -u)" -ne 0 ]; then
    echo -e "${RED}[ERRO] Execute como root!${NC}"
    exit 1
fi

# Instalar dependências
echo -e "${YELLOW}[*] Instalando dependências...${NC}"
apt update && apt install -y \
    net-tools \
    lsof \
    ncat \
    iptables-persistent \
    auditd \
    fail2ban \
    psad \
    rkhunter

# Baixar script principal
echo -e "${YELLOW}[*] Baixando anti-hacker suite...${NC}"
wget https://raw.githubusercontent.com/seuuser/anti-hacker-suite/main/kali_anti_hacker -O /usr/local/bin/kali_anti_hacker
chmod +x /usr/local/bin/kali_anti_hacker

# Configurar serviços
echo -e "${YELLOW}[*] Configurando proteções...${NC}"

# 1. IPTables básico
iptables -N ANTI_HACKER
iptables -A INPUT -j ANTI_HACKER
iptables -A ANTI_HACKER -p tcp --dport 22 -m connlimit --connlimit-above 3 -j DROP
iptables -A ANTI_HACKER -m recent --name ATTACKER --update --seconds 3600 -j DROP

# 2. Configurar PSAD (detecção de portscan)
cat > /etc/psad/psad.conf <<EOF
EMAIL_ALERT_DEST root;
ENABLE_AUTO_IDS Y;
AUTO_IDS_DANGER_LEVEL 3;
EOF

# 3. Honeypot básico
echo -e "${YELLOW}[*] Configurando honeypot na porta 5555...${NC}"
nohup ncat -lvkp 5555 > /var/log/honeypot.log 2>&1 &

echo -e "${GREEN}[+] Instalação completa! Execute com: kali_anti_hacker${NC}"
