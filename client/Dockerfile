# Use an official Node runtime as a parent image
FROM node:14-slim AS build

# Set the working directory in the container
WORKDIR /usr/src/app

# Copy package files
COPY package*.json ./

# Install application dependencies
RUN npm install

# Copy the rest of the application code
COPY . .

# Build the application
RUN npm run build

# Use nginx to serve the built app
FROM nginx:alpine

# Copy the built app from the build stage
COPY --from=build /usr/src/app/build /usr/share/nginx/html

# Copy the images directory
COPY --from=build /usr/src/app/public/images /usr/share/nginx/html/images

# Copy the nginx configuration
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Expose port 80
EXPOSE 80

# Start nginx
CMD ["nginx", "-g", "daemon off;"]