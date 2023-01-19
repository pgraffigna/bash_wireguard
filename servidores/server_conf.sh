# actualizacion full del sistema
apt update && sudo apt upgrade -y

# instalando wireguard-server
apt install wireguard

# generando las llaves pub + priv
cd /etc/wireguard && umask 077; wg genkey | tee privatekey | wg pubkey > publickey

# editar wg0.conf con datos de llaves y direcciones IP

[Interface]
Address = 10.8.0.1/24   ## server private IP address
SaveConfig = true
PostUp = /etc/wireguard/agregar_reglas_ruteo.sh
PostDown = /etc/wireguard/eliminar_reglas_ruteo.sh
ListenPort = 41194
PrivateKey = 2M54c1kTVJwhZIzUHBx+zIsYJOvkCOkcKDrQsmwjImg=    ## server private key

# iniciar el servicio
systemctl enable wg-quick@wg0 --now

# chequear estado
wg show

# recargar configuracion
sysctl -p /etc/sysctl.d/10-wireguard.conf
chmod -v +x /etc/wireguard/helper/*.sh
systemctl restart wg-quick@wg0.service

# agregar clientes via script

# recargar configuración para clientes nuevos
wg syncconf wg0 <(wg-quick strip wg0)