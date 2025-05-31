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
    && rm -rf /var/lib/apt/lists/*

# Install Node.js 20.x (required for npx and MCP servers)
RUN curl -fsSL https://deb.nodesource.com/setup_20.x | bash - \
    && apt-get install -y nodejs \
    && rm -rf /var/lib/apt/lists/*

# Install pnpm (required for mcp-postman)
RUN npm install -g pnpm

# Install Claude CLI
RUN npm install -g @anthropic-ai/claude-code

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
    && chown -R claude-user:claude-user /home/claude-user

# Switch to non-root user
USER claude-user
WORKDIR /home/claude-user

# Set up environment for Claude
ENV HOME=/home/claude-user
ENV PATH="/home/claude-user/.local/bin:${PATH}"

# Entry point
ENTRYPOINT ["claude"]