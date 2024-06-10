FROM node:16

COPY . /app

# Set the working directory inside the container
WORKDIR /app

# Install npm dependencies
RUN npm install

# Install Docker
RUN apt-get update && \
    apt-get install -y \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg \
    lsb-release && \
    curl -fsSL https://download.docker.com/linux/debian/gpg | gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg && \
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/debian $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null && \
    apt-get update && \
    apt-get install -y docker-ce docker-ce-cli containerd.io

RUN systemctl start docker

# Copy the dockerBuild.sh file and make it executable
COPY dockerBuild.sh /app/dockerBuild.sh
RUN chmod +x /app/dockerBuild.sh

# Run the dockerBuild.sh script
RUN /app/dockerBuild.sh

# Expose the application port (if applicable)
EXPOSE 5000

# Command to run the application
CMD ["npm", "start"]