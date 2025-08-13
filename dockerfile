FROM ubuntu:18.04

ENV DEBIAN_FRONTEND=noninteractive

# Actualizar e instalar servicios necesarios
RUN apt-get update && apt-get install -y \
    isc-dhcp-server \
    vsftpd \
    openssh-server \
    nginx \
    mysql-server \
    net-tools \
    iproute2 \
    htop \
    nmap \
    ufw \
    sudo \
    passwd \
    vim \
    nano \
    systemd

# Crear usuarios y grupos
RUN groupadd ftpusers && \
    useradd -m -s /bin/bash -G ftpusers ftp1 && echo "ftp1:Soyfreddy1@" | chpasswd && \
    useradd -m -s /bin/bash -G ftpusers ftp2 && echo "ftp2:Soyfreddy1@" | chpasswd && \
    groupadd sshusers && \
    useradd -m -s /bin/bash -G sshusers ssh1 && echo "ssh1:Soyfreddy1@" | chpasswd && \
    useradd -m -s /bin/bash -G sshusers ssh2 && echo "ssh2:Soyfreddy1@" | chpasswd && \
    groupadd webadmins && \
    useradd -m -s /bin/bash -G webadmins web1 && echo "web1:Soyfreddy1@" | chpasswd && \
    groupadd dbadmins && \
    useradd -m -s /bin/bash -G dbadmins db1 && echo "db1:Soyfreddy1@" | chpasswd

# Crear estructura FTP y archivo inicial
RUN mkdir -p /srv/ftp && \
    chown ftp1:ftpusers /srv/ftp && \
    chmod 755 /srv/ftp && \
    echo "Este es el archivo hola.txt en el FTP" > /srv/ftp/hola.txt && \
    chown ftp1:ftpusers /srv/ftp/hola.txt

# Crear página web por defecto y dar permisos a web1
RUN echo "<h1>Servidor Web Activo - ultimate_server</h1>" > /var/www/html/index.html && \
    chown -R web1:webadmins /var/www/html

# Configurar interfaz de DHCP persistente
RUN echo 'INTERFACESv4="eth0"' > /etc/default/isc-dhcp-server

# Crear directorios SSH con permisos previos
RUN mkdir -p /home/ssh1/.ssh /home/ssh2/.ssh && \
    chmod 700 /home/ssh1/.ssh /home/ssh2/.ssh

# Copiar claves públicas necesarias
COPY keys/ssh1.pub /tmp/ssh1.pub
COPY keys/ssh2.pub /tmp/ssh2.pub
COPY keys/ubuntu_station.pub /tmp/ubuntu_station.pub

# Insertar claves SSH para usuarios
RUN cat /tmp/ssh1.pub > /home/ssh1/.ssh/authorized_keys && \
    cat /tmp/ubuntu_station.pub >> /home/ssh1/.ssh/authorized_keys && \
    chown -R ssh1:sshusers /home/ssh1/.ssh && \
    chmod 600 /home/ssh1/.ssh/authorized_keys && \
    rm /tmp/ssh1.pub

RUN cat /tmp/ssh2.pub > /home/ssh2/.ssh/authorized_keys && \
    cat /tmp/ubuntu_station.pub >> /home/ssh2/.ssh/authorized_keys && \
    chown -R ssh2:sshusers /home/ssh2/.ssh && \
    chmod 600 /home/ssh2/.ssh/authorized_keys && \
    rm /tmp/ssh2.pub /tmp/ubuntu_station.pub

# Configurar SSH
RUN sed -i 's/^.*PasswordAuthentication.*/PasswordAuthentication no/' /etc/ssh/sshd_config && \
    sed -i 's/^.*PubkeyAuthentication.*/PubkeyAuthentication yes/' /etc/ssh/sshd_config && \
    sed -i 's/^.*PermitRootLogin.*/PermitRootLogin no/' /etc/ssh/sshd_config && \
    grep -q "AllowGroups sshusers" /etc/ssh/sshd_config || echo "AllowGroups sshusers" >> /etc/ssh/sshd_config

# Permitir conexiones externas a MySQL
RUN sed -i 's/^bind-address.*/bind-address = 0.0.0.0/' /etc/mysql/mysql.conf.d/mysqld.cnf

# Copiar archivos de configuración y scripts (excluyendo el problemático pam.d.common-password)
COPY dhcpd.conf /etc/dhcp/dhcpd.conf
COPY vsftpd.conf /etc/vsftpd.conf
COPY sshd_config /etc/ssh/sshd_config
COPY interfaces /etc/network/interfaces
COPY init.sql /init.sql
COPY entrypoint.sh /entrypoint.sh

# Permisos del script de entrada
RUN chmod +x /entrypoint.sh

# Exponer puertos necesarios
EXPOSE 21 22 67/udp 80 3306

# Comando por defecto
CMD ["/entrypoint.sh"]
