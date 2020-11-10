FROM gitpod/workspace-full

USER root
# Get Zig 0.7.0 
RUN wget https://ziglang.org/download/0.7.0/zig-linux-x86_64-0.7.0.tar.xz && \
# Extract XZ archive
xz -d zig-linux-x86_64-0.7.0.tar.xz && \
# Extract TAR archive
tar -xf zig-linux-x86_64-0.7.0.tar && rm zig-linux-x86_64-0.7.0.tar && \
# Move Zig to /usr/local/lib/zig
mv zig-linux-x86_64-0.7.0 /usr/local/lib/zig && \
# Symlink Zig executable to /usr/local/bin/zig
ln -s /usr/local/lib/zig/zig /usr/local/bin/zig



