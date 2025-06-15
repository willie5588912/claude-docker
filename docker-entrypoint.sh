#!/bin/bash

# Check if Claude is installed in the volume
if [ ! -f "/opt/claude-node-modules/bin/claude" ]; then
    echo "Installing Claude CLI..."
    npm install -g --prefix /opt/claude-node-modules @anthropic-ai/claude-code
    echo "Claude CLI installation complete!"
fi

# Add claude to PATH
export PATH="/opt/claude-node-modules/bin:$PATH"

# Always execute claude with any provided arguments
exec claude "$@"