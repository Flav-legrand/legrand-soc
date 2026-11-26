#!/bin/bash
# Scénario 1 — Reconnaissance (MITRE T1595 Active Scanning / T1046 Network Service Discovery)
# Attendu : alerte Legrand 100120 (balayage web, nombreuses 404) + alertes web natives Wazuh
CIBLE=${CIBLE:-cible}
echo "[*] Scan des ports de $CIBLE"
nmap -sV -T4 -p 22,80,443,3306,8080 "$CIBLE"
echo "[*] Recherche de répertoires sensibles (énumération web)"
for p in admin backup .git .env config.php phpmyadmin wp-login.php server-status db.sql old test api/v1 uploads/shell.php login.bak; do
  code=$(curl -s -o /dev/null -w "%{http_code}" "http://$CIBLE/$p")
  echo "  /$p -> $code"
done
for i in $(seq 1 10); do curl -s -o /dev/null "http://$CIBLE/inexistant-$RANDOM"; done
echo "[+] Terminé"
