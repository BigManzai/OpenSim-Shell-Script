#!/usr/bin/env bash

### Sprachen
function german() 
{
    bereitsinstalliert="ist bereits installiert."
    installierejetzt="Ich installiere jetzt"
}
function frensh() 
{
    bereitsinstalliert="est déjà installé."
    installierejetzt="J'installe maintenant"
}
function spain() 
{
    bereitsinstalliert="ya está instalado."
    installierejetzt="Estoy instalando ahora"
}
function english() 
{
    bereitsinstalliert="is already installed."
    installierejetzt="I'm installing now"
}

# Einstellungen:
KOMMANDO=$1
german # Sprache
clear # Bildschirm loeschen

function iinstall()
{
    installation=$1
    if dpkg-query -s "$installation" 2>/dev/null|grep -q installed; then
        echo "$installation $bereitsinstalliert"
    else
        echo "$installierejetzt $installation"
        sudo apt-get -y install "$installation"
    fi
}

function serverupgrade()
{    
    sudo apt-get update
    sudo apt-get upgrade
}

function monoinstall18()
{
	if dpkg-query -s mono-complete 2>/dev/null|grep -q installed; then
		echo "mono-complete $bereitsinstalliert"
	else
		echo "$installierejetzt mono-complete"
		sleep 2

		sudo apt install gnupg ca-certificates
		sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 3FA7E0328081BFF6A14DA29AA6A19B38D3D831EF
		echo "deb https://download.mono-project.com/repo/ubuntu stable-bionic main" | sudo tee /etc/apt/sources.list.d/mono-official-stable.list

		sudo apt update
        sudo apt-get -y install mono-complete
		sudo apt-get upgrade
	fi
}

function monoinstall20()
{
	if dpkg-query -s mono-complete 2>/dev/null|grep -q installed; then
		echo "mono-complete $bereitsinstalliert"
	else
		echo "$installierejetzt mono-complete"
		sleep 2

		sudo apt install gnupg ca-certificates
        sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 3FA7E0328081BFF6A14DA29AA6A19B38D3D831EF
        echo "deb https://download.mono-project.com/repo/ubuntu stable-focal main" | sudo tee /etc/apt/sources.list.d/mono-official-stable.list

        sudo apt update
        sudo apt-get -y install mono-complete
		sudo apt-get upgrade       
	fi
}

function installwordpress()
{
	iinstall apache2    
	iinstall ghostscript
    iinstall libapache2-mod-php
    iinstall mysql-server
    iinstall php
    iinstall php-bcmath
    iinstall php-curl
    iinstall php-imagick
    iinstall php-intl
	iinstall php-json
	iinstall php-mbstring
	iinstall php-mysql
	iinstall php-xml
	iinstall php-zip    
}

function installobensimulator() 
{
    #Alles für den OpenSimulator ausser mono
	iinstall apache2
	iinstall libapache2-mod-php
	iinstall php
	iinstall mysql-server
	iinstall php-mysql
	iinstall php-common
	iinstall php-gd
	iinstall php-pear
	iinstall php-xmlrpc
	iinstall php-curl
	iinstall php-mbstring
	iinstall php-gettext
	iinstall zip
	iinstall screen
	iinstall git
	iinstall nant
	iinstall libopenjp2-tools
	iinstall graphicsmagick
	iinstall imagemagick
	iinstall curl
	iinstall php-cli
	iinstall php-bcmath
	iinstall dialog
	iinstall at
}

function installfinish()
{
	apt update
	apt upgrade
	apt -f install
    reboot now
}

function help()
{
    echo " ubuinstall.sh [action]"
    echo " "
    echo " you cannot install anything twice"
    echo " "
    
    echo "action :"
        echo "su / serverupgrade - server upgrade"     
        echo "iw / installwordpress - for cms server"
        echo "io / installobensimulator - for virtual worlds server"
        echo "m20 / monoinstall20 - mono install for Ubuntu 20"
        echo "m18 / monoinstall18 - mono install for Ubuntu 18"
        echo "if / installfinish - completion of the installations and restart"
        
    echo " "
}

case  $KOMMANDO  in
	if | installfinish) installfinish ;;
    io | installobensimulator) installobensimulator ;;
    iw | installwordpress) installwordpress ;;
    m20 | monoinstall20) monoinstall20 ;;
    m18 | monoinstall18) monoinstall18 ;;
    su | serverupgrade) serverupgrade ;;
	*) help ;;
esac
