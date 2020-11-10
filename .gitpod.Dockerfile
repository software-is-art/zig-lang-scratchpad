FROM gitpod/workspace-full

# Get Zig 0.7.0 
RUN wget https://ziglang.org/download/0.7.0/zig-linux-x86_64-0.7.0.tar.xz && \
# Extract XZ archive
xz -d zig-linux-x86_64-0.7.0.tar.xz && \
# Extract TAR archive
tar -xf zig-linux-x86_64-0.7.0.tar && \
# Move Zig to /var/lib/zig
mv zig-linux-x86_64-0.7.0 /var/lib/zig && \
# Symlink Zig executable to /bin/zig
ln -s /var/lib/zig/zig /bin/zig && \
# Cleanup XZ archive
rm -r zig-linux-x86_64-0.7.0.tar.xz && \
# Cleanup TAR archive
rm -r zig-linux-x86_64-0.7.0.tar


