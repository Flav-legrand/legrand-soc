# PB-01 — Force brute et compromission de compte

**Déclencheurs :** 100101 (échecs), **100102** (force brute web), **100103** (succès après force brute), 5712 / **100130** (SSH)
**MITRE ATT&CK :** T1110.001 Password Guessing · T1078 Valid Accounts · T1021.004 SSH

## 1. Détection et analyse (≤ 15 min)
1. Dans Wazuh (Threat Hunting), filtrer `rule.id: (100101 or 100102 or 100103 or 5712 or 100130)` et relever l'**IP source**, les **comptes visés** et la **période**.
2. Qualifier la situation :
   - échecs seuls → **attaque en cours, sans compromission** (P2) ;
   - un succès depuis la même IP (100103 / 100130) → **compte compromis** (P1).
3. Vérifier l'IP : interne ou externe ? Déjà vue ? Réputation (AbuseIPDB, VirusTotal) ?
4. Pour chaque compte ayant réussi à se connecter : quelles actions ont suivi (consultation, virement, commandes exécutées en SSH) ?

## 2. Confinement
- [ ] Vérifier que la **réponse active** a bloqué l'IP (`iptables -L` sur la cible, journal `active-responses.log`) ; sinon, bloquer au pare-feu périmétrique.
- [ ] Compte compromis : **désactiver le compte** ou forcer la réinitialisation du mot de passe, **invalider les sessions** en cours.
- [ ] Compte SSH compromis : couper les sessions (`pkill -u <user>`), retirer les clés `authorized_keys` ajoutées.
- [ ] Opérations financières suspectes : alerter les **opérations** et la **conformité** pour gel ou annulation.

## 3. Éradication
- Rechercher la persistance éventuelle (nouveaux comptes, crontab, clés SSH, fichiers dans `/var/www`) — voir PB-03 et PB-04.
- Corriger la cause : mot de passe faible, absence de MFA, absence de limitation des tentatives.

## 4. Rétablissement
- Réactiver le compte avec un nouveau mot de passe et le **MFA**.
- Surveillance renforcée du compte et de l'IP pendant 30 jours.

## 5. Mesures correctives durables
| Action | ISO 27002 |
|---|---|
| Limitation des tentatives et verrouillage progressif sur l'espace client | 8.5 |
| MFA pour les clients (OTP par SMS ou application) et les administrateurs | 8.5 |
| SSH : authentification par clé uniquement, `PermitRootLogin no`, accès via bastion | 8.2, 8.20 |
| Politique de mots de passe robuste et contrôle contre les listes de mots de passe divulgués | 5.17 |

## 6. Indicateurs à consigner
IP source, comptes visés, nombre de tentatives, horodatage du premier et du dernier événement, comptes compromis, actions réalisées, délai de détection, délai de confinement.
