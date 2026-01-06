# Build stage
FROM node:18-alpine AS build

WORKDIR /app

# Copy package files
COPY package*.json ./

# Install dependencies
RUN npm ci

# Copy source code
COPY . .

# Build the application
RUN npm run build

# Runtime stage
FROM node:18-alpine

WORKDIR /app

# Install serve to run the production build
RUN npm install -g serve

# Copy built application from build stage
COPY --from=build /app/dist ./dist

# Copy package.json for reference
COPY package.json .

# Expose port
EXPOSE 5173

# Environment variables
ENV VITE_API_BASE_URL=http://localhost:8080

# Health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=10s --retries=3 \
  CMD wget --quiet --tries=1 --spider http://localhost:5173 || exit 1

# Start the application
CMD ["serve", "-s", "dist", "-l", "5173"]
