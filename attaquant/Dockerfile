# Poste « attaquant » du laboratoire : outils légers pour rejouer les scénarios
FROM alpine:3.20
RUN apk add --no-cache bash curl nmap nmap-scripts openssh-client sshpass coreutils jq
COPY scenarios/ /scenarios/
RUN chmod +x /scenarios/*.sh
WORKDIR /scenarios
CMD ["sleep", "infinity"]
