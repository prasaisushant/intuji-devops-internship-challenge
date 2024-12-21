# Using the official httpd image 
FROM httpd

# Installalling PHP and required modules
RUN apt-get update && apt-get install -y \
    php \
    git \
    # For processing php secipts
    libapache2-mod-php \
    curl \
    && apt-get clean

# Installing Composer 
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Copying files
COPY . /usr/local/apache2/htdocs

# Ensuring Apache has the correct ownership and permissions for the copied file
RUN chown -R www-data:www-data /usr/local/apache2/htdocs
RUN chmod -R 755 /usr/local/apache2/htdocs

# Expose HTTP port
EXPOSE 80

# Setting the working directory to the Apache document root
WORKDIR /usr/local/apache2/htdocs/

# Installing dependencies via Composer 
RUN /usr/local/bin/composer install --prefer-dist --ignore-platform-reqs

# Starting Apache in the foreground to keep the container running
CMD ["httpd-foreground"]
