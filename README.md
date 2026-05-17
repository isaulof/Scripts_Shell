<div align="center">

# Scripts Shell

**Coleção de scripts Shell para automação e administração de servidores Linux**

[![Shell](https://img.shields.io/badge/Shell-Bash-4EAA25?logo=gnubash&logoColor=white)](https://www.gnu.org/software/bash/)
[![Linux](https://img.shields.io/badge/Linux-Ubuntu-E95420?logo=ubuntu&logoColor=white)](https://ubuntu.com/)
[![Licença](https://img.shields.io/badge/Licen%C3%A7a-Livre-blue)](#)

</div>

---

## Scripts Disponíveis

### `painel_ubuntu_server.sh` — MOTD Dinâmico para Servidores Linux

Exibe uma **mensagem de boas-vindas** rica em informações ao fazer login no servidor. Substitui o MOTD padrão do Ubuntu com um painel colorido e organizado por seções.

#### O que exibe

| Seção | Informações |
|-------|-------------|
| **Identidade e Localização** | Sistema operacional, versão do Kernel, IP privado, IP público |
| **Saúde do Sistema** | Uptime, carga da CPU, uso de RAM, disco raiz, swap, home e atualizações pendentes |
| **Atividade de Usuários** | Número de usuários ativos e último login registrado |

#### Preview

```
##        ___                                             ##
##      __| | _____   __  ___  ___ _ ____   _____ _ __    ##
##     / _  |/ _ \ \ / / / __|/ _ \ |__\ \ / / _ \ |__|   ##
##    | (_| |  __/\ V /  \__ \  __/ |   \ V /  __/ |      ##
##     \__ _|\___| \_/   |___/\___|_|    \_/ \___|_|      ##

#################[ BEM-VINDO(@) AO meu-servidor ]#################

###[ IDENTIDADE E LOCALIZAÇÃO ]###
Sistema             : Ubuntu 22.04.3 LTS
Kernel              : 5.15.0-91-generic
Endereço IP PRIVADO : 192.168.1.10
Endereço IP PÚBLICO : 203.0.113.42

###[ SAÚDE DO SISTEMA ]###
Tempo Ligado        : 3 days, 4 hours
Carga CPU (1m)      : 0.12
Uso de RAM          : 34.2%
Uso Disco (Root)    : 45%
Uso de Swap         : 0B/2.0G (2.0G livre)
Uso do Home         : 85G livre / 200G total
Atualizações        : 3 pendentes

###[ ATIVIDADE DE USUÁRIOS ]###
Usuários Ativos     : 1
Último Login        : saulo  pts/0  192.168.1.5  Fri Nov 1 08:23
```

#### Instalação

**Opção 1 — Exibir ao abrir o terminal (uso pessoal)**

```bash
# 1. Clone o repositório
git clone https://github.com/isaulof/Scripts_Shell.git
cd Scripts_Shell

# 2. Dê permissão de execução
chmod +x painel_ubuntu_server.sh

# 3. Mova para a pasta de scripts pessoais
mkdir -p ~/bin
cp painel_ubuntu_server.sh ~/bin/motd.sh

# 4. Adicione ao .bashrc para rodar ao abrir o terminal
echo "~/bin/motd.sh" >> ~/.bashrc

# 5. Aplique imediatamente
source ~/.bashrc
```

**Opção 2 — MOTD do sistema (exibido no login SSH para todos os usuários)**

```bash
# Copie para a pasta de MOTD do Ubuntu
sudo cp painel_ubuntu_server.sh /etc/update-motd.d/99-painel
sudo chmod +x /etc/update-motd.d/99-painel

# Opcional: desative os MOTDs padrão do Ubuntu
sudo chmod -x /etc/update-motd.d/10-help-text
sudo chmod -x /etc/update-motd.d/50-motd-news
```

#### Requisitos

- Bash 4+
- `curl` — para exibir o IP público *(opcional — o script ignora se não estiver instalado)*
- `apt` — para verificar atualizações pendentes *(opcional — ignorado em sistemas sem apt)*
- Testado em **Ubuntu 20.04, 22.04 e 24.04**

---

## Contribuindo

Abra uma *issue* ou envie um *pull request* com novos scripts ou melhorias. Todos os scripts são de livre utilização, distribuição e modificação.

---

## Autor

**Saulo Felipe** — [@isaulof](https://github.com/isaulof)

