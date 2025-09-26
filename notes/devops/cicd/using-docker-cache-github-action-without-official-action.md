# Docker Build Caching in GitHub Actions Without Official Actions

## Problem

When building Docker images in GitHub Actions, you may encounter situations where you cannot use the official Docker actions (like `docker/build-push-action`) but still want to leverage GitHub's built-in cache to speed up builds.

## Solution Overview

This approach manually exposes the required GitHub Actions cache environment variables and uses `docker buildx` with GitHub Actions cache (GHA) backend directly.

## Implementation

### Step 1: Export Cache Environment Variables

GitHub Actions provides cache functionality through internal environment variables that aren't exposed by default. We need to make these available to our Docker build process.

```yaml
- name: Adding required env vars for caching Docker build
  uses: actions/github-script@v7
  env:
    github-token: ${{ secrets.GITHUB_TOKEN }}
  with:
    script: |
      core.exportVariable('ACTIONS_CACHE_URL', process.env['ACTIONS_CACHE_URL'])
      core.exportVariable('ACTIONS_RUNTIME_TOKEN', process.env['ACTIONS_RUNTIME_TOKEN'])
      core.exportVariable('ACTIONS_RUNTIME_URL', process.env['ACTIONS_RUNTIME_URL'])
```

### Step 2: Verify Environment Variables (Optional)

For debugging purposes, you can verify that the environment variables are properly set:

```yaml
- name: Echo required env vars
  shell: bash
  run: |
    echo "ACTIONS_CACHE_URL: $ACTIONS_CACHE_URL"
    echo "ACTIONS_RUNTIME_TOKEN: $ACTIONS_RUNTIME_TOKEN"
    echo "ACTIONS_RUNTIME_URL: $ACTIONS_RUNTIME_URL"
```

### Step 3: Build with Cache

Use `docker buildx` with the GitHub Actions cache backend:

```yaml
- name: Build and push Docker image
  run: |
    echo "Building and pushing Docker image..."
    docker buildx build \
      --file ./docker/Dockerfile \
      --push \
      --tag "${IMAGE_TAG_PREFIX}-latest" \
      --tag "${IMAGE_TAG_PREFIX}-${{ github.run_number }}" \
      --cache-from type=gha \
      --cache-to type=gha,mode=max \
      .
  env:
    DOCKER_BUILDKIT: 1
```

## Key Components Explained

### Environment Variables

- **`ACTIONS_CACHE_URL`**: The GitHub Actions cache service endpoint
- **`ACTIONS_RUNTIME_TOKEN`**: Authentication token for cache access
- **`ACTIONS_RUNTIME_URL`**: Runtime service endpoint for GitHub Actions

### Cache Configuration

- **`--cache-from type=gha`**: Use GitHub Actions cache as the source for build cache layers
- **`--cache-to type=gha,mode=max`**: Save all build layers to GitHub Actions cache (maximum caching)

### BuildKit

- **`DOCKER_BUILDKIT=1`**: Enables Docker BuildKit, which is required for advanced caching features

## Benefits

- ✅ **Faster builds**: Reuses cached layers across builds
- ✅ **No external dependencies**: Uses GitHub's built-in cache
- ✅ **Cost-effective**: No need for external registry for cache storage
- ✅ **Simple setup**: Works with standard Docker commands

## Limitations

- Cache is tied to the repository and branch
- Cache storage limits apply (typically 10GB per repository)
- Requires BuildKit-compatible Docker setup

## Use Cases

This approach is particularly useful when:

- You need custom Docker build logic not supported by official actions
- Working with complex multi-stage builds
- Building from custom base images
- Integrating with existing Docker-based workflows

