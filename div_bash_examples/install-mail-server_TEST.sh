#!/bin/bash

# Überprüfe, ob der Benutzer Root-Rechte hat
if [ "$(id -u)" != "0" ]; then
    echo "Das Skript benötigt Root-Rechte zur Installation."
    exit 1
fi

# Dialog-Boxen für die Eingabe von Konfigurationsdetails
hostname=$(dialog --inputbox "Gib den Hostnamen für den Mail-Server an:" 8 40 --output-fd 1)
if [ -z "$hostname" ]; then
    echo "Der Hostname darf nicht leer sein. Abbruch."
    exit 1
fi

domain=$(dialog --inputbox "Gib die Domain für den Mail-Server an:" 8 40 --output-fd 1)
if [ -z "$domain" ]; then
    echo "Die Domain darf nicht leer sein. Abbruch."
    exit 1
fi

email=$(dialog --inputbox "Gib die Haupt-E-Mail-Adresse für den Administrator an:" 8 40 --output-fd 1)
if [ -z "$email" ]; then
    echo "Die E-Mail-Adresse darf nicht leer sein. Abbruch."
    exit 1
fi

# Installiere erforderliche Pakete
apt update
apt install -y postfix dovecot-imapd dovecot-pop3d

# Konfiguriere Postfix
postconf -e "myhostname=$hostname.$domain"
postconf -e "mydestination=$hostname.$domain, $hostname, localhost.localdomain, localhost"
postconf -e "mynetworks=127.0.0.0/8 [::ffff:127.0.0.0]/104 [::1]/128"
postconf -e "inet_interfaces=all"
postconf -e "inet_protocols=ipv4"

# Konfiguriere Dovecot
sed -i "s/#protocols = imap pop3 lmtp/protocols = imap pop3 lmtp/" /etc/dovecot/dovecot.conf
sed -i "s/#disable_plaintext_auth = yes/disable_plaintext_auth = no/" /etc/dovecot/conf.d/10-auth.conf

# SSL/TLS-Zertifikat erstellen (optional, aber empfohlen)
openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout /etc/ssl/private/mailserver.key -out /etc/ssl/certs/mailserver.crt

# Konfiguriere SSL/TLS in Dovecot
sed -i "s/#ssl = yes/ssl = yes/" /etc/dovecot/conf.d/10-ssl.conf
sed -i "s/#ssl_cert = <\/etc\/dovecot\/dovecot\.pem/ssl_cert = <\/etc\/ssl\/certs\/mailserver.crt/" /etc/dovecot/conf.d/10-ssl.conf
sed -i "s/#ssl_key = <\/etc\/dovecot\/private\/dovecot\.pem/ssl_key = <\/etc\/ssl\/private\/mailserver.key/" /etc/dovecot/conf.d/10-ssl.conf

# Dienste neu starten
systemctl restart postfix
systemctl restart dovecot

# Firewall-Konfiguration
ufw allow 25
ufw allow 143
ufw allow 110

# Abschlussmeldung
dialog --msgbox "Mail-Server wurde installiert und konfiguriert.\nHostname: $hostname\nDomain: $domain\nAdmin E-Mail: $email" 10 50
