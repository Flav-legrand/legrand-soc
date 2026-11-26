#!/bin/sh
set -e
touch /var/log/auth.log /var/log/apache2/access.log /var/log/apache2/error.log /var/log/legrand/app.log
chown www-data:www-data /var/log/legrand/app.log
rsyslogd
/usr/sbin/sshd
/var/ossec/bin/wazuh-control start || echo "[!] Agent Wazuh non démarré (manager injoignable ?)"
exec apache2-foreground
