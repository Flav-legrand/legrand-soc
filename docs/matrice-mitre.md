# Couverture MITRE ATT&CK du laboratoire

| Tactique | Technique | Scénario | Détection | Règle(s) |
|---|---|---|---|---|
| Reconnaissance | T1595.003 Wordlist Scanning | 01 | Erreurs 4xx en rafale, fichiers sensibles | 100120, 100121 |
| Accès initial | T1190 Exploit Public-Facing Application | 03 | Motif SQLi dans l'URL, erreur SQL, UNION exécutée | 100110, 100111, 100112 |
| Accès aux identifiants | T1110.001 Password Guessing | 02, 04 | Échecs répétés (web et SSH) | 100101, 100102, 5712 |
| Accès initial / persistance | T1078 Valid Accounts | 02 | Succès après force brute | 100103 |
| Mouvement latéral | T1021.004 Remote Services: SSH | 04 | Succès SSH après force brute | 100130 |
| Collecte | T1005 Data from Local System | 03 | Extraction par UNION | 100112 |
| Persistance | T1505.003 Web Shell | 05 | Nouveau fichier PHP (FIM en temps réel) | 100150 |
| Persistance | T1136 Create Account | 06 | Création d'un utilisateur | 5902 (native) |
| Élévation de privilèges | T1098 / T1548.003 | 06 | Ajout au groupe sudo, modification de /etc/group | 100140, 100151 |

Réponse automatique : `firewall-drop` (10 min) sur 100102, 100120 et 100130.
