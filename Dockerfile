FROM ghcr.io/wg-easy/wg-easy:latest

RUN apk update && apk add --no-cache openssh openssh-keygen

ARG PUID
ARG PGID
ARG PROXY_UID
ARG PROXY_GID
ARG PROXY_USER_NAME
ARG PROXY_GROUP_NAME

RUN deluser node
RUN addgroup -g $PGID node
RUN adduser -u $PUID -G node -D -s /bin/bash node

RUN addgroup -g $PROXY_GID $PROXY_GROUP_NAME
RUN adduser -u $PROXY_UID -G $PROXY_GROUP_NAME -D $PROXY_USER_NAME
RUN passwd -d $PROXY_USER_NAME

RUN mkdir /home/$PROXY_USER_NAME/.ssh && \
    chown $PROXY_USER_NAME:$PROXY_GROUP_NAME /home/$PROXY_USER_NAME/.ssh && \
    chmod 700 /home/$PROXY_USER_NAME/.ssh

COPY sshd_config /etc/ssh/sshd_config

RUN ssh-keygen -A

EXPOSE 22

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]

WORKDIR /app

CMD ["/usr/bin/dumb-init", "node", "server.js"]