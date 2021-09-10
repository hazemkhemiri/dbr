FROM amd64/php:7.3-apache

RUN set -ex; \
	apt-get update -q; \
	apt-get install -y --no-install-recommends \
		bzip2 \
		default-mysql-client \
		cron \
		rsync \
		sendmail \
		unzip \
		zip \
	; \
	apt-get install -y --no-install-recommends \
		g++ \
		libcurl4-openssl-dev \
		libfreetype6-dev \
		libicu-dev \
		libjpeg-dev \
		libldap2-dev \
		libmagickcore-dev \
		libmagickwand-dev \
		libmcrypt-dev \
		libpng-dev \
		libpq-dev \
		libxml2-dev \
		libzip-dev \
		unzip \
		zlib1g-dev \
	; \
	debMultiarch="$(dpkg-architecture --query DEB_BUILD_MULTIARCH)"; \
	docker-php-ext-configure ldap --with-libdir="lib/$debMultiarch"; \
	docker-php-ext-configure gd --with-freetype-dir=/usr --with-png-dir=/usr --with-jpeg-dir=/usr; \
	docker-php-ext-configure intl; \
	docker-php-ext-configure zip --with-libzip; \
	docker-php-ext-install -j "$(nproc)" \
		calendar \
		gd \
		intl \
		ldap \
		mbstring \
		mysqli \
		pdo \
		pdo_mysql \
		pdo_pgsql \
		pgsql \
		soap \
		zip \
	; \
	pecl install imagick; \
	docker-php-ext-enable imagick; 

RUN	rm -rf /var/lib/apt/lists/*; \
	mkdir -p /var/www/documents; 

COPY	./dolibarr /var/www/html

CMD	["apache2-foreground"]	

