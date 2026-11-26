#!/bin/bash
# Scénario 5 — Dépôt d'un fichier PHP suspect dans l'arborescence web (MITRE T1505.003 Web Shell)
# Le fichier est INOFFENSIF (il affiche un texte) : seul son dépôt doit déclencher la détection FIM.
# Attendu : 100150 (fichier PHP créé dans /var/www/html) — à lancer depuis l'hôte.
docker exec legrand-cible sh -c 'echo "<?php echo \"fichier de test Legrand SOC\";" > /var/www/html/uploads/shell.php && ls -l /var/www/html/uploads/'
