# PB-05 — Rançongiciel (crise)

**Signaux :** modifications de fichiers en masse (FIM), extensions inconnues, note de rançon, suppression des clichés instantanés et des sauvegardes, alertes EDR, utilisateurs qui ne peuvent plus ouvrir leurs fichiers.
**MITRE ATT&CK :** T1486 Data Encrypted for Impact · T1490 Inhibit System Recovery

## Premières heures (P1, cellule de crise)
1. **Isoler** les machines touchées du réseau (débrancher le câble ou isoler via l'EDR) **sans les éteindre** (préserver la mémoire pour l'analyse).
2. **Protéger les sauvegardes** : déconnecter immédiatement les sauvegardes en ligne et vérifier l'état de la copie hors ligne et immuable.
3. Activer la **cellule de crise** (PCA) et informer la Direction générale.
4. Désactiver les comptes à privilèges potentiellement compromis, puis réinitialiser le mot de passe du compte KRBTGT (deux fois) en cas de compromission de l'Active Directory.
5. Identifier la souche (note de rançon, extension) et le **patient zéro**.

## Décisions de la Direction
- **Ne pas payer** la rançon est la position recommandée (aucune garantie de déchiffrement, financement du crime) ; la décision finale appartient à la DG, éclairée par le juridique.
- Déclarations : ANSSI Congo, régulateur bancaire, autorité de protection des données en cas de fuite, dépôt de plainte.
- Communication de crise : clients, partenaires Mobile Money, presse.

## Rétablissement
Reconstruire dans l'ordre du BIA (voir `legrand-grc/docs/03-PCA-PRA.md`) à partir de sauvegardes **vérifiées saines**, une fois le vecteur d'entrée éliminé. Renforcer la supervision pendant les semaines suivantes, puis retour d'expérience complet.
