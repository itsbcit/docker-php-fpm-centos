FROM bcit.io/centos:7-latest

ENV DISABLE_EXTENSIONS="xdebug curl enchant exif ftp gd imap ldap odbc snmp sysvmsg sysvsem sysvshm pdo_odbc amqp ast imagick mailparse ssh2 vips zmq couchbase"
ENV ENABLE_EXTENSIONS=""

LABEL maintainer="jesse@weisner.ca, chriswood.ca@gmail.com, jonathan_zhao@bcit.ca"
LABEL build_id="1643052849"
LABEL php_version="7.3.33"
LABEL centos_version="7"

RUN yum -y  install \
    http://rpms.remirepo.net/enterprise/remi-release-7.rpm \
  && rpmkeys --import /etc/pki/rpm-gpg/RPM-GPG-KEY-remi* /etc/pki/rpm-gpg/RPM-GPG-KEY-EPEL-7 \
  && yum-config-manager -q --enable remi remi-php73 >/dev/null \
  && yum -y install \
    bzip2 \
    fcgiwrap \
    unzip \
    vim \
    zip \
    php-bcmath-7.3.33 \
    php-dba-7.3.33 \
    php-enchant-7.3.33 \
    php-fpm-7.3.33 \
    php-gd-7.3.33 \
    php-gmp-7.3.33 \
    php-imap-7.3.33 \
    php-intl-7.3.33 \
    php-json-7.3.33 \
    php-ldap-7.3.33 \
    php-mbstring-7.3.33 \
    php-mysqlnd-7.3.33 \
    php-odbc-7.3.33 \
    php-opcache-7.3.33 \
    php-pdo-7.3.33 \
    php-pdo-dblib-7.3.33 \
    php-process-7.3.33 \
    php-pgsql-7.3.33 \
    php-pspell-7.3.33 \
    php-snmp-7.3.33 \
    php-soap-7.3.33 \
    php-sodium-7.3.33 \
    php-tidy-7.3.33 \
    php-xml-7.3.33 \
    php-xmlrpc-7.3.33 \
    php-pecl-amqp \
    php-pecl-ast \
    php-pecl-couchbase \
    php-pecl-event \
    php-pecl-igbinary \
    php-pecl-imagick \
    php-pecl-lzf \
    php-pecl-mailparse \
    php-pecl-mcrypt \
    php-pecl-memcached \
    php-pecl-msgpack \
    php-pecl-oauth \
    php-pecl-protobuf \
    php-pecl-redis \
    php-pecl-ssh2 \
    php-pecl-vips \
    php-pecl-xdebug \
    php-pecl-yaml \
    php-pecl-zip \
    php-pecl-zmq \
    php-7.3.33 \
    php-pear \
  && rm -rf /var/cache/yum

COPY --from=local/php-fpm:7.3-centos-builder-b1643052849 /etc/php.d/20-timezonedb.ini /etc/php.d/20-timezonedb.ini
COPY --from=local/php-fpm:7.3-centos-builder-b1643052849 /usr/lib64/php/modules/timezonedb.so /usr/lib64/php/modules/timezonedb.so

ADD https://raw.githubusercontent.com/php/php-src/PHP-7.3.33/php.ini-development /etc/php.ini-development
ADD https://raw.githubusercontent.com/docker-library/php/master/docker-php-ext-enable /usr/local/bin/docker-php-ext-enable
ADD https://raw.githubusercontent.com/renatomefi/php-fpm-healthcheck/master/php-fpm-healthcheck /usr/local/bin/php-fpm-healthcheck
ADD zz-docker.conf /etc/php-fpm.d/zz-docker.conf
ADD docker.conf /etc/php-fpm.d/docker.conf
ADD www.conf /etc/php-fpm.d/www.conf
ADD 50-copy-php-fpm-config.sh /docker-entrypoint.d/50-copy-php-fpm-config.sh
ADD 60-php_extensions.sh /docker-entrypoint.d/60-php_extensions.sh
ADD php.ini-development /etc/php.ini-development

# Set timezone, install composer, configure php-fpm 
# ENV TZ=America/Vancouver - set in docker-compose.yml
RUN ln -snf /usr/share/zoneinfo/America/Vancouver /etc/localtime \
 && echo America/Vancouver > /etc/timezone \
 && curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer \
 && mkdir -p /run/php-fpm/ \
 && chmod -R 775 \ 
      /run/php-fpm \
      /etc/php-fpm.d \
      /etc/php.d \
      /usr/local/bin/docker-php-ext-enable \
      /usr/local/bin/php-fpm-healthcheck \
 && chmod 664 \
      /etc/php.ini \
      /etc/php.ini-development 

WORKDIR /application
HEALTHCHECK CMD /usr/local/bin/php-fpm-healthcheck

CMD ["/usr/sbin/php-fpm", "-F", "-O", "-y", "/etc/php-fpm.conf"]
