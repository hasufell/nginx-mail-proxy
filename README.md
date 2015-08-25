## Buld the container

```
docker build -t hasufell/docker-nginx-proxy .
```

## How to run

First get the address of the running mail container and pipe it to the file
nginx will read during runtime:
```
echo -n "$(docker inspect dockermail-ipv6 | grep GlobalIPv6Address | cut -d \" -f 4)" > ./config/www-tmp/addr
```

Then start the container:
```
docker run --name=nginx-proxy -ti -d -p 80:80 -p 443:443 -p 444:444 -p 445:445 -p 25:25 -p 110:110 -p 995:995 -p 143:143 -p 993:993 -p 2525:2525 -p 465:465 -p 587:587 -v `pwd`/config/www-tmp:/var/www/tmp:ro hasufell/docker-nginx-proxy
```
