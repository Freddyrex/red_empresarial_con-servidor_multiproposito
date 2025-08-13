#!/bin/bash

SERVER_IP="192.168.10.50"
TARGET_USER="ssh1"
TARGET_HOME="/home/$TARGET_USER"
PUB_KEY_PATH="/root/.ssh/id_rsa.pub"
PRIVATE_KEY="/root/.ssh/id_rsa"

echo "[+] Solicitando IP mediante DHCP..."
dhclient eth0

sleep 2

# Validar existencia de clave
if [ ! -f "$PRIVATE_KEY" ]; then
    echo " ERROR: No se encuentra clave privada en $PRIVATE_KEY"    exit 1
fi

# Enviar clave pública al servidor para ssh1
echo "[+] Enviando clave pública al servidor ($SERVER_IP)..."
sshpass -p "Soyfreddy1@" ssh -o StrictHostKeyChecking=no root@$>    mkdir -p $TARGET_HOME/.ssh && \
    echo $(cat $PUB_KEY_PATH) > $TARGET_HOME/.ssh/authorized_ke>    chown -R $TARGET_USER:sshusers $TARGET_HOME/.ssh && \
    chmod 700 $TARGET_HOME/.ssh && \
    chmod 600 $TARGET_HOME/.ssh/authorized_keys
"

echo "[✓] Clave pública copiada correctamente."

echo
echo "Pedes conectar desde ubuntu_station a $SERVER_IP con:"
echo "    ssh -i $PRIVATE_KEY $TARGET_USER@$SERVER_IP"
echo

# Lanza el menú de usuario novato automáticamente
/root/menu_usuario.sh
