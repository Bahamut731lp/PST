#!/bin/bash

################################################################################
# Help                                                                         #
################################################################################
Help ()
{
   # Display Help
   echo
   echo "Skript pro konfigurace virtuálního stroje pro úlohu 6 podle instrukcí z Elearningu."
   echo
   echo "Syntax: ./uloha06-virtual.sh --help | interface_ip interface_dev router_ip"
   echo
   echo "Argumenty:"
   echo "interface_ip       Vybraná IP, kterou má mít síťové rozhraní"
   echo "interface_dev      Název rozhraní, kterému se připadí IP"
   echo "router_ip          IP routeru"
   echo
   echo 'Příklad: ./uloha06-virtual.sh "192.168.1.60/24" "enp0s8" "192.168.1.1"'
   echo
}

if [ $1 = "--help" ] 
then
    Help
    exit
fi

interface_ip=$1     # Např. "192.168.1.60/24"
interface_dev=$2    # Např. "enp0s8"
router_ip=$3        # Např. "192.168.1.1"

# Vytvoření logu
touch virtual.log

# Povolení DHCP
ifconfig $interface_dev dhcp start &>> virtual.log 

#########################################
#           Nastavení síťovky           #
#########################################
echo "Nastavení sekundářní síťové karty"
ip addr add $interface_ip dev $interface_dev &>> virtual.log
ip route add default via $router_ip proto dhcp metric 90 &>> virtual.log

#####################################
#           Setup Apache            #
#####################################
echo "Setupování Apache"
yum install httpd &>> /dev/null
service httpd start &>> virtual.log
echo "Listen 5001" >> /etc/httpd/conf/httpd.conf

#####################################
#           Vytvoření HTML          #
#####################################

echo "Vytvářím index.html"
touch /var/www/html/index.html &>> virtual.log
chmod 777 /var/www/html -R &>> virtual.log
printf "A%s" $(hostname | grep -Eo "[0-9]+") > /var/www/html/index.html

echo "Done."
echo "Protip: Přejdi do routeru a nastav tam přesměrování portů na každou stanici."