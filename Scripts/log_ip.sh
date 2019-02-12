#!/bin/bash
#Ce script permet de stocker dans un fichier .csv, les IPs des clients s'étant connectés la dernière heure
#Ne pas oublier d'automatiser le script : utiliser "crontab -e" et ajouter : 59 * * * * log_ip.sh

mkdir /home/gonfreecs/Bureau/Admin/ 2>/dev/null  #On crée un dossier si cela n'est pas déjà fait
mkdir /home/gonfreecs/Bureau/Admin/log_ip 2>/dev/null  #On crée un dossier si cela n'est pas déjà fait
mkdir /home/gonfreecs/Bureau/Admin/log_dns 2>/dev/null  #On crée un dossier si cela n'est pas déjà fait

rm /home/gonfreecs/Bureau/Admin/log_ip/log_ip.csv #On supprime l'ancien fichier .csv

heure_actu=`date +%H`  #On stocke l'heure actuelle
jour_actu=`date +%e`  #On stocke le jour actuel


cat /var/log/apache2/access.site.carnofluxe.domain.log | while read ligne;  #Tant qu'il y a une ligne dans le fichier...
do
	jour_x=`echo $ligne | cut -d" " -f4 | cut -d"/" -f1 | cut -d"[" -f2` #On récupère le jour
	heure_x=`echo $ligne | cut -d" " -f4 | cut -d":" -f2`  #On récupère l'heure

	if [ $jour_x -eq $jour_actu ] && [ $heure_x -eq $heure_actu ] #Si le jour et l'heure sont identiques...
	then
		ip=`echo $ligne | cut -d" " -f1`  #On récupère l'ip
	    	#pays=`GET http://ip-api.com/csv/$ip | cut -d, -f2`  #On récupère le pays grâce à une api (ne fonctionne pas car pas d'accès à internet)
	    	#echo $ip, $pays >> log_ip_tempo.tmp  #On stocke l'ip et le pays dans un fichier temporaire (ne fonctionne pas car pas d'accès à internet)
		echo $ip, >> log_ip_tempo.tmp  #On stocke l'ip dans un fichier temporaire
	fi
	if [ -n "log_ip_tempo.tmp" ]  #Dans le cas où notre fichier n'a pas été créé (car il n'y avait aucun clien durant la dernière heure)
	then
		touch "log_ip_tempo.tmp"  #On crée le fichier temporaire
	fi
done


cat log_ip_tempo.tmp | uniq >> /home/gonfreecs/Bureau/Admin/log_ip/log_ip.csv  #On stocke le tout dans un fichier .csv
rm log_ip_tempo.tmp 2>/dev/null  #On supprime le fichier temporaire
