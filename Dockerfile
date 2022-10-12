# Rust as the base image
FROM rust as build

WORKDIR /home/wasm
COPY . .

RUN apt-get update
RUN rustup target add wasm32-unknown-unknown

RUN TRUNK_VERSION=${TRUNK_VERSION:-$(curl --silent "https://api.github.com/repos/thedodd/trunk/releases/latest" | grep tag_name | sed -E 's/.*"v([^"]+)".*/\1/')} \
    && wget -qO- https://github.com/thedodd/trunk/releases/download/v${TRUNK_VERSION}/trunk-x86_64-unknown-linux-gnu.tar.gz | tar -xzf- \
    && apt-get clean

RUN ./trunk build --release

FROM debian:bullseye-slim as runtime

ARG TRUNK_VERSION
ARG USERNAME="non-root"

EXPOSE 8080

# Download Trunk executable
RUN useradd -m ${USERNAME}

WORKDIR /home/${USERNAME}/wasm

# Download from build-stage
COPY --from=build /home/wasm/bin ./bin
COPY --from=build /home/wasm/css ./css
COPY --from=build /home/wasm/img ./img
COPY --from=build /home/wasm/index.html ./index.html
COPY --from=build /home/wasm/Trunk.toml ./Trunk.toml
COPY --from=build /home/wasm/trunk ./trunk

# Set executable & non-root user
RUN chown -R ${USERNAME} .
USER ${USERNAME}

ENTRYPOINT [ "/bin/sh" ]
CMD ["-c", "./trunk serve"]