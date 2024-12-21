# Stage 1: Build stage
FROM php:8.2-cli AS builder

RUN apt-get update && apt-get install -y \
    git \
    curl \
    unzip \
    && apt-get clean

RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

WORKDIR /app

COPY composer.json composer.lock ./

RUN composer install --prefer-dist --ignore-platform-reqs
COPY . .

# Stage 2: Production stage
FROM httpd:2.4

RUN apt-get update && apt-get install -y \
    php \
    libapache2-mod-php \
    && apt-get clean

COPY --from=builder /app /usr/local/apache2/htdocs

RUN chown -R www-data:www-data /usr/local/apache2/htdocs && \
    chmod -R 755 /usr/local/apache2/htdocs

EXPOSE 80

WORKDIR /usr/local/apache2/htdocs/

CMD ["httpd-foreground"]


