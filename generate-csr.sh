# see: https://www.digicert.com/csr-creation-apache.htm

openssl req -new -newkey rsa:2048 -nodes -keyout ssl/server.key -out ssl/server.csr
