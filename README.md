# wg-easy with sshd

## How to run

```shell
cp .env.sample .env
mkdir ssh
docker compose up
```

## How to tunnel

```shell
ssh -p $WG_SSHD_PORT -L $HOST_PORT:localhost:$TARGET_PORT $PROXY_USER_NAME@localhost
```