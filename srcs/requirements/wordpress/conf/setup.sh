#!/bin/sh


echo "DOMAIN_NAME: $DOMAIN_NAME"
echo "ADMIN_USER: $ADMIN_USER"
echo "ADMIN_PASSWORD: $ADMIN_PASSWORD"
echo "ADMIN_EMAIL: $ADMIN_EMAIL"
echo "USER_NAME: $USER_NAME"
echo "USER_EMAIL: $USER_EMAIL"
echo "USER_PASSWORD: $USER_PASSWORD"

cd /var/www
wp --allow-root --path=/var/www core install \
  --url="$DOMAIN_NAME" \
  --title="Ibrahim's WordPress" \
  --admin_user="$ADMIN_USER" \
  --admin_password="$ADMIN_PASSWORD" \
  --admin_email="$ADMIN_EMAIL"

wp user create "$USER_NAME" "$USER_EMAIL" \
  --role=author \
  --user_pass="$USER_PASSWORD" \
  --allow-root

wp --allow-root --path=/var/www option update blogname "Amazing Things!"
wp --allow-root --path=/var/www option update blogdescription "Ibrahim's Inception"
wp --allow-root --path=/var/www option update blog_public 0


wp config set WP_CACHE true --allow-root
wp config set WP_CACHE_KEY_SALT 'iganiev.42.fr' --allow-root

wp plugin install redis-cache --activate --allow-root
wp redis enable --allow-root

# wp theme install inspiro --activate --allow-root
chown -R www-data:www-data /var/www/wp-content
chmod -R 755 /var/www/wp-content
mkdir -p /var/www/wp-content/upgrade/
wp theme install inspiro --activate --allow-root

wp plugin update --all --allow-root

/usr/sbin/php-fpm83 -F
