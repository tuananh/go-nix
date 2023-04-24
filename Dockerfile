# syntax = docker/dockerfile:1.2
FROM nixos/nix:latest AS builder

WORKDIR /tmp/build
COPY . ./

# setup nix & build
RUN nix \
    --extra-experimental-features "nix-command flakes" \
    --option filter-syscalls false \
    build

RUN mkdir /tmp/nix-store
RUN cp -R $(nix-store -qR result/) /tmp/nix-store

# final image
FROM cgr.dev/chainguard/static:latest

WORKDIR /app

COPY --from=builder /tmp/nix-store /nix/store
COPY --from=builder /tmp/build/result /app
CMD ["/app/bin/app"]
