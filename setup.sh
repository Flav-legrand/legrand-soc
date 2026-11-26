#!/usr/bin/env bash
# Installation du laboratoire Legrand SOC
#   Prérequis : Docker + Docker Compose v2, git, 8 Go de RAM libres (Wazuh indexer)
#   Linux : sudo sysctl -w vm.max_map_count=262144
#   Usage  : ./setup.sh            (installe et démarre)
#            ./setup.sh down       (arrête la pile)
set -euo pipefail

WAZUH_VERSION="${WAZUH_VERSION:-4.14.6}"
export WAZUH_VERSION
export LEGRAND_SOC="$(cd "$(dirname "$0")" && pwd)"
STACK="$LEGRAND_SOC/wazuh-docker/single-node"
COMPOSE=(docker compose -f docker-compose.yml -f docker-compose.soc.yml)

if [[ "${1:-}" == "down" ]]; then
  cd "$STACK" && "${COMPOSE[@]}" down; exit 0
fi

echo "[1/5] Récupération de wazuh-docker v$WAZUH_VERSION (dépôt officiel)"
if [[ ! -d "$LEGRAND_SOC/wazuh-docker" ]]; then
  git clone --depth 1 -b "v$WAZUH_VERSION" https://github.com/wazuh/wazuh-docker.git "$LEGRAND_SOC/wazuh-docker"
fi

echo "[2/5] Génération des certificats TLS de l'indexer"
cd "$STACK"
if [[ ! -f config/wazuh_indexer_ssl_certs/root-ca.pem ]]; then
  docker compose -f generate-indexer-certs.yml run --rm generator
fi

echo "[3/5] Ajout de la surcouche Legrand (règles, cible, attaquant)"
cp "$LEGRAND_SOC/docker-compose.soc.yml" "$STACK/docker-compose.soc.yml"

echo "[4/5] Activation de la réponse active dans la configuration du manager"
CONF="$STACK/config/wazuh_cluster/wazuh_manager.conf"
if ! grep -q "Legrand SOC : réponse active" "$CONF"; then
  python3 - "$CONF" "$LEGRAND_SOC/wazuh/active-response.xml" <<'PY'
import sys
conf, block = sys.argv[1], open(sys.argv[2], encoding="utf-8").read()
s = open(conf, encoding="utf-8").read()
i = s.rfind("</ossec_config>")
open(conf, "w", encoding="utf-8").write(s[:i] + block + "\n" + s[i:])
PY
fi

echo "[5/5] Démarrage de la pile"
"${COMPOSE[@]}" up -d --build

cat <<MSG

[+] Laboratoire démarré (compter 2 à 3 minutes pour l'initialisation de l'indexer).
    Tableau de bord Wazuh : https://localhost   (identifiants par défaut de wazuh-docker :
                            à CHANGER immédiatement, voir la documentation officielle)
    Application cible     : http://127.0.0.1:8081
    Lancer les attaques   : ./scripts/lancer-scenarios.sh
    Vérifier l'agent      : docker exec single-node-wazuh.manager-1 /var/ossec/bin/agent_control -l
MSG
