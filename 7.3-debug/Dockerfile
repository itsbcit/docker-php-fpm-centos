FROM bcit/centos:7-latest

LABEL build_id="1609890162"

# enable php7 & oracle repos then install system libs/utils, php-fpm, oracle-instantclient
RUN yum -y --setopt tsflags=nodocs --setopt timeout=5 install \
    http://rpms.remirepo.net/enterprise/remi-release-7.rpm \
  && yum-config-manager --enable remi-php73 \
  && cd /etc/yum.repos.d \
  && wget http://yum.oracle.com/public-yum-ol7.repo \
  && wget http://yum.oracle.com/RPM-GPG-KEY-oracle-ol7 \
  && rpm --import RPM-GPG-KEY-oracle-ol7 \
  && yum-config-manager --enable ol7_oracle_instantclient \
  && yum update -y \
  && yum -y --setopt tsflags=nodocs --setopt timeout=5 install \
  bzip2 \
  libxml2-devel \
  unzip \
  vim \
  zip \
  # php
  php-7.3.26 \
  php-fpm-7.3.26 \
  php-mbstring-7.3.26 \
  php-mysqlnd-7.3.26 \
  php-oci8-7.3.26 \
  php-pear-7.3.26 \
  php-pdo-7.3.26 \
  php-posix-7.3.26 \
  php-soap-7.3.26 \
  php-sodium-7.3.26 \
  php-xml-7.3.26 \
  php-pecl-igbinary \
  # oracle-instantclient
  oracle-instantclient19.6-basic \
  oracle-instantclient19.6-devel \
  oracle-instantclient19.6-sqlplus \
  && yum clean all -y

# Link oracle-instantclient, set timezone, install composer, configure php-fpm 
# ENV TZ=America/Vancouver - set in docker-compose.yml
RUN echo /usr/lib/oracle/19.6/client64/lib > /etc/ld.so.conf.d/oracle-instantclient.conf \
  && ldconfig \
  && ln -snf /usr/share/zoneinfo/America/Vancouver /etc/localtime \
  && echo America/Vancouver > /etc/timezone \
  && curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer \
  && mkdir -p /run/php-fpm/ \
  && sed -i "s$/var/log/php-fpm/error.log$/dev/stderr$" /etc/php-fpm.conf \
  && sed -i s/127.0.0.1:9000/0.0.0.0:9000/ /etc/php-fpm.d/www.conf \
  && sed -i s/127.0.0.1/any/ /etc/php-fpm.d/www.conf \
  && chmod -R 775 /run/php-fpm \
  && chmod -R 775 /etc/php-fpm.d \
  && chmod -R 775 /etc/php.d

# Configure default php.ini file based on environment; Install xdebug from PECL if we're building a DEV environment
# Production php.ini by default
RUN echo '=============== DEV flagged, Installing xdebug & dev config ===============' \ 
  && wget https://raw.githubusercontent.com/php/php-src/PHP-$(rpm -q --queryformat="%{VERSION}" php)/php.ini-development -O /etc/php.ini \
  && yum install -y php-pecl-xdebug \
  && php -v \
  && echo '=============== xdebug installed ===============' \
  && php -i

WORKDIR /application

CMD ["php-fpm", "-F", "-O"]
