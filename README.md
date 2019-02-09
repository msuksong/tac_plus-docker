# Simple tacacs docker container

## Build docker image

```
docker build -t tacacs:$(cat VERSION) .
```

## Run tacacs container

```
docker run -d -p 49:49 tacacs:$(cat VERSION)
```
Embeded `tac_plus.conf` has an example account `tacacs` with password `tacacs`.

## Run tacacs container with your own tacacs config

```
docker run -d -p 49:49 -v my_tacacs.conf:/etc/tac_plus.conf tacacs:$(cat VERSION)
```

## Run tacacs container with different DEBUGLEVEL

```
docker run -d -p 49:49 -e DEBUGLEVEL=256 tacacs:$(cat VERSION)
```
