# descargar wireguard-ui
wget -q https://github.com/ngoduykhanh/wireguard-ui/releases/download/v0.4.0/wireguard-ui-v0.4.0-linux-amd64.tar.gz
tar xzf wireguard-ui-v0.4.0-linux-amd64.tar.gz && rm wireguard-ui-v0.4.0-linux-amd64.tar.gz
cp wireguard-ui /usr/bin/

# systemd wgui.service
cd /etc/systemd/system/
cat << EOF > wgui.service
[Unit]
Description=Restart WireGuard
After=network.target

[Service]
Type=oneshot
ExecStart=/usr/bin/systemctl restart wg-quick@wg0.service

[Install]
RequiredBy=wgui.path
EOF

# systemd wgui.path
cd /etc/systemd/system/
cat << EOF > wgui.path
[Unit]
Description=Watch /etc/wireguard/wg0.conf for changes

[Path]
PathModified=/etc/wireguard/wg0.conf

[Install]
WantedBy=multi-user.target
EOF

# systemd wgui.http.service
cd /etc/systemd/system/
cat << EOF > wgui_http.service
[Unit]
Description=Wireguard UI
After=network.target

[Service]
Type=simple
Environment="WGUI_SERVER_INTERFACE_ADDRESSES=10.8.0.1/24"
Environment="WGUI_DNS=1.1.1.1, 8.8.8.8"
Environment="WGUI_SERVER_LISTEN_PORT=41194"
Environment="WGUI_USERNAME=administrador"
Environment="WGUI_PASSWORD=password123!"
Environment="WGUI_SERVER_POST_UP_SCRIPT=/etc/wireguard/add-nat-routing.sh"
Environment="WGUI_SERVER_POST_DOWN_SCRIPT=/etc/wireguard/remove-nat-routing.sh"
Environment="WGUI_DEFAULT_CLIENT_ALLOWED_IPS=0.0.0.0/0"
Environment="WGUI_DEFAULT_CLIENT_USE_SERVER_DNS=1.1.1.1, 8.8.8.8"
WorkingDirectory=/bin/
ExecStart=/bin/wireguard-ui

[Install]
WantedBy=multi-user.target
EOF

# iniciar servicio wireguard-ui
systemctl start wgui_http.service

# modificar las keys del server por defecto al iniciar wireguard-ui
systemctl stop wgui_http.service

+ actualizar las keys del server en /usr/bin/db/server/keypair.json 

systemctl daemon-reload
systemctl start wgui_http.service
