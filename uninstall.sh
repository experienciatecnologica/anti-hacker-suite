#!/bin/bash

# Parar serviços
pkill -f "kali_anti_hacker"
pkill -f "ncat.*5555"

# Remover arquivos
rm -f /usr/local/bin/kali_anti_hacker
rm -f /etc/psad/psad.conf

# Limpar iptables
iptables -D INPUT -j ANTI_HACKER 2>/dev/null
iptables -F ANTI_HACKER 2>/dev/null
iptables -X ANTI_HACKER 2>/dev/null

echo "[+] Anti-Hacker Suite removido com sucesso!"
