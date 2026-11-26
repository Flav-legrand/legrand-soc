# PB-03 — Webshell et compromission du serveur web

**Déclencheur :** **100150** (nouveau fichier `.php` sous `/var/www/html`, surveillance d'intégrité en temps réel)
**MITRE ATT&CK :** T1505.003 Web Shell

## 1. Détection et analyse
1. Relever le chemin, l'horodatage, le propriétaire et l'empreinte (SHA-256) du fichier dans l'alerte FIM.
2. **Ne pas ouvrir le fichier dans un navigateur.** Récupérer une copie pour analyse : `docker cp legrand-cible:/var/www/html/uploads/shell.php ./preuves/`.
3. Corréler avec les journaux Apache : quelle requête a précédé la création (upload, exploitation) ? Le fichier a-t-il été appelé ensuite (`grep shell.php access.log`) ?
4. Rechercher d'autres fichiers récents : `find /var/www -newer index.php -type f`.

## 2. Confinement
- [ ] Isoler le serveur web (retrait du répartiteur de charge, ou isolation réseau via la réponse active ou le pare-feu).
- [ ] **Préserver les preuves avant toute suppression** (ISO 27002 5.28) : copie du fichier, des journaux, et si possible un instantané du conteneur ou de la VM (`docker commit legrand-cible preuve-inc-xxx`).

## 3. Éradication
- Supprimer le webshell et toute autre porte dérobée identifiée.
- Corriger la vulnérabilité d'entrée (upload non filtré, injection, identifiants volés).
- Empêcher l'exécution de PHP dans le dossier `uploads` (`php_admin_flag engine off`) et monter l'arborescence web en lecture seule.

## 4. Rétablissement
- Redéployer depuis une **image saine** (CI/CD) plutôt que de nettoyer le serveur sur place.
- Changer les secrets accessibles depuis le serveur (connexion à la base, clés API Mobile Money).

## 5. Mesures durables
Surveillance d'intégrité en temps réel sur les répertoires web (8.16), séparation code / données téléversées (8.27), déploiements immuables (8.32), WAF (8.26).
