#!/bin/sh
date=date '+%Y-%m-%d%Hh%M'
# Enregistrez ce script sous le nom de backup.sh. Prennez note de son emplacement.

echo "------------------------------------------------------";
echo "- Sauvegarde complète du système";
echo "------------------------------------------------------";
echo "";

echo "Création de l'archive";

# On crée l'archive .tar en précisant entre guillemets les chemins absolus des dossiers à sauvegarder.
tar -cvzf /media/gonfreecs/CLEF/Backup_com/backup_$date.tar.gz "/var/www"
find /media/gonfreecs/CLEF/Backup_com -mtime +1 -exec rm -fr {} ;
echo "------------------------------------------------------";
echo "";

echo "Vérification de l'existence de l'archive";
# On teste si l'archive a bien été créée
if [ -e "/media/gonfreecs/CLEF/Backup_com/backup_$date.tar.gz" ]
 then
#mv "/media/gonfreecs/CLEF/Backup_com/backup.tar.gz" "/media/gonfreecs/CLEF/Backup_com/backup$date.tar.gz"
    echo ""
    echo "Votre archive a bien été créée.";
    echo ""
 else
    echo ""
    echo "Il y a eu un problème lors de la création de l'archive.";
    echo "Erreur de sauvegarde incrémentale du $today" | mail -s "Erreur de sauvegarde" root 
    echo "ERREUR de sauvegarde incrémentale" >> "/home/gonfreecs/Bureau/Admin/log_sav/log_comp/log_$today.csv"
echo ""
fi

echo "### Fin de la sauvegarde.  ###";
