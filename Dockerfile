FROM rust as build

WORKDIR /home/wasm
COPY . .

RUN apt-get update
RUN rustup target add wasm32-unknown-unknown

RUN TRUNK_VERSION=${TRUNK_VERSION:-$(curl --silent "https://api.github.com/repos/thedodd/trunk/releases/latest" | grep tag_name | sed -E 's/.*"v([^"]+)".*/\1/')} \
    && wget -qO- https://github.com/thedodd/trunk/releases/download/v${TRUNK_VERSION}/trunk-x86_64-unknown-linux-gnu.tar.gz | tar -xzf- \
    && apt-get clean

RUN ./trunk build --release

FROM gcr.io/distroless/cc:nonroot as runtime

EXPOSE 8080

ARG WORKING_DIRECTORY=/home/wasm
WORKDIR ${WORKING_DIRECTORY}

COPY --from=build ${WORKING_DIRECTORY}/bin ./bin
COPY --from=build ${WORKING_DIRECTORY}/css ./css
COPY --from=build ${WORKING_DIRECTORY}/img ./img
COPY --from=build ${WORKING_DIRECTORY}/Trunk.toml ${WORKING_DIRECTORY}/*.html ${WORKING_DIRECTORY}/trunk ./

CMD ["trunk", "serve"]