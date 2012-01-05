#!/bin/bash
#
# Ce script installe OpenVAS-4 sur Debian Squeeze
# Lotaut Brian aka LBTM - 01/2012
# Script libre: GPLv3
#
# Syntaxe: # su - ./openvas4autoinstall.sh
script_version="0.1"

# Variables
ARCH=$(uname -m)
LOG_FILE="/tmp/openvas4autoinstall.log"
OPENVASTMP="/tmp/openvas4"
APT="apt-get -y install"
DPKG="dpkg -i"

# Test que le script est lance en root
if [ "$(id -u)" != "0" ]; then
	echo "Le script doit etre execute en tant que root."
  echo "Syntaxe: su - ./openvas4autoinstall.sh"
  exit 1
fi

# Fonctions
check_dir(){
if [ -d $OPENVASTMP  ]; then
	rm -rf $OPENVASTMP
	mkdir $OPENVASTMP
else
	mkdir $OPENVASTMP
fi
}

download_packages(){
check_dir
if [ "$ARCH" == 'x86_64' ]; then
  cd $OPENVASTMP
  echo "Telechargement des binaires x86_64"
  wget http://download.opensuse.org/repositories/security:/OpenVAS:/STABLE:/v4/Debian_6.0/amd64/greenbone-security-assistant_2.0.1-1_amd64.deb
  wget http://download.opensuse.org/repositories/security:/OpenVAS:/STABLE:/v4/Debian_6.0/amd64/libmicrohttpd10_0.9.17-1_amd64.deb
  wget http://download.opensuse.org/repositories/security:/OpenVAS:/STABLE:/v4/Debian_6.0/amd64/libopenvas4_4.0.6-1_amd64.deb
  wget http://download.opensuse.org/repositories/security:/OpenVAS:/STABLE:/v4/Debian_6.0/amd64/openvas-administrator_1.1.2-1_amd64.deb
  wget http://download.opensuse.org/repositories/security:/OpenVAS:/STABLE:/v4/Debian_6.0/amd64/openvas-cli_1.1.4-1_amd64.deb
  wget http://download.opensuse.org/repositories/security:/OpenVAS:/STABLE:/v4/Debian_6.0/amd64/openvas-manager_2.0.4-1_amd64.deb
  wget http://download.opensuse.org/repositories/security:/OpenVAS:/STABLE:/v4/Debian_6.0/amd64/openvas-scanner_3.2.5-1_amd64.deb
  wget http://mirrors.kernel.org/debian/pool/main/g/glib2.0/libglib2.0-0_2.24.2-1_amd64.deb
  wget http://mirrors.kernel.org/debian/pool/main/libp/libpcap/libpcap0.8_1.1.1-2+squeeze1_amd64.deb
  wget http://mirrors.kernel.org/debian/pool/main/libx/libxslt/libxslt1.1_1.1.26-6_amd64.deb
else
  cd $OPENVASTMP
  echo "Telechargement des binaires i386"
  wget http://download.opensuse.org/repositories/security:/OpenVAS:/STABLE:/v4/Debian_6.0/i386/greenbone-security-assistant_2.0.1-1_i386.deb
  wget http://download.opensuse.org/repositories/security:/OpenVAS:/STABLE:/v4/Debian_6.0/i386/libmicrohttpd10_0.9.17-1_i386.deb
  wget http://download.opensuse.org/repositories/security:/OpenVAS:/STABLE:/v4/Debian_6.0/i386/libopenvas4_4.0.6-1_i386.deb
  wget http://download.opensuse.org/repositories/security:/OpenVAS:/STABLE:/v4/Debian_6.0/i386/openvas-administrator_1.1.2-1_i386.deb
  wget http://download.opensuse.org/repositories/security:/OpenVAS:/STABLE:/v4/Debian_6.0/i386/openvas-cli_1.1.4-1_i386.deb
  wget http://download.opensuse.org/repositories/security:/OpenVAS:/STABLE:/v4/Debian_6.0/i386/openvas-manager_2.0.4-1_i386.deb
  wget http://download.opensuse.org/repositories/security:/OpenVAS:/STABLE:/v4/Debian_6.0/i386/openvas-scanner_3.2.5-1_i386.deb
  wget http://mirrors.kernel.org/debian/pool/main/g/glib2.0/libglib2.0-0_2.24.2-1_i386.deb
  wget http://mirrors.kernel.org/debian/pool/main/libp/libpcap/libpcap0.8_1.1.1-2+squeeze1_i386.deb
  wget http://mirrors.kernel.org/debian/pool/main/libx/libxslt/libxslt1.1_1.1.26-6_i386.deb
fi 
}

firewall(){
echo "Definition des regles firewall"
  /sbin/iptables -A INPUT -p tcp --dport 9390 -j ACCEPT
  /sbin/iptables -A INPUT -p tcp --dport 9392 -j ACCEPT
  /sbin/iptables -A INPUT -p tcp --dport 9393 -j ACCEPT
echo "Terminer"
}

check_arch(){
if [ "$ARCH" == 'x86_64' ]; then
	ARCH="amd64"
else 
	ARCH="i386"
fi
}

install() {
  cd $OPENVASTMP
  check_arch
  echo ""
  echo "=============================================================================="
  echo "Les paquets suivant seront installé:"
  echo "=============================================================================="
    echo "- libopenvas4_4.0.6-1_$ARCH.deb                    -> Librairie d'OpenVAS"
    echo "- openvas-scanner_3.2.5-1_$ARCH.deb                -> Serveur lançant les scans"
    echo "- openvas-manager_2.0.4-1_$ARCH.deb                -> Interface d'analyse des scans"
    echo "- openvas-administrator_1.1.2-1_$ARCH.deb          -> Administration d'OpenVAS"
    echo "- libmicrohttpd10_0.9.17-1_$ARCH.deb               -> Serveur http pour GSA"
    echo "- greenbone-security-assistant_2.0.1-1_$ARCH.deb   -> Client web"
    echo "- openvas-cli_1.1.4-1_$ARCH.deb                    -> Client d'OpenVAS"
  echo "=============================================================================="
  echo ""
  echo "Installation des librairies"
  $DPKG libglib2.0-0_2.24.2-1_$ARCH.deb
  $DPKG libpcap0.8_1.1.1-2+squeeze1_$ARCH.deb
  $DPKG libxslt1.1_1.1.26-6_$ARCH.deb
  echo ""
  echo "Installation libopenvas4"
  $DPKG libopenvas4_4.0.6-1_$ARCH.deb
  echo "Termine"
  echo "" 
  echo "Installation openvas-scanner"
  $DPKG openvas-scanner_3.2.5-1_$ARCH.deb
  echo "Termine"
  echo ""  
  echo "Installation openvas-manager"
  $DPKG openvas-manager_2.0.4-1_$ARCH.deb
  echo "Termine"
  echo ""
  echo "Installation openvas-administrator"
  $DPKG openvas-administrator_1.1.2-1_$ARCH.deb
  echo "Termine"
  echo ""
  echo "Installation libmicrohttpd"
  $DPKG libmicrohttpd10_0.9.17-1_$ARCH.deb
  echo "Termine"
  echo ""
  echo "Installation greenbone-security-assistant"
  $DPKG greenbone-security-assistant_2.0.1-1_$ARCH.deb
  echo "Termine"
  echo ""
  echo "Installation openvas-cli"
  $DPKG openvas-cli_1.1.4-1_$ARCH.deb
  echo "Termine"
  echo ""
  echo "Voulez-vous installer les packets pour la generation de rapport ? (o/n)"
  read reponse
  if [ $reponse == 'o' ]; then
    $APT texlive-latex-base texlive-latex-extra texlive-latex-recommended htmldoc
  fi
  echo "Les paquets ont ete installe"
}

create_user_openvas() {
  echo "Creer un utilisateur pour l'IHM OpenVAS:"
  read user
  test -e /var/lib/openvas/users/admin || openvasad -c add_user -n $user -r Admin
}

restart_openvas() {
  echo "Redemarrage des services OpenVAS:"
    killall openvassd
    /etc/init.d/openvas-scanner start
    /etc/init.d/openvas-manager start
    /etc/init.d/openvas-administrator restart
  echo "Termine"
}

configure(){
  echo ""
  echo "=============================================================================="
  echo "Configuration d'OpenVAS."
  echo "=============================================================================="
  echo ""
  echo "Installation du certificat serveur d’OpenVAS"
    test -e /var/lib/openvas/CA/cacert.pem || openvas-mkcert -q
  echo "Terminer"
  echo ""
  echo "Installation des signatures de vulnerabilites (Network Vulnerability Tests)"
    openvas-nvt-sync
  echo "Terminer"
  echo ""
  echo "Installation du certificat client"
    test -e /var/lib/openvas/users/om || openvas-mkcert-client -n om -i
  echo "Terminer"
  echo "----"
  echo "Arret des services openvas-manager et openvas-scanner"
  echo "----"
  echo "OpenVAS Manager"
    /etc/init.d/openvas-manager stop
  echo "Termine"
  echo ""
  echo "OpenVAS Scanner"
    /etc/init.d/openvas-scanner stop
  echo "Termine"
  echo ""
  echo "Chargement des signatures de vulnerabilites"
    openvassd
  echo "Termine"
  echo ""
  echo "Liaison du Manager au Scanner"
    openvasmd --migrate
  echo "Termine"
  echo ""
  echo "Reconstruction de la base de vulnerabilites"
    openvasmd --rebuild
  echo "Termine"
  echo ""
    restart_openvas
  echo ""
  echo "Lancement de l'interface web en permettant aux IPs de votre choix de s'y connecter (par défaut localhost), precisant le port (9392), l'emplacement de l'administrator, du manager et leur ports:"
    gsad --listen=127.0.0.1 --port=9392 --alisten=127.0.0.1 --aport=9393 --mlisten=127.0.0.1 --mport=9390
  echo ""
    create_user_openvas
  echo ""
}

end() {
  echo ""
  echo "=============================================================================="
  echo "Installation d'OpenVAS-4 termine"
  echo "=============================================================================="
  echo "Connection a l'interface d'administration      :  https://@ip-du-serveur:9392"
  echo "=============================================================================="
  echo ""
}

# Execution du programme
download_packages
install
firewall
configure
end
# Fin du script