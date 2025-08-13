# 🌐 Infraestructura de Red con Docker & GNS3

Este proyecto, desarrollado por **Freddy Valenzuela**, simula una red corporativa completa en GNS3 usando contenedores Docker para servidores y estaciones de trabajo Linux. Incluye servicios de red como DHCP, FTP, SSH, Web, MySQL y automatización cliente.

---

## 📸 Topología de Red

![Topología de Red](./docs/topologia.png)

**Componentes destacados:**
- `ultimate_server`: Servidor central con múltiples servicios
- `ubuntu_station-1` a `ubuntu_station-6`: Clientes Linux automatizados
- `PC1`, `PC2`, `PC5`: Clientes básicos (VPCS)
- `impresora#1`, `impresora#2`: Dispositivos simulados
- `ubuntu-nmap-1`: Escáner de red
- `R1` y `NAT1`: Salida a Internet simulada

---

## ⚙️ Servicios Instalados en el Servidor

| Servicio          | Descripción                                               |
|------------------|-----------------------------------------------------------|
| `isc-dhcp-server`| Asigna IPs automáticamente a estaciones cliente           |
| `vsftpd`         | Servidor FTP seguro                                       |
| `openssh-server` | Acceso remoto SSH autenticado por clave pública           |
| `nginx`          | Servidor web con página HTML de prueba                    |
| `mysql-server`   | Motor de base de datos con carga inicial (`init.sql`)     |

---

## 🔐 Gestión de Usuarios

| Usuario | Grupo      | Función              |
|---------|------------|----------------------|
| `ftp1`  | ftpusers   | Cliente FTP          |
| `ftp2`  | ftpusers   | Cliente FTP          |
| `ssh1`  | sshusers   | Usuario SSH (clave)  |
| `ssh2`  | sshusers   | Usuario SSH (clave)  |
| `web1`  | webadmins  | Admin web            |
| `db1`   | dbadmins   | Admin base de datos  |

✔️ SSH seguro por clave  
✔️ Usuarios agrupados por rol  
✔️ Claves públicas cargadas en `authorized_keys`  
✔️ Clave pública de `ubuntu_station` aceptada

---

## 🤖 Automatización de Clientes

Los contenedores `ubuntu_station`:

- Incluyen su propia clave privada/pública
- Ejecutan `setup.sh` que:
  - Copia clave pública al servidor
  - Configura cliente SSH
  - Prueba servicios: DHCP, SSH, FTP, NGINX, MySQL

---

## 🚀 Cómo Desplegar

### 🔧 Construcción de imágenes Docker

```bash
# Imagen del servidor
docker build -t ultimate_server -f dockerfile .

# Imagen del cliente Ubuntu automatizado
docker build -t ubuntu_station -f dockerfile_cliente .
