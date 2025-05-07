# Use Node.js as base image
FROM node:14-slim

# Set working directory
WORKDIR /usr/src/app

# Install dependencies
COPY package*.json ./
RUN npm install

# Copy app source
COPY . .
# Make start script executable
RUN chmod +x /usr/src/app/start.sh

# Expose port 3000
EXPOSE 3000

# Start the application
CMD ["./start.sh"]