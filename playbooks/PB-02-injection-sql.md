# PB-02 — Injection SQL sur une application exposée

**Déclencheurs :** 100110 (motif dans l'URL), 100111 (erreur SQL), **100112** (UNION exécutée = extraction probable)
**MITRE ATT&CK :** T1190 Exploit Public-Facing Application · T1005 Data from Local System

## 1. Détection et analyse
1. Filtrer `rule.groups: sql_injection` et relever l'IP, l'URL, le paramètre vulnérable (`q` sur `/compte.php`) et les charges utilisées.
2. **Évaluer l'exfiltration** : 100112 ou une réponse HTTP 200 de grande taille sur une requête contenant `UNION` signifie que des données ont probablement été extraites. Identifier les tables visées (ici `clients` : identifiants et **mots de passe en clair**).
3. Relier l'activité à une session authentifiée : quel compte client a servi à l'attaque ?

## 2. Confinement
- [ ] Bloquer l'IP source (pare-feu, WAF).
- [ ] Mettre en place une **règle WAF virtuelle** sur le paramètre vulnérable, ou désactiver temporairement la fonctionnalité de recherche.
- [ ] Désactiver le compte client utilisé pour l'attaque.

## 3. Éradication — correctif du code
Code vulnérable (`cible/app/compte.php`) :
```php
$sql = "SELECT ... WHERE client_id = $id AND libelle LIKE '%$q%'";
$rows = db()->query($sql)->fetchAll();
```
Code corrigé :
```php
$st = db()->prepare("SELECT date, libelle, montant FROM transactions
                     WHERE client_id = :id AND libelle LIKE :q ORDER BY date DESC");
$st->execute([':id' => $id, ':q' => '%' . $q . '%']);
$rows = $st->fetchAll(PDO::FETCH_ASSOC);
```
Compléments : messages d'erreur génériques, compte de base de données à moindre privilège, revue de toutes les requêtes construites par concaténation (le SAST de la CI les signale).

## 4. Rétablissement
- Si des identifiants ont été extraits : **réinitialiser les mots de passe** des clients concernés, et les stocker hachés (bcrypt ou Argon2).
- Test de non-régression avec les charges de `attaquant/scenarios/03-injection-sql.sh`, qui ne doivent plus rien renvoyer.

## 5. Obligations
Une extraction de données personnelles de clients est une **violation de données** : informer le RSSI, le DPO ou le responsable conformité, et évaluer l'obligation de notifier l'autorité de protection des données, le régulateur bancaire, l'ANSSI et les clients concernés.

## 6. Mesures durables
| Action | ISO 27002 |
|---|---|
| Requêtes préparées obligatoires (règle de codage) | 8.28 |
| SAST (Semgrep) bloquant dans la CI/CD | 8.25, 8.29 |
| WAF devant les applications exposées | 8.20, 8.26 |
| Test d'intrusion avant mise en production | 8.29 |
| Chiffrement et hachage des données sensibles | 8.24 |
