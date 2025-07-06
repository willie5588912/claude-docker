FROM ubuntu:22.04

# Prevent interactive prompts during package installation
ENV DEBIAN_FRONTEND=noninteractive

# Install system dependencies
RUN apt-get update && apt-get install -y \
    curl \
    gnupg \
    lsb-release \
    software-properties-common \
    git \
    build-essential \
    python3 \
    python3-pip \
    wget \
    sudo \
    docker.io \
    nano \
    unzip \
    jq \
    mysql-client \
    && rm -rf /var/lib/apt/lists/*

# Install Node.js 20.x (required for npx and MCP servers)
RUN curl -fsSL https://deb.nodesource.com/setup_20.x | bash - \
    && apt-get install -y nodejs \
    && rm -rf /var/lib/apt/lists/*

# Install pnpm and newman globally
RUN npm install -g pnpm newman

# Install Terraform
RUN wget -O- https://apt.releases.hashicorp.com/gpg | gpg --dearmor | sudo tee /usr/share/keyrings/hashicorp-archive-keyring.gpg \
    && echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list \
    && apt-get update \
    && apt-get install -y terraform \
    && rm -rf /var/lib/apt/lists/*

# Install AWS CLI v2
RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" \
    && unzip awscliv2.zip \
    && ./aws/install \
    && rm -rf aws awscliv2.zip

# Claude CLI will be installed via entrypoint script in volume

# Pre-install MCP servers to avoid runtime downloads
RUN npm install -g @modelcontextprotocol/server-puppeteer \
    @line/line-bot-mcp-server

# Create a non-root user for running Claude
RUN useradd -m -s /bin/bash claude-user \
    && usermod -aG docker claude-user

# Clone and build mcp-postman
RUN git clone https://github.com/shannonlal/mcp-postman.git /opt/mcp-postman \
    && cd /opt/mcp-postman \
    && pnpm install \
    && pnpm build \
    && chown -R claude-user:claude-user /opt/mcp-postman

# Create necessary directories
RUN mkdir -p /home/claude-user/.config/claude-code \
    && mkdir -p /home/claude-user/.docker \
    && mkdir -p /opt/claude-node-modules \
    && chown -R claude-user:claude-user /home/claude-user /opt/claude-node-modules

# Copy and set up the entrypoint script
COPY docker-entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/docker-entrypoint.sh

# Switch to non-root user
USER claude-user
WORKDIR /home/claude-user

# Set up environment for Claude
ENV HOME=/home/claude-user
ENV PATH="/opt/claude-node-modules/bin:/home/claude-user/.local/bin:${PATH}"

# Entry point
ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]