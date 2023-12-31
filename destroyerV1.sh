#!/bin/bash

# Preguntar al usuario si quiere ejecutar en modo forzado
read -p "Desea aplicar el script en modo forzado? (s/n): " forced
if [ "$forced" = "s" ]; then
    forced_flag="-y"
else
    forced_flag=""
fi

read -p "Desea aplicar el uninstaller? (s/n): " aplicar_uninstaller

read -p "Remover usuarios y sus directorios? (s/n): " confirmar

if [ "$aplicar_uninstaller" = "s" ]; then

	# Desinstalación de paquetes instalados
	sudo apt remove --purge obs-studio $forced_flag
	sudo apt remove --purge code $forced_flag
	sudo apt remove --purge typora $forced_flag
	sudo apt remove --purge discord $forced_flag
	sudo apt remove --purge github-desktop $forced_flag
	sudo apt remove --purge git gitk $forced_flag
	sudo apt remove --purge nodejs npm $forced_flag
	sudo apt remove --purge apache2 $forced_flag
	sudo apt remove --purge php libapache2-mod-php php-mysql php-mbstring php-zip php-gd php-json php-curl phpmyadmin $forced_flag
	sudo apt remove --purge mysql-server $forced_flag
	sudo apt remove --purge mongodb-compass $forced_flag

	# Eliminar archivos descargados
	rm -f Downloads/google.deb
	rm -f Downloads/visualCode.deb
	rm -f Downloads/typora.deb
	rm -f Downloads/firefox-112.0b9.tar.bz2
	rm -f Downloads/discord.deb
	rm -f Downloads/GitHubDesktop-linux-2.8.1-linux2.deb
	rm -f Downloads/compass.deb



	if [ "$confirmar" = "s" ]; then
	    # Eliminar directorios y archivos creados
	    echo "Seleccione la sala en la que se van a ELIMINAR los usuarios"
	    echo "1. Sputnik"
	    echo "2. Apolo"
	    echo "3. Artemis"
	    echo "4. Skylab"
	    echo "5. Salyut"
	    echo "6. Campus"
	    echo "7. Ikaros"
	    echo "8. Ulysses"

	    read -p "Seleccione una opción: " seleccion
	    echo $seleccion

	    users=()

	    case $seleccion in
		1)
		    users=("spukM01-" "spukM02-" "spukT01-" "spukT02-" "spukN01-")
		    pass=('SpMT1*@1@1$' 'SpMT2$0201*' 'SpTT1E01/23' 'SpTT2E@2/23' 'SpNT1TCD/23')
		    ;;
		2)
		    users=("apolM01-" "apolM02-" "apolT01-" "apolT02-" "apolN01-")
		    pass=('ApMT1*@1@1$' 'ApMT2$0201*' 'ApTT1E01/23' 'ApTT2E@2/23' 'ApNT1TCD/23')
		    ;;
		# ... (same pattern for other cases)
		*)
		    echo "Opcion invalida"
		    exit 1
		    ;;
	    esac

	    echo "Ingrese el Numero del PC:"
	    read opcion

	    for i in "${!users[@]}"; do
		USER="${users[$i]}$opcion"
		sudo userdel -r $USER
		sudo rm -rf "/var/www/html/$USER"
	    done

	    sudo userdel -r "${seleccion,,}"
	    echo "usuarios borrados!"
	fi

	# Otros comandos para limpieza adicional, si es necesario
	# ...

	echo "Desinstalación completada."
else
    echo "Uninstall no aplicado."
fi

echo "Seleccione la sala en la que se van a CREAR los usuarios"
echo "1. Sputnik"
echo "2. Apolo"
echo "3. Artemis"
echo "4. Skylab"
echo "5. Salyut"
echo "6. Campus"
echo "7. Ikaros"
echo "8. Ulysses"

read -p "Seleccione una opción: " seleccion
echo $seleccion

users=()
pass=()
case $seleccion in
  1)
    users=("spukM01-" "spukM02-" "spukT01-" "spukT02-" "spukN01-")
    pass=('SpMT1*@1@1$' 'SpMT2$0201*' 'SpTT1E01/23' 'SpTT2E@2/23' 'SpNT1TCD/23')
    ;;
  2)
    users=("apolM01-" "apolM02-" "apolT01-" "apolT02-" "apolN01-")
    pass=('ApMT1*@1@1$' 'ApMT2$0201*' 'ApTT1E01/23' 'ApTT2E@2/23' 'ApNT1TCD/23')
    ;;
  # ... (same pattern for other cases)
  *)
    echo "Opcion invalida"
    exit 1
    ;;
esac

echo "Ingrese el Numero del PC:"
read opcion

for i in "${!users[@]}"; do
  USER="${users[$i]}$opcion"
  PASSWORD="${pass[$i]}"
  sudo useradd -m $USER
  echo "indix: $i  user: $USER  pass: $PASSWORD"
  echo -e "$PASSWORD\n$PASSWORD" | sudo passwd $USER
  sudo chsh -s /bin/bash $USER
done

sudo apt update && sudo apt upgrade $forced_flag

cd ~/Downloads

sudo apt-get install curl htop python3-pip git nodejs npm $forced_flag
sudo add-apt-repository ppa:obsproject/obs-studio $forced_flag
sudo apt update
sudo apt install obs-studio $forced_flag

sudo wget -cO - 'https://code.visualstudio.com/sha/download?build=stable&os=linux-deb-x64' > visualCode.deb
sudo wget -cO - 'https://download.typora.io/linux/typora_1.4.1-dev_amd64.deb' > typora.deb
sudo wget -cO - 'https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb' > google.deb
sudo wget 'https://download-installer.cdn.mozilla.net/pub/devedition/releases/112.0b9/linux-x86_64/es-ES/firefox-112.0b9.tar.bz2'

sudo apt install libgconf-2-4 libc++1 libappindicator1 $forced_flag #dependencias discord
wget -O discord.deb "https://discordapp.com/api/download?platform=linux&format=deb" > discord.deb

sudo dpkg -i google.deb
sudo dpkg -i visualCode.deb
sudo dpkg -i typora.deb
sudo dpkg -i discord.deb

sudo apt install git gitk $forced_flag
sudo wget https://github.com/shiftkey/desktop/releases/download/release-2.8.1-linux2/GitHubDesktop-linux-2.8.1-linux2.deb
sudo dpkg -i GitHubDesktop-linux-2.8.1-linux2.deb

#cd ..

sala="";
echo "Elija la sala para crear la configuracion de nvm y apache2"
echo "1. Sputnik"
echo "2. Apolo"
echo "3. Artemis"
echo "4. Skylab"
echo "5. Salyut"
echo "6. Campus"
echo "7. Ikaros"
echo "8. Ulysses"
read -p "Seleccione una opcion: " opcion
case $opcion in
  1)
    sala="spuk *"
    ;;
  2)
    sala="apol *"
    ;;
  3)
    sala="arte *"
    ;;
  4)
   sala="skylab *"
   ;;
  5)
    sala="salyut *"
    ;;
  6)
    sala="campus *"
    ;;    
  7)
    sala="ikaros *"
    ;;
  8)
    sala="ulysses *"
    ;;       
  *)
    echo "Opción no válida"
    ;;
esac

lista_usuarios=$(cut -d: -f1 /etc/passwd) &&
lista_usuarios_ordenada=$(echo "$lista_usuarios" | tr ' ' '\n' | grep "$sala") &&
for usuario in $lista_usuarios_ordenada
do
  sudo su $usuario -c "wget -O- https://raw.githubusercontent.com/nvm-sh/nvm/v0.35.3/install.sh" | bash &&
  sudo su $usuario -c "wget -O- https://raw.githubusercontent.com/nvm-sh/nvm/v0.35.3/install.sh | bash" &&
  sudo su $usuario -c "cd ~/Downloads && source ~/.bashrc" 
done  &&

#este puede que sobre...
wget -O- https://raw.githubusercontent.com/nvm-sh/nvm/v0.35.3/install.sh | bash &&
wget -O- https://raw.githubusercontent.com/nvm-sh/nvm/v0.35.3/install.sh | bash &&
source ~/.bashrc &&

sudo wget -cO - 'https://downloads.mongodb.com/compass/mongodb-compass_1.36.2_amd64.deb' > compass.deb &&
sudo dpkg -i compass.deb &&

sudo apt install apache2 $forced_flag && sudo apt install php libapache2-mod-php php-mysql $forced_flag && 
sudo ufw allow 'Apache' && sudo ufw enable && cd /var/www/html/ && sudo rm -r index.html &&

cd ~/Downloads
# Composer instalacion
php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
php composer-setup.php
php -r "unlink('composer-setup.php');"

# Mover Composer al directorio global para que esté disponible en todo el sistema
sudo mv composer.phar /usr/local/bin/composer

# INSTALAR DOTNET
sudo apt-get install $forced_flag dotnet-sdk-7.0 &&
sudo apt-get install $forced_flag aspnetcore-runtime-7.0


for usuario in $lista_usuarios_ordenada
do
  carpeta=$(echo "$usuario" | sed 's/a/A/;s/s/S/;s/m/M/;s/n/N/;s/i/I/;s/u/U/;s/c/C/;s/\(.*\)t/\1T/')
  sudo mkdir $carpeta && sudo chown $usuario:$usuario $carpeta && sudo chmod u+rwx $carpeta 
done &&
sudo chmod -R 755 /var/www/html &&
sudo touch /etc/apache2/sites-available/your_domain.conf &&
sudo echo -e "
    <VirtualHost *:80>
      \nServerAdmin webmaster@localhost
      \nServerName html
      \nServerAlias www.html
      \nDocumentRoot /var/www/html
      \nErrorLog \${APACHE_LOG_DIR}/error.log
      \nCustomLog \${APACHE_LOG_DIR}/access.log combined
    </VirtualHost>
    " | sudo tee /etc/apache2/sites-available/your_domain.conf &&
sudo a2ensite your_domain.conf && #SOSPECHOSO NO CONFIGURADO
sudo a2dissite 000-default.conf &&
sudo apache2ctl configtest &&
sudo systemctl restart apache2 &&
sudo a2dismod mpm_event &&
sudo a2enmod mpm_prefork &&
sudo a2enmod php8.1 &&
sudo systemctl restart apache2 &&
cd ~/Downloads &&
sudo apt install mysql-server $forced_flag &&
sudo touch script.sql &&
sudo echo -e "CREATE USER 'campus'@'%' IDENTIFIED WITH mysql_native_password BY 'campus2023'; GRANT ALL PRIVILEGES ON *.* TO 'campus'@'%';" | sudo tee script.sql &&
sudo mysql < script.sql &&
sudo rm script.sql &&

# Verificar si el módulo mod_rewrite ya está habilitado
if apache2ctl -M | grep -q 'rewrite_module'; then
    echo "El módulo mod_rewrite ya está habilitado."
else
    # Habilitar el módulo mod_rewrite
    sudo a2enmod rewrite

    # Cambiar la configuración AllowOverride en apache2.conf
    sudo sed -i '/<Directory \/var\/www\/>/,/<\/Directory>/ s/AllowOverride None/AllowOverride All/' /etc/apache2/apache2.conf

    # Reiniciar Apache2
    sudo service apache2 restart

    echo "El módulo mod_rewrite ha sido habilitado correctamente."
fi

cd ~/Downloads &&
sudo cp -rp firefox-112.0b9.tar.bz2 /opt/ &&
cd /opt/ &&
sudo tar xjf firefox-112.0b9.tar.bz2 &&
sudo rm -rf firefox-112.0b9.tar.bz2 &&
sudo chown -R $USER /opt/firefox/ &&
sudo touch ~/.local/share/applications/firefox_dev.desktop &&
sudo echo -e "[Desktop Entry]\nName=Firefox Developer\nGenericName=Firefox Developer Edition\nExec=/opt/firefox/firefox %u\nTerminal=false\nIcon=/opt/firefox/browser/chrome/icons/default/default128.png\nType=Application\nCategories=Application;Network;X-Developer;\nComment=Firefox Developer Edition Web Browser.\nStartupWMClass=Firefox Developer Edition" | sudo tee ~/.local/share/applications/firefox_dev.desktop &&
sudo chmod +x ~/.local/share/applications/firefox_dev.desktop &&
cd ~/Downloads &&

sudo apt update && sudo apt upgrade $forced_flag && history -c
