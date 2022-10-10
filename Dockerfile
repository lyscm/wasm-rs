# Rust as the base image
FROM rust

# 1. Create a new empty shell project

# 2. Copy our manifests
WORKDIR /app
COPY . .

RUN rustup target add wasm32-unknown-unknown && \
    cargo install trunk && \
    cargo install wasm-bindgen-cli

RUN trunk build

EXPOSE 8080
CMD ["trunk", "serve"]