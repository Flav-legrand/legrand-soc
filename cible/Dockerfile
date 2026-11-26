# Cible du laboratoire : application Legrand$ (vulnérable) + SSH + agent Wazuh
FROM php:8.3-apache

ARG WAZUH_VERSION=4.14.6
ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y --no-install-recommends \
        curl gnupg ca-certificates openssh-server rsyslog sudo iptables procps lsb-release \
 && curl -fsSL https://packages.wazuh.com/key/GPG-KEY-WAZUH | gpg --dearmor -o /usr/share/keyrings/wazuh.gpg \
 && echo "deb [signed-by=/usr/share/keyrings/wazuh.gpg] https://packages.wazuh.com/4.x/apt/ stable main" > /etc/apt/sources.list.d/wazuh.list \
 && apt-get update \
 && WAZUH_MANAGER="wazuh.manager" WAZUH_AGENT_NAME="legrand-cible" WAZUH_AGENT_GROUP="default" \
    apt-get install -y --no-install-recommends wazuh-agent=${WAZUH_VERSION}-1 \
 && rm -rf /var/lib/apt/lists/*

# Journaux Apache dans des fichiers (et non stdout) pour la collecte par l'agent
RUN rm -f /var/log/apache2/access.log /var/log/apache2/error.log \
 && mkdir -p /var/log/legrand /var/lib/legrand /run/sshd \
 && chown www-data:www-data /var/log/legrand /var/lib/legrand

# Comptes système de démonstration (mots de passe faibles VOLONTAIRES pour le scénario SSH)
RUN useradd -m -s /bin/bash stagiaire && echo 'stagiaire:stagiaire2026' | chpasswd \
 && useradd -m -s /bin/bash -G sudo admin.si && echo 'admin.si:Admin@Legrand!26' | chpasswd \
 && sed -ri 's/^#?PasswordAuthentication.*/PasswordAuthentication yes/' /etc/ssh/sshd_config

# Configuration complémentaire de l'agent (journaux à collecter, intégrité des fichiers)
COPY config/agent-legrand.conf /tmp/agent-legrand.conf
RUN cat /tmp/agent-legrand.conf >> /var/ossec/etc/ossec.conf && rm /tmp/agent-legrand.conf

COPY app/ /var/www/html/
RUN chown -R root:root /var/www/html && chown www-data:www-data /var/www/html/uploads

COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh
EXPOSE 80 22
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
