FROM alpine:3.10
LABEL autor="Martin Vilche <mfvilche@gmail.com>" \
      io.k8s.description="Apache httpd docker images " \
      io.k8s.display-name="Apache httpd Applications" \
      io.openshift.tags="apache,httpd" \
      io.openshift.expose-services="8080" \
      org.jboss.deployments-dir="/var/www/localhost/htdocs" \
      io.openshift.s2i.scripts-url="image:///usr/libexec/s2i"

RUN apk add --update --no-cache bash git busybox-extras which openssh shadow busybox-suid coreutils tzdata apache2
RUN sed -i -e "s/^Listen 80/Listen 8080/" /etc/apache2/httpd.conf && sed -ri -e 's!^(\s*ErrorLog)\s+\S+!\1 /proc/self/fd/2!g' /etc/apache2/httpd.conf && \
rm -rf /var/www/localhost/htdocs/* /etc/localtime && \
rm -rf /var/cache/apk/*
COPY s2i/bin/ /usr/libexec/s2i
RUN usermod -u 1001 apache && touch /etc/localtime /etc/timezone && \
chown -R 1001 /var/www/localhost/htdocs /usr/libexec/s2i /etc/localtime /etc/timezone /var/www/logs/ /run/apache2 /etc/apache2/  && \
chgrp -R 0 /var/www/localhost/htdocs /usr/libexec/s2i /etc/localtime /etc/timezone /var/www/logs/ /run/apache2 /etc/apache2/  && \
chmod -R g=u /var/www/localhost/htdocs /usr/libexec/s2i /etc/localtime /etc/timezone /var/www/logs/ /run/apache2 /etc/apache2/
WORKDIR /var/www/localhost/htdocs
USER 1001
EXPOSE 8080
CMD ["/usr/libexec/s2i/usage"]

