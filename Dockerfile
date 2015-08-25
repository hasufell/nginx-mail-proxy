FROM        debian:sid
MAINTAINER  Julian Ospald "hasufell@posteo.de"

ENV DEBIAN_FRONTEND noninteractive

# Update the package repository and pull basic packages
RUN apt-get update && \
	apt-get upgrade -y && \
	apt-get install -y wget curl locales nano dnsutils net-tools vim git htop supervisor

# Configure timezone and locale
RUN echo "Europe/Berlin" > /etc/timezone && \
	dpkg-reconfigure -f noninteractive tzdata
RUN export LANGUAGE=en_US.UTF-8 && \
	export LANG=en_US.UTF-8 && \
	export LC_ALL=en_US.UTF-8 && \
	locale-gen en_US.UTF-8 && \
	dpkg-reconfigure locales

# install nginx
RUN apt-get update; apt-get install -y nginx-extras

# install php
RUN apt-get update; apt-get install -y php5-fpm

# supervisor config
COPY ./config/supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# nginx config
RUN mkdir -p /var/www/mail-auth
COPY ./config/nginx-mail-auth.php /var/www/mail-auth/auth.php
COPY ./config/ssl/ /etc/ssl/certs/
COPY ./config/ca-ssl/ /etc/ssl/auth/
COPY ./config/sites-enabled /etc/nginx/sites-enabled/
RUN rm -v /etc/nginx/nginx.conf
COPY ./config/nginx.conf /etc/nginx/nginx.conf

WORKDIR /etc/nginx

# web server
EXPOSE 80 443 444 445

# mail server
EXPOSE 25 110 995 143 993 2525 465 587

CMD ["/usr/bin/supervisord", "-n"]
