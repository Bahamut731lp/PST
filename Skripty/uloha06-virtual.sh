red=$(tput setaf 1)
green=$(tput setaf 2)
yellow=$(tput setaf 3)
blue=$(tput setaf 4)

normal=$(tput sgr0)


interface_ip="192.168.1.60/24"
interface_dev="enp0s8"
router_ip="192.168.1.1"

# Vytvoření logu
touch virtual.log

#########################################
#           Nastavení síťovky           #
#########################################
echo "Nastavení sekundářní síťové karty"

echo -ne '[                      ]  (0%)\r'
ip addr add $interface_ip dev $interface_dev &>> virtual.log

echo -ne '[##########            ]  (50%)\r'
ip route add default via $router_ip proto dhcp metric 90 &>> virtual.log

echo -ne '[######################]  (100%)\r'
echo -ne '\n\n'


#####################################
#           Setup Apache            #
#####################################
echo "Setupování Apache"
echo -ne '[                      ]  (0%)\r'
yum install httpd &>> /dev/null

echo -ne '[#####                 ]  (33%)\r'
service httpd start &>> virtual.log

echo -ne '[###############       ]  (66%)\r'
echo "Listen 5001" >> /etc/httpd/conf/httpd.conf

echo -ne '[######################]  (100%)\r'
echo -ne '\n\n'


#####################################
#           Vytvoření HTML          #
#####################################

echo "Vytvářím index.html"

echo -ne '[                      ]  (0%)\r'
touch /var/www/html/index.html &>> virtual.log

echo -ne '[##########            ]  (33%)\r'
chmod 777 /var/www/html -R &>> virtual.log

echo -ne '[######################]  (66%)\r'
printf "A%s" $(hostname | grep -Eo "[0-9]+") > /var/www/html/index.html

echo -ne '[######################]  (100%)\r'