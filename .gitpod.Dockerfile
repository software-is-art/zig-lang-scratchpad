FROM gitpod/workspace-full

# Get Zig 0.7.0 
RUN wget https://ziglang.org/download/0.7.0/zig-linux-x86_64-0.7.0.tar.xz
# Extract XZ archive
RUN xz -d zig-linux-x86_64-0.7.0.tar.xz
# Extract TAR archive
RUN tar -xf zig-linux-x86_64-0.7.0.tar
# Move Zig to /var/lib/zig
RUN mv zig-linux-x86_64-0.7.0 /var/lib/zig
# Symlink Zig executable to /bin/zig
RUN ln -s /var/lib/zig/zig /bin/zig
# Cleanup XZ archive
RUN rm zig-linux-x86_64-0.7.0.tar.xz
# Cleanup TAR archive
RUN rm zig-linux-x86_64-0.7.0.tar


