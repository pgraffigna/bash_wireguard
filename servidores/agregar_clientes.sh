#!/usr/bin/env bash

# colores
VERDE="\e[0;32m\033[1m"
ROJO="\e[0;31m\033[1m"
AMARILLO="\e[0;33m\033[1m"
FIN="\033[0m\e[0m"

# ctrl-c
trap ctrl_c INT
function ctrl_c(){
        echo -e "\n${ROJO}[WIREGUARD]Programa Terminado por el usuario ${FIN}"
        exit 0
}

# funciones
function usuario_es_root(){
    [ "$(id -u)" -eq 0 ]
}

function cabecera(){
  cat <<EOM

###########################################################################
            - Clientes actualmente conectados a la VPN -
###########################################################################

EOM
}

clear
cabecera
wg

if usuario_es_root; then
read -p "$(echo -e "\n${AMARILLO}"Ingresa la llave publica del cliente: "${FIN}")" LLAVE_PUB
read -p "$(echo -e "${AMARILLO}"Ingresa la ip para el cliente en la VPN: "${FIN}")" IP_CLIENTE
read -p "$(echo -e "${AMARILLO}"Ingresa la ip del equipo del cliente: "${FIN}")" EQUIPO_CLIENTE

tee -a /etc/wireguard/wg1.conf >/dev/null <<EOF

[Peer]
PublicKey = "${LLAVE_PUB}"
AllowedIPs = "${IP_CLIENTE}/32"
Endpoint = "${EQUIPO_CLIENTE}:52589"
EOF

wg syncconf wg0 <(wg-quick strip wg0)

else
    echo -e "${ROJO}[WIREGUARD]Correr como root!! ${FIN}"
    exit 1
fi