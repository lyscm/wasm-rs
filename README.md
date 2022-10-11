# **INSTALL DEPENDENCIES**

---

```bash
# Update Rust via 'rustup'
rustup update

# Install Cargo targets
rustup target add wasm32-unknown-unknown

# Install via Cargo.
cargo install trunk

# # Until wasm-bindgen has pre-built binaries for Apple M1, M1 users will
# need to install wasm-bindgen manually.
cargo install wasm-bindgen-cli

# When running in trouble execute the following command: 'apt install pkg-config'.
```