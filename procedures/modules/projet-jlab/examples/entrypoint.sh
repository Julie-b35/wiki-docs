#!/bin/sh

#setup ssl keys, export to pass them to le.sh
echo "ssl_key_wiki=${SSL_KEY_1:=wiki.key}, ssl_cert=${SSL_CERT_1:=wiki.crt}, ssl_chain_cert=${SSL_CHAIN_CERT_1:=wiki.chain}"
echo "ssl_key_glpi=${SSL_KEY_2:=glpi.key}, ssl_cert=${SSL_CERT_2:=glpi.crt}, ssl_chain_cert=${SSL_CHAIN_CERT_2:=glpi.chain}"
export LE_SSL_KEY_1=/etc/ssl/certs/nginx/${SSL_KEY_1}
export LE_SSL_KEY_2=/etc/ssl/certs/nginx/${SSL_KEY_2}
export LE_SSL_CERT_1=/etc/ssl/certs/nginx/${SSL_CERT_1}
export LE_SSL_CERT_2=/etc/ssl/certs/nginx/${SSL_CERT_2}
export LE_SSL_CHAIN_CERT_1=/etc/ssl/certs/nginx/${SSL_CHAIN_CERT_1}
export LE_SSL_CHAIN_CERT_2=/etc/ssl/certs/nginx/${SSL_CHAIN_CERT_2}

sed -i "s|SSL_KEY_1|${LE_SSL_KEY_1}|g"  /etc/nginx/conf.d/default.conf 2>/dev/null
sed -i "s|SSL_CERT_1|${LE_SSL_CERT_1}|g"  /etc/nginx/conf.d/default.conf 2>/dev/null
sed -i "s|SSL_CHAIN_CERT_1|${LE_SSL_CHAIN_CERT_1}|g"  /etc/nginx/conf.d/default.conf 2>/dev/null

sed -i "s|SSL_KEY_2|${LE_SSL_KEY_2}|g"  /etc/nginx/conf.d/default.conf 2>/dev/null
sed -i "s|SSL_CERT_2|${LE_SSL_CERT_2}|g"  /etc/nginx/conf.d/default.conf 2>/dev/null
sed -i "s|SSL_CHAIN_CERT_2|${LE_SSL_CHAIN_CERT_2}|g"  /etc/nginx/conf.d/default.conf 2>/dev/null


if [ "$1" = "nginx" ]; then
    /docker-entrypoint.sh nginx

    /let-encrypt.sh wiki.jlab.ovh $LE_SSL_KEY_1 $LE_SSL_CERT_1
    /let-encrypt.sh glpi.jlab.ovh $LE_SSL_KEY_2 $LE_SSL_CERT_2
    nginx -s stop
fi
exec "$@"