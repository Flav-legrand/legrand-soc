# Rapport d'incident — INC-2026-001 *(exercice en laboratoire)*

> Rapport rédigé à partir de l'exercice rejoué par `scripts/lancer-scenarios.sh`. Les horodatages sont **illustratifs** : remplacez-les par ceux de vos propres alertes Wazuh lors de la démonstration, et joignez les captures du tableau de bord.

| Champ | Valeur |
|---|---|
| Classification du document | Confidentiel — exercice |
| Rédacteur | E. Flav-Legrand Mongouo, analyste SOC / RSSI |
| Priorité | **P1** (compromission de compte, extraction de données, persistance) |
| Catégorie | Intrusion applicative et système |
| Actifs touchés | Application Legrand$ (espace client), serveur `legrand-cible`, base clients |
| Statut | Clos (exercice) |

## 1. Résumé pour la Direction
Un attaquant interne au réseau du laboratoire a cartographié le serveur web, deviné le mot de passe d'un client, puis exploité une **injection SQL** pour extraire **la table complète des clients (identifiants et mots de passe en clair)**. Il a ensuite obtenu un accès SSH avec un mot de passe faible, déposé un fichier PHP dans le site et donné des droits d'administration à un compte. Toutes les étapes ont été **détectées par le SOC** (14 règles personnalisées) ; l'IP a été bloquée automatiquement après la force brute. **Décisions demandées :** prioriser la correction du code, le MFA client et le hachage des mots de passe.

## 2. Chronologie
| Heure | Événement | Alerte | Technique |
|---|---|---|---|
| 10:00 | Scan de ports et énumération web (`/.git`, `/.env`, 404 en série) | 100121, 100120 | T1595 |
| 10:01 | 10 échecs de connexion sur le compte `amoukouama` | 100101 → 100102 | T1110.001 |
| 10:01 | Connexion réussie depuis la même IP | **100103** (niveau 13) | T1078 |
| 10:01 | Réponse active : IP bloquée 10 min sur la cible | firewall-drop | — |
| 10:02 | Charges SQL sur `/compte.php?q=` ; erreurs SQL | 100110, 100111 | T1190 |
| 10:02 | `UNION SELECT ... FROM clients` exécutée avec succès | **100112** (niveau 14) | T1005 |
| 10:03 | Force brute SSH sur `stagiaire`, puis succès | 5712 → **100130** | T1021.004 |
| 10:04 | Création de `/var/www/html/uploads/shell.php` | **100150** | T1505.003 |
| 10:05 | `stagiaire` ajouté au groupe `sudo`, compte `support.tmp` créé | 100140, 100151, 5902 | T1098 |

## 3. Analyse technique
- **Vecteur d'entrée :** mot de passe faible et absence de limitation des tentatives (application et SSH).
- **Vulnérabilités exploitées :** concaténation SQL dans `compte.php` (CWE-89) ; mots de passe stockés en clair (CWE-256) ; authentification SSH par mot de passe.
- **Indicateurs de compromission :** IP du conteneur `legrand-attaquant` ; comptes `amoukouama`, `stagiaire`, `support.tmp` ; fichier `uploads/shell.php`.

## 4. Actions de réponse (selon les playbooks)
| Phase | Action | Playbook |
|---|---|---|
| Confinement | Blocage de l'IP (automatique), désactivation des comptes `amoukouama` et `stagiaire`, suppression de `support.tmp` | PB-01, PB-04 |
| Confinement | Préservation des preuves (`docker commit`, copie des journaux et du fichier PHP) | PB-03 |
| Éradication | Requête préparée dans `compte.php`, suppression du fichier PHP, retrait du groupe `sudo` | PB-02, PB-03, PB-04 |
| Rétablissement | Réinitialisation de tous les mots de passe clients, hachage bcrypt, SSH par clé uniquement | PB-01, PB-02 |

## 5. Impact (s'il s'agissait d'un environnement réel)
Violation de données personnelles de **tous les clients** (notification réglementaire probable), risque de fraude, compromission complète du serveur web.

## 6. Retour d'expérience
- **Points forts :** détection de chaque étape, corrélation « succès après force brute », réponse active en quelques secondes.
- **À améliorer :** l'injection SQL n'a pas été bloquée (absence de WAF) ; aucune alerte avant l'extraction, faute de détection des erreurs SQL en préproduction.
- **Actions reportées dans Legrand GRC :** risques R-002 et R-004, mesures 8.5, 8.24, 8.26, 8.28 et 8.29.

## 7. Indicateurs (exercice)
MTTD < 1 min (alertes en temps réel) · MTTC ≈ 1 min pour la force brute (automatique) · MTTC manuel à mesurer pendant la démonstration.
