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

# supervisor config
ADD supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# nginx config
ADD ./sites-enabled /etc/nginx/sites-enabled/

# copy www data
COPY www /var/www

WORKDIR /etc/nginx

# web server
EXPOSE 80 443 444 445

# mail server
EXPOSE 25 110 995 143 993 2525 465 587

CMD ["/usr/bin/supervisord", "-n"]
