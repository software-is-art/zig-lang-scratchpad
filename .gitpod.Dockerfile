FROM gitpod/workspace-full

RUN brew switch zig 0.6.0 && \
brew install zig
