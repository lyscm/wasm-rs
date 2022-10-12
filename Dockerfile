####################################################################################################
## Builder
####################################################################################################
FROM rust as builder

WORKDIR /opt/wasm
COPY . .

RUN apt-get update
RUN rustup target add wasm32-unknown-unknown

RUN TRUNK_VERSION=${TRUNK_VERSION:-$(curl --silent "https://api.github.com/repos/thedodd/trunk/releases/latest" | grep tag_name | sed -E 's/.*"v([^"]+)".*/\1/')} \
    && wget -qO- https://github.com/thedodd/trunk/releases/download/v${TRUNK_VERSION}/trunk-x86_64-unknown-linux-gnu.tar.gz | tar -xzf- \
    && apt-get clean

RUN ./trunk build --release

####################################################################################################
## Runtime
####################################################################################################
FROM gcr.io/distroless/cc:nonroot as runtime

EXPOSE 8080

# Arguments
ARG VCS_REF
ARG VERSION
ARG BUILD_DATE
ARG REPOSITORY_NAME
ARG WORKING_DIRECTORY=/opt/wasm

# Environments
ENV VCS_REF=${VCS_REF}
ENV VERSION=${VERSION}
ENV BUILD_DATE=${BUILD_DATE}
ENV REPOSITORY_NAME=${REPOSITORY_NAME}

# Labels
LABEL org.opencontainers.image.source https://github.com/${REPOSITORY_NAME}

# Copies
WORKDIR ${WORKING_DIRECTORY}
COPY --from=builder ${WORKING_DIRECTORY}/dist ./dist
COPY --from=builder ${WORKING_DIRECTORY}/css ./css
COPY --from=builder ${WORKING_DIRECTORY}/img ./img
COPY --from=builder ${WORKING_DIRECTORY}/*.toml ${WORKING_DIRECTORY}/*.html ${WORKING_DIRECTORY}/trunk ./

CMD ["./trunk", "serve"]