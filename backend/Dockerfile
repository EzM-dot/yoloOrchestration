# Build stage
FROM node:14.21.3-alpine AS build

WORKDIR /usr/src/app

# Install build dependencies
RUN apk add --no-cache python3 make g++

# Copy package files
COPY package*.json ./

# Install dependencies
RUN npm install --production

# Copy application code
COPY . .

# Production stage
FROM node:14.21.3-alpine

WORKDIR /app

# Install runtime dependencies
RUN apk add --no-cache --update \
    tini

# Copy built application from build stage
COPY --from=build /usr/src/app /app

# Use tini as init process
ENTRYPOINT ["/sbin/tini", "--"]

# Expose application port
EXPOSE 5000

# Set non-root user
USER node

# Start the application
CMD ["node", "server.js"]