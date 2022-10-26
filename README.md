# **INSTALL DEPENDENCIES**

---

> Bash

```bash
# Update Rust via 'rustup'
rustup update

# Install Cargo targets
rustup target add wasm32-unknown-unknown

# Install via Cargo.
cargo install trunk wasm-bindgen-cli

# # Until wasm-bindgen has pre-built binaries for Apple M1, M1 users will
# need to install wasm-bindgen manually.
cargo install wasm-bindgen-cli

# When running in trouble execute the following command:
apt install pkg-config

# Install rustfmt:
rustup component add rustfmt
```

# **BUILD AND RUN LOCALLY**

---


> Bash

```bash
# Within a local terminal
trunk serve --open

# Within a container
docker buildx build -t local-wasm -f Dockerfile . # takes approx. 2 - 3 minutes

docker run \
    -it \
    --rm \
    -p 8080:8080 \
    local-wasm
```

# **CI/CD DEPLOYMENTS**

---

```bash
# Log into Azure
az login

# Create Service Principal
az ad sp create-for-rbac \
    --name "sp-github-cicd" \
    --role Contributor \
    --scopes /subscriptions/0d3c0705-eceb-4276-832f-379f84e62023
```