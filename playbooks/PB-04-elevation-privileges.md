# PB-04 — Élévation de privilèges et persistance

**Déclencheurs :** **100140** (ajout à un groupe à privilèges), 100151 (modification de `/etc/passwd`, `/etc/group` ou `/etc/sudoers`), 5902 (nouvel utilisateur), 5402 (sudo vers root)
**MITRE ATT&CK :** T1098 Account Manipulation · T1548.003 Sudo and Sudo Caching · T1136 Create Account

## 1. Détection et analyse
1. Qui a fait la modification ? Croiser l'alerte avec les sessions ouvertes au même moment (SSH, `sudo`, `su`).
2. La modification correspond-elle à une **demande de changement approuvée** (ticket) ? Si non, l'incident est confirmé.
3. Lister les comptes à privilèges : `getent group sudo`, `cat /etc/sudoers.d/*`, et repérer les comptes récents (`/etc/passwd`).

## 2. Confinement
- [ ] Retirer le compte du groupe à privilèges (`gpasswd -d <user> sudo`) et verrouiller les comptes créés illégitimement (`usermod -L`).
- [ ] Couper les sessions actives de l'attaquant.
- [ ] Si un compte d'administration est compromis, considérer **tout le serveur comme compromis** et passer à la reconstruction.

## 3. Éradication et rétablissement
- Rechercher les autres mécanismes de persistance : crontab, services systemd, clés SSH, binaires SUID ajoutés.
- Reconstruire depuis une image de référence, puis faire tourner les mots de passe et les clés.

## 4. Mesures durables
Gestion des accès à privilèges (PAM / bastion) (8.2), revue semestrielle des habilitations (5.18), alertes sur les groupes à privilèges (8.16), processus de gestion des changements (8.32).
