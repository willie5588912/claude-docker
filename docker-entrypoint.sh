#!/bin/bash

# Check if Claude is installed in the volume
if [ ! -f "/opt/claude-node-modules/bin/claude" ]; then
    echo "Installing Claude CLI..."
    npm install -g --prefix /opt/claude-node-modules @anthropic-ai/claude-code
    echo "Claude CLI installation complete!"
fi

# Add claude to PATH
export PATH="/opt/claude-node-modules/bin:$PATH"

# Execute Claude with the provided arguments
if [ $# -eq 0 ]; then
    # No arguments provided, run claude with no args
    exec claude
else
    # Arguments provided, run claude with those arguments
    exec claude "$@"
fi