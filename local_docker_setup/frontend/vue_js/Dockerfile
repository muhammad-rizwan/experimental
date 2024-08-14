# frontend/vue_js/Dockerfile

# Use Node.js 18 as the base image
FROM node:18

# Set the working directory inside the container
WORKDIR /app

# Copy package.json and package-lock.json
#COPY package*.json ./

# Install dependencies
#RUN npm install

# Copy the rest of the application
#COPY . .

# Expose the port Vue.js uses
EXPOSE 8080

# Start the Vue.js development server
#CMD ["npm", "run", "serve"]

# Default command to keep the container running for manual intervention
CMD ["tail", "-f", "/dev/null"]
