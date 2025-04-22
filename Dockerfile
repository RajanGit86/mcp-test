# Use an official Node.js runtime as a parent image
FROM --platform=linux/amd64 node:18-alpine AS builder

# Set the working directory in the container
WORKDIR /app

# Copy package.json and package-lock.json
COPY package.json ./

# Install dependencies
RUN npm install

# Copy the rest of the application code
COPY . ./

# Build the TypeScript code
RUN npm run build

# Use a smaller image for the runtime
FROM --platform=linux/amd64 node:18-alpine

# Set the working directory in the container
WORKDIR /app

# Copy only the built files and dependencies from the builder stage
COPY --from=builder /app/dist ./dist
COPY --from=builder /app/package.json ./
COPY --from=builder /app/node_modules ./node_modules

# Expose the port the app runs on
EXPOSE 3000

# Command to run the application
CMD ["node", "dist/index.js"]