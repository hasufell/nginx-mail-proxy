FROM        hasufell/gentoo-amd64-paludis:latest
MAINTAINER  Julian Ospald "hasufell@posteo.de"

# set USE flags
# check these with "cave show <package-name>"
RUN echo -e "*/* acl bash-completion ipv6 kmod openrc pcre readline unicode\
	zlib pam ssl sasl bzip2 urandom crypt tcpd\
	-acpi -cairo -consolekit -cups -dbus -dri -gnome -gnutls -gtk -ogg -opengl\
	-pdf -policykit -qt3support -qt5 -qt4 -sdl -sound -systemd -truetype -vim\
	-vim-syntax -wayland -X\
	\n\
	\ndev-lang/php cgi cli curl fpm gmp imap zip\
	\napp-eselect/eselect-php fpm\
	\n\
	\n*/* NGINX_MODULES_HTTP: access auth_basic auth_pam auth_request browser\
	charset dav dav_ext fastcgi gunzip map memcached perl proxy realip referer\
	rewrite scgi\
	\n\
	\n*/* NGINX_MODULES_MAIL: imap pop3 smtp" >> /etc/paludis/use.conf

# update world with our USE flags
RUN chgrp paludisbuild /dev/tty && cave resolve -c world -x

# install nginx
RUN chgrp paludisbuild /dev/tty && cave resolve -z www-servers/nginx -x

# install php
RUN chgrp paludisbuild /dev/tty && cave resolve -z dev-lang/php -x

# install tools
RUN chgrp paludisbuild /dev/tty && cave resolve -z app-admin/supervisor sys-process/htop -x

# update etc files... hope this doesn't screw up
RUN etc-update --automode -5

# supervisor config
COPY ./config/supervisord.conf /etc/supervisord.conf

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
