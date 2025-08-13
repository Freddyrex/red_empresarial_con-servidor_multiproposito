#!/bin/bash

echo "[+] Configurando interfaz de red..."
ifconfig eth0 192.168.10.50 netmask 255.255.255.0 up
route add default gw 192.168.10.1

echo "[+] Configurando DNS..."
echo "nameserver 8.8.8.8" > /etc/resolv.conf

echo "[+] Habilitando reenvío de IP y NAT..."
echo 1 > /proc/sys/net/ipv4/ip_forward
iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE

echo "[+] Configurando UFW..."
ufw --force enable
ufw allow 21/tcp   # FTP
ufw allow 22/tcp   # SSH
ufw allow 67/udp   # DHCP
ufw allow 80/tcp   # HTTP
ufw allow 3306/tcp # MySQL
ufw default deny incoming
ufw default allow outgoing

echo "[+] Iniciando servicios..."

# Eliminar PID huérfano si existe
if [ -f /var/run/dhcpd.pid ]; then
    echo "[!] Eliminando PID antiguo de DHCP..."
    rm -f /var/run/dhcpd.pid
fi

# Arrancar servicios en orden
service isc-dhcp-server start
service vsftpd start
service ssh start
service nginx start
service mysql start
echo "[+] Esperando que MySQL se inicialice..."
sleep 5
echo "[+] Configurando acceso root y remoto..."
mysql -e "ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY 'rootpass'; FLUSH PRIVILEGES;"
mysql -u root -prootpass -e "CREATE USER IF NOT EXISTS 'admin'@'%' IDENTIFIED BY 'admin123';"
mysql -u root -prootpass -e "GRANT ALL PRIVILEGES ON *.* TO 'admin'@'%' WITH GRANT OPTION; FLUSH PRIVILEGES;"

echo "[+] Configurando base de datos..."
mysql -u root -prootpass -e "CREATE DATABASE IF NOT EXISTS inventario;"
mysql -u root -prootpass inventario < /init.sql

echo "[+] Contenedor en ejecución. ¡Servidor listo!"
exec bash
