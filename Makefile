.PHONY: build build-no-cache install uninstall clean help

# Default target
help:
	@echo "Available targets:"
	@echo "  make build         - Build the claude-docker Docker image"
	@echo "  make build-no-cache - Build the Docker image without cache"
	@echo "  make install  - Install claude-docker command to ~/.local/bin"
	@echo "  make uninstall - Remove claude-docker command from ~/.local/bin"
	@echo "  make clean    - Remove Docker image and clean up"
	@echo "  make all      - Build and install"

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
	@echo "Installing claude-docker to ~/.local/bin..."
	@chmod +x claude-docker
	@mkdir -p ~/.local/bin
	@cp claude-docker ~/.local/bin/claude-docker
	@echo "Installation complete!"
	@echo ""
	@echo "Make sure ~/.local/bin is in your PATH by adding this to ~/.bashrc:"
	@echo '  export PATH="$$HOME/.local/bin:$$PATH"'
	@echo ""
	@echo "Then reload your shell or run: source ~/.bashrc"

# Uninstall
uninstall:
	@rm -f ~/.local/bin/claude-docker
	@echo "Uninstalled claude-docker"

# Clean up
clean:
	@docker rmi claude-docker:latest 2>/dev/null || true
	@echo "Cleaned up Docker image"

# Build and install
all: build install