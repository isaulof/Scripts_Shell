#!/bin/bash
#
# SCRIPT: motd.sh
# DESCRIÇÃO: Gera uma Mensagem do Dia (MOTD) dinâmica para servidores Linux.
# AUTOR: Saulo Felipe / isaulof@gmail.com
# DATA: 05/11/2025
# VERSÃO: 1.6
#
# --- INÍCIO DO SCRIPT ---

# --- Definição de Cores ---
RESET='\033[0m'        # Reseta toda a formatação
BRANCO='\033[1;37m'    # Branco brilhante 
CYAN='\033[1;36m'      # Cyan brilhante 
VERDE='\033[1;32m'     # Verde brilhante 
AMARELO='\033[1;33m'   # Amarelo brilhante 
VERMELHO='\033[0;31m'  # Vermelho padrão
CINZA='\033[0;90m'     # Cinza padrão
ROXO='\033[1;35m'      # Roxo brilhante 
AZUL='\033[1;34m'      # Azul brilhante 

# --- Banner ASCII Art ---
echo -e "${ROXO}"
echo '##        ___                                             ##'
echo '##      __| | _____   __  ___  ___ _ ____   _____ _ __    ##'
echo '##     / _  |/ _ \ \ / / / __|/ _ \ |__\ \ / / _ \ |__|   ##'
echo '##    | (_| |  __/\ V /  \__ \  __/ |   \ V /  __/ |      ##'
echo '##     \__ _|\___| \_/   |___/\___|_|    \_/ \___|_|      ##'
echo '##                                                        ##'
echo -e "${ROXO}"

# --- Mensagem de Boas-Vindas ---
echo -e "${AZUL}#################[ BEM-VINDO(@) AO ${AMARELO}$(hostname)${AZUL} ]#################${RESET}"
echo ""
echo ""

# --- SEÇÃO (1): =======[ IDENTIDADE E LOCALIZAÇÃO ]=======
echo -e "${AZUL}###[ IDENTIDADE E LOCALIZAÇÃO ]###${RESET}"

OS_INFO=$(grep PRETTY_NAME /etc/os-release | cut -d'"' -f2)
echo -e "${ROXO}Sistema${RESET} : ${BRANCO}${OS_INFO}${RESET}"

KERNEL_INFO=$(uname -r)
echo -e "${ROXO}Kernel${RESET} : ${BRANCO}${KERNEL_INFO}${RESET}"

# NOTA: Para funcionar bem em VM, use o Modo Bridge.
IP_INFO=$(hostname -I | awk '{print $1}')
echo -e "${ROXO}Endereço IP${RESET} : ${BRANCO}${IP_INFO}${RESET}"

echo ""

# --- SEÇÃO (2): =======[ SAÚDE DO SISTEMA ]=======
echo -e "${AZUL}###[ SAÚDE DO SISTEMA ]###${RESET}"

UPTIME_INFO=$(uptime -p | sed 's/up //')
echo -e "${ROXO}Tempo Ligado${RESET} : ${BRANCO}${UPTIME_INFO}${RESET}"

LOAD_INFO=$(cat /proc/loadavg | awk '{print $1}')
echo -e "${ROXO}Carga CPU (1m)${RESET} : ${BRANCO}${LOAD_INFO}${RESET}"

RAM_INFO=$(free -m | awk 'NR==2{printf "%.1f%%", $3*100/$2 }')
echo -e "${ROXO}Uso de RAM${RESET} : ${BRANCO}${RAM_INFO}${RESET}"

DISK_INFO=$(df -h / | awk 'NR==2{print $5}')
echo -e "${ROXO}Uso Disco (Root)${RESET} : ${BRANCO}${DISK_INFO}${RESET}"

echo -e "${ROXO}Uso de Swap ${RESET}: ${BRANCO}$(free -h | awk '/Swap/ {print $3 "/" $2 " (" $4 " livre)"}')${RESET}"

echo -e "${ROXO}Uso do Home${RESET} : ${BRANCO}$(df -h /home 2>/dev/null | awk 'NR==2 {print $4 " livre / " $2 " total"}')${RESET}"

if command -v apt &> /dev/null; then
    UPDATES=$(apt list --upgradable 2>/dev/null | wc -l)
    if [ "$UPDATES" -gt 1 ]; then
        echo -e "${ROXO}Atualizações ${RESET}: ${BRANCO}$((UPDATES-1)) pendentes${RESET}"
    else
        echo -e "${ROXO}Atualizações ${RESET}: ${BRANCO}0 pendentes${RESET}"
    fi
fi

echo ""

# --- SEÇÃO (3): =======[ ATIVIDADE DE USUÁRIOS ]=======
echo -e "${AZUL}###[ ATIVIDADE DE USUÁRIOS ]###${RESET}"

echo -e "${ROXO}Usuários Ativos ${RESET}: ${BRANCO}$(/usr/bin/users | /usr/bin/wc -w)${RESET}"

LAST_LOGIN_INFO=$(\
    /usr/bin/last -n 10 |\
    /usr/bin/grep -vE "(reboot|still logged in|wtmp begins)" |\
    /usr/bin/head -n 1\
)

if [ -z "$LAST_LOGIN_INFO" ]; then
    LAST_LOGIN_INFO="Nenhum login anterior registrado."
fi

echo -e "${AMARELO}Último Login ${RESET}: ${BRANCO}$LAST_LOGIN_INFO${RESET}"
echo ""

# --- FIM DO SCRIPT ---

### SCRIPT DE LIVRE UTILIZAÇÃO, DISTRIBUIÇÃO E MODIFICAÇÃO! ###