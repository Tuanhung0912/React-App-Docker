# Use an official Node.js runtime as a parent image
FROM node:lts-alpine as builder

# Set the working directory in the container
WORKDIR '/app'

# Install dependencies and build the application
COPY package.json .
RUN npm install
COPY . .
RUN npm run build

# Use an official Nginx image to serve the built application
FROM nginx
COPY --from=builder /app/build /usr/share/nginx/html