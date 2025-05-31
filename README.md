# Claude Docker

A Docker-based setup for running Claude CLI with multi-account support and MCP servers.

## Features

- 🐳 Run Claude in an isolated Docker environment
- 👥 Easy account switching by using different home directories
- 🔧 Pre-installed MCP servers (GitHub, Atlassian, Postman, Puppeteer, LINE Bot)
- 📁 Preserves project structure and chat history
- 🔒 Keeps sensitive configurations separate from project files

## Prerequisites

- Docker installed and running
- Git (for installation)
- Unix-like operating system (Linux/macOS)

## Installation

1. Clone this repository:
```bash
git clone git@github.com:willie5588912/claude-docker.git
cd claude-docker
```

2. Build the Docker image:
```bash
make build
```

3. Install the `claude-docker` command:
```bash
make install
```

4. Ensure `~/.local/bin` is in your PATH:
```bash
echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.bashrc
source ~/.bashrc
```

## Usage

Use `claude-docker` exactly like the regular `claude` command:

```bash
# Start a new conversation
claude-docker

# Continue the last conversation
claude-docker --resume

# List and continue previous conversations
claude-docker -c

# Use with specific options
claude-docker --model claude-3-opus --no-stream
```

## Configuration

### MCP Servers

Place your `.mcp.json` file in your project directory. The Docker container will read it from the mounted directory.

Example `.mcp.json`:
```json
{
  "mcpServers": {
    "github": {
      "command": "docker",
      "args": ["run", "-i", "--rm", "-e", "GITHUB_PERSONAL_ACCESS_TOKEN", "ghcr.io/github/github-mcp-server"],
      "env": {
        "GITHUB_PERSONAL_ACCESS_TOKEN": "your-token-here"
      }
    }
  }
}
```

### User Settings

User-specific settings and chat history are stored in `~/.local/share/claude-home/` and persist across sessions.

## How It Works

1. **Docker Image**: Contains Claude CLI and all necessary MCP servers
2. **Volume Mounts**: 
   - Current directory → Same path in container (preserves project structure)
   - `~/.local/share/claude-home` → `/home/claude-user` (user settings)
   - Docker socket → Allows MCP servers to run Docker containers
3. **Permissions**: Automatically handles Docker socket permissions for MCP servers

## Troubleshooting

### Docker Permission Issues

If you encounter Docker permission errors, ensure your user is in the docker group:
```bash
sudo usermod -aG docker $USER
# Log out and back in for changes to take effect
```

### MCP Server Connection Issues

Check that your `.mcp.json` file:
- Has correct paths (use `/opt/mcp-postman` for the built-in Postman server)
- Contains valid API tokens
- Is not tracked by git (should be in `.gitignore`)

## Development

### Project Structure

```
claude-docker/
├── Dockerfile          # Docker image definition
├── claude-docker       # Shell script wrapper
├── Makefile           # Build and install automation
├── .gitignore         # Excludes sensitive files
└── README.md          # This file
```

### Included MCP Servers

- **GitHub**: Docker-based, for GitHub operations
- **Atlassian**: Docker-based, for Jira/Confluence
- **Postman**: Built from source, for API testing
- **Puppeteer**: NPM package, for browser automation
- **LINE Bot**: NPM package, for LINE messaging

## Security Notes

- Never commit `.mcp.json` files containing API tokens
- The `.gitignore` file excludes sensitive configuration files
- Docker socket access is limited to the necessary group permissions

## License

This project is for personal use. Please ensure you comply with Anthropic's Claude terms of service.

## Contributing

Feel free to submit issues or pull requests for improvements.

---

Created by Wei Shih (@willie5588912)