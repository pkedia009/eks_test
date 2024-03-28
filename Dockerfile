# Use the official NGINX base image
FROM nginx:latest

# Copy custom configuration file to NGINX config directory
COPY nginx.conf /etc/nginx/nginx.conf

# Copy static files (HTML, CSS, JS, etc.) to NGINX web root directory
COPY ./static-files /usr/share/nginx/html

# Expose port 80 to allow external access
EXPOSE 80
