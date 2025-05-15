#!/bin/sh

if [ ! -f /etc/ssh/ssh_host_rsa_key ]; then
    echo "Generating ssh host keys..."
    ssh-keygen -A
fi

echo "ProxyUser $PROXY_USER_NAME:$PROXY_GROUP_NAME"

chown $PROXY_USER_NAME:$PROXY_GROUP_NAME /home/$PROXY_USER_NAME/.ssh
chmod 700 /home/$PROXY_USER_NAME/.ssh

touch /home/$PROXY_USER_NAME/.ssh/authorized_keys
chown $PROXY_USER_NAME:$PROXY_GROUP_NAME /home/$PROXY_USER_NAME/.ssh/authorized_keys
chmod 600 /home/$PROXY_USER_NAME/.ssh/authorized_keys

echo "Starting sshd..."
/usr/sbin/sshd

# Run the original container's CMD (wg-easy execution) in the foreground
# Use 'exec' to replace the current shell process with the wg-easy process.
# This is necessary for wg-easy to become PID 1 and handle signals correctly.
echo "Starting wg-easy..."
exec "$@"