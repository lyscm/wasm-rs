# **CI/CD PIPELINES**

When running into CI/CD issues (e.g. Private Networks), use the following commands to start listening for `Github` jobs with Self-Hosted runners - on a computer or `Azure Container Instance` (i.e. ACR)  within said Network(s):

> Powershell

```powershell
# Set variables
$TAG="local-runner"
$RUNNER_REPOSITORY_URL="https://github.com/lyscm/wasm-rs"
$GITHUB_PERSONAL_ACCESS_TOKEN="<Personal Access Token>"

# Create local image
$CONTEXT_DIR="./.runners"
docker buildx build --platform=local -t $TAG -f "$CONTEXT_DIR/Dockerfile" $CONTEXT_DIR

# Run local runner
docker run -it --rm `
    -e RUNNER_REPOSITORY_URL=$RUNNER_REPOSITORY_URL `
    -e GITHUB_PERSONAL_ACCESS_TOKEN=$GITHUB_PERSONAL_ACCESS_TOKEN `
    $TAG
```

| Name | Description |  |
|------|---------------|-------------|
| `RUNNER_REPOSITORY_URL` | The runner will be linked to this repository URL | Required if `RUNNER_ORGANIZATION_URL` is not provided. |
| `RUNNER_ORGANIZATION_URL` | The runner will be linked to this organization URL.<ul><li>*Self-hosted runners API for organizations is currently in public beta and subject to changes*</li></ul> | Required if `RUNNER_REPOSITORY_URL` is not provided. |
| `GITHUB_PERSONAL_ACCESS_TOKEN` | PAT used to dynamically fetch a new runner token. <ul><li>For a single-repository runner, your PAT should have `repo` scopes.</li><li>For an organization runner, your PAT should have `admin:org` scopes.</li></ul> |


**<font color="red">NOTE!</font>** The GitHub runner (the binary) will update itself when receiving a job, if a new release is available.
In order to allow the runner to exit and restart by itself, the binary is started by a supervisord process.

# **DISCLAIMER**

---

The code and configurations are based on **[tcardonne](https://github.com/tcardonne/docker-github-runner)** and **[Pwd9000-ML](https://github.com/Pwd9000-ML/docker-github-runner-linux)**.
