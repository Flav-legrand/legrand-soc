#!/bin/bash
# Scénario 6 — Persistance et élévation de privilèges (MITRE T1098 Account Manipulation, T1548.003 Sudo)
# Attendu : 100140 (ajout au groupe sudo), règles natives 5902 (nouvel utilisateur), 5402 (sudo vers root), 550 (FIM /etc/group)
docker exec legrand-cible sh -c '
  useradd -m support.tmp && echo "support.tmp:Temp1234" | chpasswd
  usermod -aG sudo stagiaire
  su - stagiaire -c "echo stagiaire2026 | sudo -S id"
'
