chmod +x menu_usuario.sh

./menu_usuario.sh


#!/bin/bash

while true; do
    clear
    echo "====== Menú de Usuario Novato ======"
    echo "1. Mostrar mi IP"
    echo "2. Ver puertos activos del servidor (nmap)"
    echo "3. Probar conexión a Internet (ping a 8.8.8.8)"
    echo "4. Acceder al servidor por SSH"
    echo "5. Ver estado del firewall local (ufw)"
    echo "6. Conectarse al servidor FTP"
    echo "7. Probar acceso a la web interna"
    echo "8. Visualizar la base de datos (MySQL)"
    echo "9. Salir"
    echo "===================================="
    read -p "Elija una opción [1-9]: " op

    case $op in
        1)
            echo "Su(s) dirección(es) IP es/son:"
            ip addr show eth0 | grep "inet " | awk '{print $2}'
            read -p "Presione ENTER para continuar..."
            ;;
        2)
            echo "Escaneando puertos abiertos en el servidor (192.168.10.50)..."
            nmap 192.168.10.50
            read -p "Presione ENTER para continuar..."
            ;;
        3)
            echo "Probando conexión a Internet (ping a 8.8.8.8)..."
            ping -c 4 8.8.8.8
            read -p "Presione ENTER para continuar..."
            ;;
        4)
            while true; do
                clear
                echo "--- Menú SSH ---"
                echo "1. Conectarse como ssh1"
                echo "2. Conectarse como ssh2"
                echo "3. Cancelar y volver al menú principal"
                read -p "Seleccione una opción [1-3]: " sshop
                case $sshop in
                    1)
                        echo "Conectando como ssh1..."
                        ssh -i /root/.ssh/id_rsa ssh1@192.168.10.50
                        break
                        ;;
                    2)
                        echo "Conectando como ssh2..."
                        ssh -i /root/.ssh/id_rsa ssh2@192.168.10.50
                        break
                        ;;
                    3)
                        echo "Regresando al menú principal..."
                        break
                        ;;
                    *)
                        echo "Opción inválida, intente de nuevo."
                        ;;
                esac
            done
            read -p "Presione ENTER para continuar..."
            ;;
        5)
            echo "Estado del firewall local (ufw):"
            sudo ufw status verbose
            read -p "Presione ENTER para continuar..."
            ;;
        6)
            echo "Abriendo conexión FTP a 192.168.10.50 (usuario anónimo disponible)"
            echo "Ruta compartida: /srv/ftp"
            ftp 192.168.10.50
            read -p "Presione ENTER para continuar..."
            ;;
        7)
            echo "Accediendo a la web interna (http://192.168.10.50)..."
            curl http://192.168.10.50
            read -p "Presione ENTER para continuar..."
            ;;
        8)
            echo "Mostrando tablas y datos de la base 'inventario' (usuario: admin / admin123)..."
            mysql -uadmin -padmin123 -h192.168.10.50 -e "USE inventario; SHOW TABLES; SELECT * FROM clientes;"
            read -p "Presione ENTER para continuar..."
            ;;
        9)
            echo "¡Hasta luego!"
            exit 0
            ;;
        *)
            echo "Opción inválida, intente de nuevo."
            read -p "Presione ENTER para continuar..."
            ;;
    esac
done
