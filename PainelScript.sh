#!/bin/bash
#
# SCRIPT: motd.sh
# DESCRIÇÃO: Gera uma Mensagem do Dia (MOTD) dinâmica para servidores Linux.
# AUTOR: Saulo Felipe / isaulof@gmail.com
# DATA: 05/11/2025
# VERSÃO: 1.4 
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

#Coleta e exibe o hostname atual.
echo -e "${AZUL}       ##########[ BEM-VINDO(@) AO ${AMARELO}$(hostname)${AZUL} ]##########${RESET}"
echo "" # Imprime uma linha em branco para espaçamento.
echo "" # Imprime uma linha em branco para espaçamento. 

# --- SEÇÃO (1): =======[ IDENTIDADE E LOCALIZAÇÃO ]=======
# Exibe marcador da seção "Identidade e localização"
echo -e "${AZUL}###[ Identidade e Localização ]###${RESET}"

# Coleta a descrição do Sistema Operacional.
OS_INFO=$(grep PRETTY_NAME /etc/os-release | cut -d'"' -f2)
# Exibe o nome do sistema utilizado
echo -e "${ROXO}Sistema${RESET} : ${BRANCO}$OS_INFO $RESET"

# Coleta a versão do Kernel.
KERNEL_INFO=$(uname -r)
# Exibe informações coletadas do kernel
echo -e "${ROXO}Kernel${RESET} : ${BRANCO}$KERNEL_INFO${RESET}"

# Coleta o Endereço IP PRIVADO.
IP_INFO=$(hostname -I | awk '{print $1}')
# Exibe o endereço ip privado que foi coletado.
echo -e "${ROXO}Endereço IP PRIVADO${RESET} : ${BRANCO}$IP_INFO${RESET}"

# Coleta o Endereço IP PÚBLICO.
# AVISO: Pode deixar o login lento! Usa timeout de 3s.
if command -v curl &> /dev/null; then
    PUBLIC_IP=$(curl -s --max-time 3 icanhazip.com) 
    
    if [ $? -eq 0 ] && [ -n "$PUBLIC_IP" ]; then
        # Exibe o ip público coletado
        echo -e "${AMARELO}Endereço IP PÚBLICO ${RESET}: ${BRANCO}$PUBLIC_IP${RESET}"
    else
        # Exibe mensagem de erro
        echo -e "${AMARELO}Endereço IP PÚBLICO ${RESET}: (Indisponível)"
    fi
else
    : 
fi

echo "" # Imprime uma linha em branco para espaçamento. 

# --- SEÇÃO (2): =======[ SAÚDE DO SISTEMA ]=======
# Exibe marcador da seção "Saúde do sistema"
echo -e "${AZUL}###[ Saúde do Sistema ]###${RESET}"

# Coleta o Uptime (tempo ligado) de forma "bonita".
UPTIME_INFO=$(uptime -p | sed 's/up //')
# Exibe o Uptime (tempo ligado).
echo -e "${ROXO}Tempo Ligado${RESET} : ${BRANCO}$UPTIME_INFO${RESET}"

# Coleta a Carga da CPU (Load Average) do último minuto.
LOAD_INFO=$(cat /proc/loadavg | awk '{print $1}')
# Exibe a carga da CPU do último minuto.
echo -e "${ROXO}Carga CPU (1m)${RESET} : ${BRANCO}$LOAD_INFO${RESET}"

# Coleta o Uso de RAM.
RAM_INFO=$(free -m | awk 'NR==2{printf "%.1f%%", $3*100/$2 }')
# Exibe o uso de RAM.
echo -e "${ROXO}Uso de RAM${RESET} : ${BRANCO}$RAM_INFO${RESET}"

# Coleta o Uso do Disco Raiz (/).
DISK_INFO=$(df -h / | awk 'NR==2{print $5}')
# Exibe o uso de disco raiz (/).
echo -e "${ROXO}Uso Disco (Root)${RESET} : ${BRANCO}$DISK_INFO${RESET}"

# Exibe o uso de swap
echo -e "${ROXO}Uso de Swap ${RESET}: ${BRANCO}$(free -h | awk '/Swap/ {print $3 "/" $2 " (" $4 " livre)"}')${RESET}"

# Exibe o espaço em outros discos/partições
echo -e "${ROXO}Uso do Home${RESET} : ${BRANCO}$(df -h /home | awk 'NR==2 {print $4 " livre / " $2 " total"}')${RESET}"

# Coleta e exibe a temperatura da CPU.
if command -v sensors &> /dev/null; then
    # Tenta pegar a temp "Package" (Intel) ou "Tdie" (AMD)
    CPU_TEMP=$(sensors | grep -iE '^(Package id 0|Tdie):' | awk '{print $4}' | cut -d'+' -f2 | head -n 1)
    
    # Se falhar, tenta um "Core 0" genérico
    if [ -z "$CPU_TEMP" ]; then
        CPU_TEMP=$(sensors | grep -iE '^(Core 0):' | awk '{print $3}' | cut -d'+' -f2 | head -n 1)
    fi

    if [ -n "$CPU_TEMP" ]; then
        echo -e "${ROXO}Temperatura CPU ${RESET}: ${BRANCO}$CPU_TEMP${RESET}"
    else
        echo -e "${ROXO}Temperatura CPU ${RESET}: (Não foi possível ler)"
    fi
else
    # Não exibe nada se o lm-sensors não estiver instalado
    : 
fi

# Verifica se há atualizações pendentes.
UPDATES=$(apt list --upgradable 2>/dev/null | wc -l)
# Exibe se há atualizações pendentes.
echo -e "${ROXO}Atualizações ${RESET}: ${BRANCO}$((UPDATES-1)) pendentes${RESET}"

echo "" # Imprime uma linha em branco para espaçamento. 

# --- SEÇÃO (3): =======[ ATIVIDADE DE USUÁRIOS ]=======

echo -e "${AZUL}###[ Atividade de Usuários ]###${RESET}"
# Mostra quem está logado e o último login.
echo -e "${ROXO}Usuários Ativos ${RESET}: ${BRANCO}$(who | wc -l)${RESET}"
# Pega o último login, filtrando entradas "system" e "atuais"
LAST_LOGIN_INFO=$(last -n 10 | grep -vE "(reboot|still logged in|wtmp begins)" | head -n 1)

# Se nenhum login anterior for encontrado (ex: sistema novo), exibe uma mensagem
if [ -z "$LAST_LOGIN_INFO" ]; then
    LAST_LOGIN_INFO="Nenhum login anterior registrado."
fi

echo -e "${AMARELO}Último Login ${RESET}: ${BRANCO}$LAST_LOGIN_INFO${RESET}"
echo "" # Imprime uma linha em branco para espaçamento.


# --- FIM DO SCRIPT ---

### OBRIGADO POR BAIXAR NOSSO SCRIPT_PAINEL! ###
### SCRIPT DE LIVRE UTILIZAÇÃO, DISTRIBUIÇÃO E MODIFICAÇÃO! ###
