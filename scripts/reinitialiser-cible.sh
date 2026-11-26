#!/bin/bash
# Remet la cible dans son état initial après les exercices.
docker exec legrand-cible sh -c 'rm -f /var/www/html/uploads/shell.php; userdel -r support.tmp 2>/dev/null; gpasswd -d stagiaire sudo 2>/dev/null; iptables -F 2>/dev/null; true'
echo "[+] Cible réinitialisée"
