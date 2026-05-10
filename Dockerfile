# ───────────────────────────────────────────────────────────
# Stage 1: BUILD — Install dependencies and build the React app
# ───────────────────────────────────────────────────────────
FROM node:20-alpine AS builder

# Set the working directory in the container
WORKDIR /app

# Install dependencies (cached layer — only re-runs when package.json changes)
COPY package.json .
RUN npm install

# Copy the rest of the source code and build the production bundle
COPY . .
RUN npm run build

# ───────────────────────────────────────────────────────────
# Stage 2: SERVE — Use Nginx to serve the built static files
# ───────────────────────────────────────────────────────────
FROM nginx:1.27-alpine

# Copy custom Nginx config (port 8080, security headers, SPA routing)
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Copy built assets from the builder stage
COPY --from=builder /app/dist /usr/share/nginx/html

# Grant the 'nginx' user ownership of all required directories
# so the container can run without root privileges
RUN chown -R nginx:nginx /usr/share/nginx/html \
    && chown -R nginx:nginx /var/cache/nginx \
    && chown -R nginx:nginx /var/log/nginx \
    && touch /var/run/nginx.pid \
    && chown -R nginx:nginx /var/run/nginx.pid

# Run as non-root user for security
USER nginx

# Document the port this container listens on
EXPOSE 8080