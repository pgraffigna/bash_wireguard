# instalando wireguard
sudo apt update && sudo apt install -y wireguard openresolv

# creando llaves pub + priv
cd /etc/wireguard/ && umask 077; wg genkey | tee privatekey | wg pubkey > publickey

# wg0.conf con llaves + direcciones IP

# activando el servicio
sudo systemctl enable wg-quick@wg0 --now

