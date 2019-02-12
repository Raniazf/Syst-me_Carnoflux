#!/bin/bash

#Ce script permet de stocker dans un fichier .csv, des informations sur l’état de la connexion toutes les 5 minutes et envoie des alertes par email en cas de problème.
#Nom du script : log_dns.sh
#Ce script est stocké sur le serveur DNS esclave dans le répertoire /bin (ne pas oublier de lui attribuer ses droits pour qu'il puisse s'exécuter).
#Ne pas oublier d'automatiser le script, utiliser "crontab -e" et ajouter : */5 * * * * log_dns.sh
#Ne pas oublier d'instaler : apt-get install mailutils / apt-get install mutt / apt-get install ssh / apt-get install openssh-server / apt-get install sshpass


today=`date '+%Y-%m-%d_%Hh%M'`  #On calcule la date d'aujourd'hui

ip_serveur="192.168.10.10"  #On indique l'ip du serveur http

url_site="site.carnofluxe.domain"  #On indique l'url du site
#ip_site=`nslookup $url_site | sed -n '6p' | cut -c10-23`  #On récupère l'ip du site (ne fonctionne pas)
ip_site=`dig $url_site | sed -n '15p' | cut -c36-48`  #On récupère l'ip du site



ping -c 1 $ip_serveur | cut -d"=" -f4 | sed -n '2p' > "log_dns.csv"  #On essaie de récupérer le temps de connexion
status=`cat "log_dns.csv"`  #On stocke ce temps dans une variable


if [ -n "$status" ]  #Si la variable n'est pas vide, alors...
then
	echo "Connexion établie entre votre machine et le serveur HTTP !</br>" > "log_dns.csv"  #On indique que la connexion est établie
	if [ -n "$ip_site" ]  #S'il trouve une ip à partir de l'URL (en utilisant le DNS), alors...
	then
		echo "Adresse ip du site : $ip_site </br>" >> "log_dns.csv"  #On affiche l'ip du site
		echo "Temps de connexion avec le site : $status </br>" >> "log_dns.csv"  #On affiche son temps de connexion
		wget $url_site 2> "log_dns_tempo.tmp"  #On télécharge la page et on récupère toutes les informations
		temps_charge=`sed -n '8p' "log_dns_tempo.tmp" | cut -c74-75`  #On récupère l'information concernant le temps de chargement
		if [ -n "$temps_charge" ]  #S'il trouve une ip à partir de wget, alors...
		then
			echo "Temps de chargement de la page : $temps_charge </br>" >> "log_dns.csv"  #On affiche le temps de chargement
			rm index.html  #On supprime la page téléchargée
		else
			echo "ERREUR : impossible d'accéder au site via son nom de domaine ! </br>" >> "log_dns.csv"  #On affiche un message d'erreur
			echo "ERREUR : impossible d'accéder au site via son nom de domaine !" | mail -s "Alerte_DNS_$today" admin@carnofluxe.com  #On envoie une alerte par mail
		fi
	
	else  #S'il n'arrive pas à trouver l'ip du site, alors...
		echo "ERREUR : impossible d'accéder au site !</br>" >> "log_dns.csv"  #On affiche un message d'erreur
		echo "ERREUR : impossible d'accéder au site !" | mail -s "Alerte_DNS_$today" admin@carnofluxe.com  #On envoie une alerte par mail
	fi
	
else  #S'il n'arrive pas à ping le serveur, alors...
	echo "ERREUR : aucune connexion entre votre machine et le serveur HTTP !</br>" >> "log_dns.csv"  #On affiche un message d'erreur
	echo "ERREUR : aucune connexion entre votre machine et le serveur HTTP !" | mail -s "Alerte_DNS_$today" admin@carnofluxe.com  #On envoie une alerte par mail
fi



sshpass -p "   " scp "log_dns.csv" gonfreecs@192.168.10.10:/home/gonfreecs/Bureau/Admin/log_dns  #On envoie le fichier sur le serveur http grâce au protocole ssh
#scp "log_dns.csv" gonfreecs@192.168.10.10:/home/gonfreecs/Bureau/Admin/log_dns  #On envoie le fichier sur le serveur http grâce au protocole ssh

rm log_dns_tempo.tmp 2>/dev/null  #On supprime le fichier temporaire





