#!/bin/bash
date=`date '+%Y-%m-%d%Hh%M'` #Variable contenant la date.
BACKUP="media/gonfreecs/CLEF/Backup_inc/$date" #Variable contenant le chemin du dossier destination.
DOSSIER_Res="var/www" #Variable contenant le chemin du dossier ressouces.
rsync -a --no-o --no-g --delete /$DOSSIER_Res /$BACKUP #Rsync est une commande qui permet de synchroniser les dossiers, elle peut voir les modifications et ne sauvegarder que les modifications.

find /media/gonfreecs/CLEF/Backup_inc -mtime +1 -exec rm -fr {} \; #Cette commande va mettre de supprimer les dossiers/fichiers datant de x temps.

espace=`df / | sed -n '2p' | tr -s ' ' | cut -d ' ' -f 4` #Cette variable va permettre d'extraire la disponibilité de la machine. 

if [ $espace -lt 1000000 ]  #S'il est inférieur à 1 go
then
    #echo "ERREUR de sauvegarde"
    echo "ERREUR de sauvegarde" >> "/home/gonfreecs/Bureau/Admin/log_sav/log_inc/log$date.csv"  #On affiche un message d'erreur
    echo "ERREUR de sauvegarde" | mail -s "Alertesauvegarde$date" admin@carnofluxe.com  #On envoie une alerte par mail
fi

NBRE_FILES=find $BACKUP -type f -mtime -1 2>/dev/null | wc -l #Cette variable correspond à la recherche de la dernière sauvegarde dans le dossier destination
NBRE_FILES2=find $DOSSIER_Res -type f -mtime-1 2>/dev/null | wc -l #Cette variable correspond à la recherche de la dernière sauvegarde dans le dossier ressources
if [ ! -e $BACKUP/$DOSSIER_Res ] && [ "$NBRE_FILES" == 0 ] || [ "$NBREFILES2" == 0 ] #Ici, on compare le dossier ressources et destination donc si tous les fichiers/dossiers sont dans les deux dossiers alors il n'y a pas de problèmes sinon les erreurs seront stockées dans un fichier log et envoyées par mail.
then
        echo "Il n'y a pas de problème. \n" >> "/home/gonfreecs/Bureau/log$date.cvs"
else 
        echo "Erreur de sauvegarde incrémentale du $date" | mail -s "Erreur de sauvegarde" root 
    echo "ERREUR de sauvegarde incrémentale" >> "/home/gonfreecs/Bureau/Admin/log_sav/log_inc/log_$date.csv"

fi
