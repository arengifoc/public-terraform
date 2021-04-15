#!/usr/bin/env bash
# Definicion de variables
APP_DOMAIN=${tpl_app_domain}
SSL_CERT="${tpl_ssl_cert}"
SSL_KEY="${tpl_ssl_key}"

# Aplicar parches
sudo apt update
sudo apt upgrade -y

# Instalar paquetes base
echo | sudo add-apt-repository ppa:ondrej/php
sudo apt update
sudo apt install -y tmux vim sysstat mariadb-server nginx php7.3-fpm php7.3-mysql php7.3-zip php7.3-xml php7.3-intl php7.3-mbstring php7.3-gd php7.3-curl

# Importar llaves para repositorio ownCloud
cd /tmp
wget -nv https://download.owncloud.org/download/repositories/production/Ubuntu_18.04/Release.key -O Release.key
sudo apt-key add - < Release.key

# Configurar repositorio de ownCloud
echo 'deb http://download.owncloud.org/download/repositories/production/Ubuntu_18.04/ /' | sudo tee /etc/apt/sources.list.d/owncloud.list
sudo apt-get update
sudo apt-get install -y owncloud-files

# Crear directorios de SSL para nginx
sudo mkdir -p /etc/ssl/nginx

# Crear archivo de certificado digital y llave privada manualmente
echo "$${SSL_CERT}" | sudo tee /etc/ssl/nginx/$${APP_DOMAIN}.crt 
echo "$${SSL_KEY}" | sudo tee /etc/ssl/nginx/$${APP_DOMAIN}.key
sudo chmod 400 /etc/ssl/nginx/$${APP_DOMAIN}.key
sudo openssl dhparam -out /etc/nginx/dh2048.pem 2048

# Crear la configuracion de nginx
sudo tee /etc/nginx/sites-available/owncloud <<EOF
upstream php-handler {
    server 127.0.0.1:9000;
    # Depending on your used PHP version
    server unix:/run/php/php7.3-fpm.sock;
    #server unix:/var/run/php5-fpm.sock;
    #server unix:/var/run/php7-fpm.sock;
}

server {
    listen 80;
    server_name $${APP_DOMAIN};

    # For SSL certificate verifications, this needs to be served via HTTP
    location /.well-known/(acme-challenge|pki-validation)/ {
        root /var/www/owncloud; # Specify here where the challenge file is placed
    }

    # enforce https
    location / {
        return 301 https://\$server_name\$request_uri;
    }
}

server {
    listen 443 ssl http2;
    server_name $${APP_DOMAIN};

    ssl_certificate /etc/ssl/nginx/$${APP_DOMAIN}.crt;
    ssl_certificate_key /etc/ssl/nginx/$${APP_DOMAIN}.key;

    # Example SSL/TLS configuration. Please read into the manual of NGINX before applying these.
    ssl_session_timeout 5m;
    ssl_protocols TLSv1 TLSv1.1 TLSv1.2;
    ssl_ciphers EECDH+AESGCM:EDH+AESGCM:AES256+EECDH:AES256+EDH;
    ssl_dhparam /etc/nginx/dh2048.pem;
    ssl_prefer_server_ciphers on;
    keepalive_timeout    70;
    ssl_stapling on;
    ssl_stapling_verify on;

    # Add headers to serve security related headers
    # The always parameter ensures that the header is set for all responses, including internally generated error responses.
    # Before enabling Strict-Transport-Security headers please read into this topic first.
    # https://www.nginx.com/blog/http-strict-transport-security-hsts-and-nginx/

    #add_header Strict-Transport-Security "max-age=15552000; includeSubDomains; preload" always;
    add_header X-Content-Type-Options nosniff always;
    add_header X-Frame-Options "SAMEORIGIN" always;
    add_header X-XSS-Protection "1; mode=block" always;
    add_header X-Robots-Tag none always;
    add_header X-Download-Options noopen always;
    add_header X-Permitted-Cross-Domain-Policies none always;

    # Path to the root of your installation
    root /var/www/owncloud/;

    location = /robots.txt {
        allow all;
        log_not_found off;
        access_log off;
    }

    # The following 2 rules are only needed for the user_webfinger app.
    # Uncomment it if you're planning to use this app.

    #rewrite ^/.well-known/host-meta /public.php?service=host-meta last;
    #rewrite ^/.well-known/host-meta.json /public.php?service=host-meta-json last;

    location = /.well-known/carddav {
        return 301 \$scheme://\$host/remote.php/dav;
    }
    location = /.well-known/caldav {
        return 301 \$scheme://\$host/remote.php/dav;
    }

    # set max upload size
    client_max_body_size 512M;
    fastcgi_buffers 8 4K;                     # Please see note 1
    fastcgi_ignore_headers X-Accel-Buffering; # Please see note 2

    # Disable gzip to avoid the removal of the ETag header
    # Enabling gzip would also make your server vulnerable to BREACH
    # if no additional measures are done. See https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=773332
    gzip off;

    # Uncomment if your server is build with the ngx_pagespeed module
    # This module is currently not supported.
    #pagespeed off;

    error_page 403 /core/templates/403.php;
    error_page 404 /core/templates/404.php;

    location / {
        rewrite ^ /index.php\$uri;
    }

    location ~ ^/(?:build|tests|config|lib|3rdparty|templates|data)/ {
        return 404;
    }
    location ~ ^/(?:\.|autotest|occ|issue|indie|db_|console) {
        return 404;
    }

    location ~ ^/(?:index|remote|public|cron|core/ajax/update|status|ocs/v[12]|updater/.+|ocs-provider/.+|ocm-provider/.+|core/templates/40[34])\.php(?:$|/) {
        fastcgi_split_path_info ^(.+\.php)(/.*)\$;
        include fastcgi_params;
        fastcgi_param SCRIPT_FILENAME \$document_root\$fastcgi_script_name;
        fastcgi_param SCRIPT_NAME \$fastcgi_script_name; # necessary for owncloud to detect the contextroot https://github.com/owncloud/core/blob/v10.0.0/lib/private/AppFramework/Http/Request.php#L603
        fastcgi_param PATH_INFO \$fastcgi_path_info;
        fastcgi_param HTTPS on;
        fastcgi_param modHeadersAvailable true; #Avoid sending the security headers twice
        fastcgi_param front_controller_active true;
        fastcgi_read_timeout 180; # increase default timeout e.g. for long running carddav/ caldav syncs with 1000+ entries
        fastcgi_pass php-handler;
        fastcgi_intercept_errors on;
        fastcgi_request_buffering off; #Available since NGINX 1.7.11
    }

    location ~ ^/(?:updater|ocs-provider|ocm-provider)(?:\$|/) {
        try_files \$uri \$uri/ =404;
        index index.php;
    }

    # Adding the cache control header for js and css files
    # Make sure it is BELOW the PHP block
    location ~ \.(?:css|js)\$ {
        try_files \$uri /index.php\$uri\$is_args\$args;
        add_header Cache-Control "max-age=15778463" always;

        # Add headers to serve security related headers (It is intended to have those duplicated to the ones above)
        # The always parameter ensures that the header is set for all responses, including internally generated error responses.
        # Before enabling Strict-Transport-Security headers please read into this topic first.
        # https://www.nginx.com/blog/http-strict-transport-security-hsts-and-nginx/

        #add_header Strict-Transport-Security "max-age=15552000; includeSubDomains; preload" always;
        add_header X-Content-Type-Options nosniff always;
        add_header X-Frame-Options "SAMEORIGIN" always;
        add_header X-XSS-Protection "1; mode=block" always;
        add_header X-Robots-Tag none always;
        add_header X-Download-Options noopen always;
        add_header X-Permitted-Cross-Domain-Policies none always;
        # Optional: Don't log access to assets
        access_log off;
    }

    location ~ \.(?:svg|gif|png|html|ttf|woff|ico|jpg|jpeg|map|json)\$ {
        add_header Cache-Control "public, max-age=7200" always;
        try_files \$uri /index.php\$uri\$is_args\$args;
        # Optional: Don't log access to other assets
        access_log off;
    }
}
EOF

# Habilitar configuracion
sudo ln -s /etc/nginx/sites-available/owncloud /etc/nginx/sites-enabled
sudo systemctl restart nginx

# Ajustar configuracion de PHP-FPM
sudo sed -i -e 's/^;env/env/g' /etc/php/7.3/fpm/pool.d/www.conf
sudo systemctl restart php7.3-fpm

# Crear directorio de data de ownCloud
sudo mkdir /var/owncloud
sudo chown www-data:www-data /var/owncloud

# Configurar permisos en la BD
sudo mysql -u root -e "CREATE DATABASE owncloud; GRANT ALL ON owncloud.* TO owncloud@localhost IDENTIFIED BY 'p4ss0wnCl0ud'; FLUSH PRIVILEGES"

