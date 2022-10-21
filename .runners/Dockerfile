FROM debian:buster-slim

ENV DEBIAN_FRONTEND=noninteractive

# Arguments
ARG RUNNER_VERSION
ARG TARGETPLATFORM
ARG REPOSITORY_OWNER
ARG REPOSITORY_NAME
ARG BUILD_DATE
ARG VCS_REF
ARG RUNNER_USERNAME="non-root"

# Can be 'linux-x64', 'linux-arm64', 'linux-arm', 'rhel.6-x64'.
ARG TARGET_ARCH="linux-x64"

# Set Labels
LABEL AUTHOR="Integr8 Team"
LABEL EMAIL="intergr8.team@cronos.be"
LABEL GITHUB_URL=${REPOSITORY_NAME}
LABEL LINUX_VERSION="debian"
LABEL org.opencontainers.image.source https://github.com/${REPOSITORY_OWNER}/${REPOSITORY_NAME} \
    org.label-schema.build-date=${BUILD_DATE} \
    org.label-schema.vcs-ref=${VCS_REF}

# Update the packages & add a non-root user
RUN DEBIAN_FRONTEND=noninteractive apt-get update
RUN DEBIAN_FRONTEND=noninteractive apt-get upgrade -y
RUN apt-get update -y && apt-get upgrade -y 
RUN useradd -m ${RUNNER_USERNAME}

# Install needed packages. Use a separate RUN statement to add your
# own dependencies.
COPY scripts/*.sh /opt/scripts/

ARG UPGRADE_PACKAGES=true
RUN apt-get update \
    && /bin/bash /opt/scripts/install-packages.sh "${UPGRADE_PACKAGES}" \
    && apt-get autoremove -y \
    && apt-get clean -y \
    && rm -rf /var/lib/apt/lists/* /opt/scripts/

# Install Github actions runner
WORKDIR /home/${RUNNER_USERNAME}/actions-runner

COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf
RUN chmod 644 /etc/supervisor/conf.d/supervisord.conf

RUN RUNNER_VERSION=${RUNNER_VERSION:-$(curl --silent "https://api.github.com/repos/actions/runner/releases/latest" | grep tag_name | sed -E 's/.*"v([^"]+)".*/\1/')} \
    && curl -L -O https://github.com/actions/runner/releases/download/v${RUNNER_VERSION}/actions-runner-${TARGET_ARCH}-${RUNNER_VERSION}.tar.gz \
    && tar -zxf actions-runner-${TARGET_ARCH}-${RUNNER_VERSION}.tar.gz \
    && rm -f actions-runner-${TARGET_ARCH}-${RUNNER_VERSION}.tar.gz \
    && ./bin/installdependencies.sh \
    && rm -rf /var/lib/apt/lists/* \
    && apt-get clean

# Set entrypoint to 'entrypoint.sh' script
COPY ./entrypoint.sh .
RUN chmod +x ./entrypoint.sh && chown -R ${RUNNER_USERNAME} .
USER ${RUNNER_USERNAME}

ENTRYPOINT ["./entrypoint.sh"]
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]