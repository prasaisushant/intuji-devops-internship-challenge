# Stage 1: Build stage
FROM php AS builder

# Install necessary dependencies (git, curl, unzip)
RUN apt-get update && apt-get install -y \
    git \  
    curl \ 
    unzip \ 
    && apt-get clean  

# Install Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Set the working directory to /app
WORKDIR /app

# Copy the composer configuration files to the container
COPY composer.json composer.lock ./

# Install PHP dependencies specified in composer.json
RUN composer install --prefer-dist --ignore-platform-reqs

# Copy the rest of the application
COPY . .

# Stage 2: Production stage
FROM httpd

# Install PHP and Apache modules
RUN apt-get update && apt-get install -y \
    php \  
    libapache2-mod-php \  
    && apt-get clean  

# Copy the built application from the builder stage to the production stage
COPY --from=builder /app /usr/local/apache2/htdocs

# Set the correct file permissions for the web server user (www-data)
RUN chown -R www-data:www-data /usr/local/apache2/htdocs && \
    chmod -R 755 /usr/local/apache2/htdocs

# Expose port 80 for HTTP traffic
EXPOSE 80

# Set the working directory to where the application is located in the production container
WORKDIR /usr/local/apache2/htdocs/

# Start Apache in the foreground to serve the application
CMD ["httpd-foreground"]

