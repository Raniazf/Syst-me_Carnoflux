#!/bin/bash


#Ce script permet de régénérer la page WEB du site de supervision à partir des fichiers .csv, toutes les 5 minutes et envoie des alertes par email en cas de problème.
#Nom du script : regen.sh
#Ce script est stocké sur le serveur HTTP dans le répertoire /bin (ne pas oublier de lui attribuer ses droits pour qu'il puisse s'exécuter).
#Ne pas oublier d'automatiser le script, utiliser "crontab -e" et ajouter : */5 * * * * /bin/regen.sh
#Ne pas oublier d'instaler : apt-get install mailutils / apt-get install mutt


today=`date '+%Y-%m-%d_%Hh%M'`  #On calcule la date d'aujourd'hui


CSV_client=`echo "/home/gonfreecs/Bureau/Admin/log_ip/log_ip.csv"`  #On indique le chemin où est stocké le fichier contenant les IPs des clients s'étant connectés la dernière heure
CSV_infos=`echo "/home/gonfreecs/Bureau/Admin/log_dns/log_dns.csv"`  #On indique le chemin où est stocké le fichier contenant des informations sur l’état de la connexion


IPs=`cat $CSV_client`  #On stocke les IPs dans une variable
Infos=`cat $CSV_infos`  #On stocke les informations dans une variable
NB_IP=`wc -l $CSV_client | cut -d' ' -f1`  #On calcule le nombre d'IPs pour savoir le nombre de clients et on le stocke dans une variable.


if [ -z $CSV_infos ] #Si le fichier est vide
then
	echo "ERREUR : il n'y a pas de fichier : log_dns.csv"
	echo "ERREUR : il n'y a pas de fichier : log_dns.csv" | mail -s "Alerte_Regen_$today" admin@carnofluxe.com  #On envoie une alerte par mail
fi


#On met en forme le code en html en y ajoutant nos données.
echo "<html>
  <head>
    <meta charset=utf-8>
    <title>Supervision</title>  
  </head>
  <body>
    <h1>Nombre de clients s'étant connectés durant la dernière heure : $NB_IP<br/>$IPs</h1>
  <body>
    <h1>$Infos</h1>
  </body>
</html>
" > /var/www/superv.carnofluxe/index.html  #On stocke le code dans un fichier .html

mv /home/gonfreecs/Bureau/Admin/log_dns/log_dns.csv /home/gonfreecs/Bureau/Admin/log_dns/log_dns_$today.csv  #On renomme le fichier de manière à les stocker suivant leur date et heure
