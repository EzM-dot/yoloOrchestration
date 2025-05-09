# Docker Implementation Explanation

## 1. Choice of Base Images

### Frontend (React)
- **Base Image**: `node:14-slim`
  - **Reasoning**:
    - Lightweight version of Node.js
    - Version 14 provides LTS
    - Contains only essential packages, reducing attack surface
    - Smaller image size compared to the full Node.js image

### Backend (Node.js)
- **Base Image**: `node:14`
  - **Reasoning**:
    - Full Node.js runtime environment
    - Includes necessary build tools and npm
    - Matches the development environment

### Database
- **Base Image**: `mongo:latest`
  - **Reasoning**:
    - Official MongoDB image
    - Regularly updated with security patches
    - Well-documented and widely used

## 2. Dockerfile Directives

### Frontend Dockerfile
```dockerfile
FROM node:14-slim
WORKDIR /usr/src/app
COPY package*.json ./
RUN npm install
COPY . .
RUN chmod +x /usr/src/app/start.sh
EXPOSE 3000
CMD ["./start.sh"]
```

### Backend Dockerfile
```dockerfile
FROM node:14
WORKDIR /usr/src/app
COPY package*.json ./
RUN npm install
COPY . .
EXPOSE 5000
CMD ["node", "server.js"]
```

## 3. Docker-compose Networking

```yaml
networks:
  app-net:
    driver: bridge
```

- **Port Allocation**:
  - Frontend: 3000:3000
  - Backend: 5000:5000
  - MongoDB: 27017:27017

- **Bridge Network**:
  - Created a custom bridge network `app-net`
  - Enables secure communication between containers
  - Isolates the application from other Docker networks

## 4. Docker-compose Volume

```yaml
volumes:
  app-mongo-data:
```

- **Use is **:
  - Persistent storage for MongoDB data
  - Ensures data persistence across container restarts
  - Mounted at `/data/db` in the MongoDB container

## 5. Git Workflow

1. **Branching Strategy**:
   - Main branch for production-ready code
   - Feature branches for new features
   - Pull requests for code review

2. **Commit Messages**:
   - Descriptive and concise
   - Follow conventional commit format
   - Reference issue numbers when applicable

3. **Version Control**:
   - Regular commits with meaningful messages
   - .dockerignore to exclude unnecessary files
   - Proper documentation in README.md

## 6. Application Execution & Debugging

### Successes
- Frontend accessible at http://localhost:3000
- Backend API running on port 5000
- MongoDB container operational

### Challenges & Solutions
1. **Permission Issues**:
   - **Issue**: Docker permission denied errors
   - **Solution**: Used `sudo` for Docker commands

2. **Host Header Validation**:
   - **Issue**: React development server blocking ngrok
   - **Solution**: Added environment variables to disable host check

3. **Container Communication**:
   - **Issue**: Containers couldn't resolve each other's hostnames
   - **Solution**: Used Docker's internal DNS with service names

## 7. Best Practices

### Image Tagging
- Followed semantic versioning (e.g., v1.0.0)
- Used descriptive tags for different environments
- Example: `brian-yolo-client:v1.0.0`

### Container Naming
- Descriptive service names
- Consistent naming convention
- Example: `brian-yolo-client`, `brian-yolo-backend`

### Security
- Minimal base images
- Regular updates
- No sensitive data in Dockerfiles

### Image Details
- **Frontend**: `brianbwire/brian-yolo-client:v1.0.0`
- **Backend**: `brianbwire/brian-yolo-backend:v1.0.0`
