#!/bin/bash
# Rejoue toute la chaîne d'attaque, dans l'ordre d'une intrusion réaliste (kill chain).
set -e
A="docker exec legrand-attaquant"
pause(){ echo; echo "---- $1 (pause 20 s pour observer le tableau de bord Wazuh) ----"; sleep 20; }
$A /scenarios/01-reconnaissance.sh;       pause "Reconnaissance terminée"
$A /scenarios/02-force-brute-web.sh;      pause "Force brute web terminée"
$A /scenarios/03-injection-sql.sh;        pause "Injection SQL terminée"
$A /scenarios/04-force-brute-ssh.sh;      pause "Force brute SSH terminée"
"$(dirname "$0")/05-webshell.sh";         pause "Dépôt de fichier suspect terminé"
"$(dirname "$0")/06-elevation-privileges.sh"
echo; echo "[+] Scénarios terminés. Tableau de bord : https://localhost  (Threat Hunting → filtre rule.groups: legrand)"
