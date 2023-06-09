= Procédure installation sur Debian 10 (Xivo version 2021.07-latest)
:navtitle: Install Xivo / Debian 10

.Intro
****
J'ai choisi d'installer xivo sur une *debian 10* car le `nexus de l'eni` ne semble pas disposer de la de *debian 11*.
****


== Préparation des VM


.VM Serveur Xivo - (`sl-debian-xivo`)
|===
| Number of Cores per processor | 4
| Memory                        | 6 144 MB
| Hard Disk                     | 100 GB
| Network Adapter (eth0)        | *Bridge* +
C'est par ici que passera le traffic internet durant le processus d'install et de mise à jour.
| Network Adapter 2 (eth1)      | *Segment LAN "VOICE"* (pour communiquer avec la VM Client)
|===

.VM Client Xivo - (`pw-xivo`)
|===
| Memory                        | 4 096 MB
| Network Adapter (eth0)        | *Bridge* +
C'est par ici que passera le traffic internet durant le processus d'install et de mise à jour.
| Network Adapter 2 (eth1)      | *Segment LAN "VOICE"* (pour communiquer avec la VM Serveur)
|===


== Installation de Xivo

=== Plan A - Install Via ISO `xivo-2021.07.04-amd64.iso` (méthode auto)

Après avoir soigneusement récupéré l'iso depuis le partage *Distrib de l'eni* et reconfiguré la vm (*sl-debian-xivo*) afin de prendre en charge l'iso...

Il reste plus qu'à lancé l'install automatique.

Après...un...certain...moment.

Il devrai avoir ce résultat à la fin de l'installation, si c'est le cas passer à l'*étape configuration Réseau*

image::tssr2023/module-07/01.png[]

sinon il ce peut que l'install ce bloquer à 40% à cause du proxy entre autre.

image::tssr2023/module-07/02.png[]

NOTE: Maintenant que le proxy de l'eni à été désactivé, il ne devrais pas avoir ce problème.

=== Plan B - L'install auto à échoué

L'installation à échouer à l'étape *appelle du script simple-cdd* cependant *debian* lui est installé.

Après un reboot procéder à l'installation de xivo

.Nécessaire si installation depuis iso debian.
****

image::tssr2023/module-07/03.png[]



* Dans le fichier `/etc/sysctl.conf` : Ajouter la valeur suivant : `vm.swappiness = 20`
* Cette commande `dpkg-reconfigure locales` permet de reconfigurer les locales et les mettre en en_US.UTF-8
* Pour renommer les interfaces en eth# : 

[source,bash]
----
# Modification fichier grub
vim /etc/default/grub +':%s/\(GRUB_CMDLINE_LINUX="\)/\1net.ifnames=0 biosdevname=0/' +':wq'
# Appliquer les modification
grub-mkconfig -o /boot/grub/grub.cfg
# Redémarrage du serveur
reboot
----

.Fichier : `/etc/network/interface`
----
# This file describes the network interfaces available on your system
# and how to activate them. For more information, see interfaces(5).

source /etc/network/interfaces.d/*

# The loopback network interface
auto lo
iface lo inet loopback

# Remplacement des instruction suivante
#auto ens33
#iface ens33 inet dhcp

# par celle-ci.
auto eth0
iface eth0 inet dhcp
----
****

[NOTE,caption=Source]
====
* *ens33 to eth0* -> https://www.itzgeek.com/how-tos/linux/debian/change-default-network-name-ens33-to-old-eth0-on-debian-9.html[Renomer adaptateur network]
* *swappiness* -> https://askubuntu.com/questions/103915/how-do-i-configure-swappiness[]
====


[CAUTION,caption=Moyen contournement]
====
.Fichier /etc/hosts
----
143.204.231.123 download.docker.com
212.27.32.66  ftp.fr.debian.org
151.101.130.132 security.debian.org
----

.Fichier /etc/resolv.conf
----
nameserver 8.8.8.8
----
*nécessaire si le dns menteur de l'ENI emmerde l'installation.*
====

==== Installation de xivo.
[source,bash]
----
#Télécharger le script d'installation de xivo
wget http://mirror.xivo.solutions/xivo_install.sh
# Autorisé le mode exécution du script
chmod +x xivo_install.sh
# Lancer la commande suivante afin d'installer la version de xivo 2021.07-latest
./xivo_install.sh -a 2021.07-latest
----

.Installation terminé.
image::tssr2023/module-07/04.png[]

== Configuration du réseau Segment LAN (Voix)

=== Sur Linux

.Fichier : `/etc/network/interface`
----
# This file describes the network interfaces available on your system
# and how to activate them. For more information, see interfaces(5).

source /etc/network/interfaces.d/*

# The loopback network interface
auto lo
iface lo inet loopback

# Remplacement des instruction suivante
#auto ens33
#iface ens33 inet dhcp

# par celle-ci.
auto eth0
iface eth0 inet dhcp

auto eth1
iface eth1 inet static
    address 192.168.0.1/30
----

=== Sur WIndows


image::tssr2023/module-07/05.png[]

== Configuration Serveur Xivo via HTTPS

En théorie L'accès à l'interface web devrait ce faire.

image::tssr2023/module-07/06.png[]


