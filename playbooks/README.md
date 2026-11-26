# Playbooks de réponse aux incidents

Les playbooks suivent les phases du **NIST SP 800-61** : préparation, détection et analyse, confinement, éradication, rétablissement, retour d'expérience. Ils s'appuient sur les mesures **5.24 à 5.28 de l'ISO/IEC 27002** (gestion des incidents).

| Playbook | Déclencheurs Wazuh | MITRE ATT&CK | Priorité par défaut |
|---|---|---|---|
| [PB-01 Force brute et compromission de compte](PB-01-force-brute.md) | 100101, 100102, 100103, 100130, 5712 | T1110, T1078, T1021.004 | P2 (P1 si 100103/100130) |
| [PB-02 Injection SQL](PB-02-injection-sql.md) | 100110, 100111, 100112 | T1190, T1005 | P2 (P1 si 100112) |
| [PB-03 Webshell et compromission du serveur web](PB-03-webshell.md) | 100150 | T1505.003 | P1 |
| [PB-04 Élévation de privilèges et persistance](PB-04-elevation-privileges.md) | 100140, 100151, 5902, 5402 | T1098, T1548.003 | P1 |
| [PB-05 Rançongiciel](PB-05-rancongiciel.md) | FIM en masse, EDR, alertes utilisateurs | T1486, T1490 | P1 (crise) |

## Échelle de priorité

| Priorité | Définition | Prise en charge | Confinement |
|---|---|---|---|
| P1 | Compromission avérée ou service critique touché | Immédiate, 24 h/24 | < 1 h |
| P2 | Attaque en cours sans compromission avérée | < 1 h ouvrée | < 4 h |
| P3 | Événement suspect isolé | < 1 jour ouvré | — |

## Escalade et déclaration

- **Analyste SOC N1** : qualification et premières actions de confinement prévues par le playbook.
- **Analyste N2 / administrateurs** : investigation et éradication.
- **RSSI** : décision sur les P1, communication à la Direction générale, déclaration aux autorités (ANSSI Congo, régulateur bancaire) selon les obligations réglementaires, et décision de dépôt de plainte.
- **Cellule de crise** (DG) : activée pour un rançongiciel ou une indisponibilité supérieure à la DMIA du PCA.

Chaque incident est consigné à l'aide du [modèle de rapport](../rapports/MODELE-rapport-incident.md).
