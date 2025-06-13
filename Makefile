.PHONY: build build-no-cache install uninstall clean help update-claude

# Default target
help:
	@echo "Available targets:"
	@echo "  make build         - Build the claude-docker Docker image"
	@echo "  make build-no-cache - Build the Docker image without cache"
	@echo "  make install  - Install claude-docker and update-claude commands to ~/.local/bin"
	@echo "  make uninstall - Remove claude-docker and update-claude commands from ~/.local/bin"
	@echo "  make clean    - Remove Docker image and clean up"
	@echo "  make all      - Build and install"
	@echo "  make update-claude - Update Claude CLI to latest version"

# Build the Docker image
build:
	@echo "Building claude-docker image..."
	docker build -t claude-docker:latest .

# Build the Docker image without cache
build-no-cache:
	@echo "Building claude-docker image without cache..."
	docker build --no-cache -t claude-docker:latest .

# Install the command
install:
	@echo "Installing claude-docker and update-claude to ~/.local/bin..."
	@chmod +x claude-docker update-claude
	@mkdir -p ~/.local/bin
	@cp claude-docker ~/.local/bin/claude-docker
	@cp update-claude ~/.local/bin/update-claude
	@echo "Installation complete!"
	@echo ""
	@echo "Make sure ~/.local/bin is in your PATH by adding this to ~/.bashrc:"
	@echo '  export PATH="$$HOME/.local/bin:$$PATH"'
	@echo ""
	@echo "Then reload your shell or run: source ~/.bashrc"
	@echo ""
	@echo "To update Claude CLI later, run: update-claude"

# Uninstall
uninstall:
	@rm -f ~/.local/bin/claude-docker ~/.local/bin/update-claude
	@echo "Uninstalled claude-docker and update-claude"

# Clean up
clean:
	@docker rmi claude-docker:latest 2>/dev/null || true
	@echo "Cleaned up Docker image"

# Update Claude CLI
update-claude:
	@./update-claude

# Build and install
all: build install