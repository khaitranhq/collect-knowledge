# Docker Buildx Bake

## What is Bake?

Docker Buildx Bake is a high-level build command (`docker buildx bake`) that allows you to define and run multiple builds in parallel using a single file (typically `docker-bake.hcl` or `docker-bake.json`). It is inspired by tools like `make` and provides a declarative way to describe complex build workflows.

## Features

- **Parallel builds:** Run multiple builds at once, improving build efficiency.
- **Declarative configuration:** Use HCL or JSON files to define build targets, arguments, tags, and more.
- **Target grouping:** Group related builds and run them together.
- **Matrix builds:** Easily define build matrices for multi-platform or multi-variant images.
- **Reusable definitions:** Share and reuse build configurations across projects.
- **Integration with BuildKit:** Leverage advanced BuildKit features for caching, exporting, and more.

## Why Use Docker Buildx Bake?

- **Simplifies complex builds:** Manage multi-image, multi-platform, or multi-stage builds with a single command.
- **Consistency:** Ensures all developers and CI systems use the same build definitions.
- **Efficiency:** Parallel execution and matrix builds reduce build times.
- **Maintainability:** Centralizes build configuration, making it easier to update and maintain.

## Setup

1. **Enable Buildx:**  
   Buildx is included with recent versions of Docker. To ensure it's available:

   ```sh
   docker buildx version
   ```

2. **Create a bake file:**  
   Create a `docker-bake.hcl` or `docker-bake.json` file in your project root.

---

```markdown
## Supported Configuration Files

Docker Buildx Bake can use a variety of configuration files as input, allowing flexibility in how you define your builds. Supported file types include:

- `docker-bake.hcl`
- `docker-bake.json`
- `docker-bake.override.hcl`
- `docker-bake.override.json`
- `compose.yaml`
- `compose.yml`
- `docker-compose.yaml`
- `docker-compose.yml`

When you run `docker buildx bake`, it will automatically detect and use these files if present in your project directory.
```

---

## Configuration Example (`docker-bake.hcl`)

```hcl
group "default" {
  targets = ["app", "db"]
}

target "app" {
  context = "./app"
  dockerfile = "Dockerfile"
  tags = ["myorg/app:latest"]
}

target "db" {
  context = "./db"
  dockerfile = "Dockerfile"
  tags = ["myorg/db:latest"]
}
```

## Usage

- **Run all default targets:**

  ```sh
  docker buildx bake
  ```

- **Run a specific target:**

  ```sh
  docker buildx bake app
  ```

- **Use a different bake file:**

  ```sh
  docker buildx bake -f custom-bake.hcl
  ```

- **Build with a matrix (multi-platform):**
  ```hcl
  target "app" {
    context = "./app"
    platforms = ["linux/amd64", "linux/arm64"]
    tags = ["myorg/app:latest"]
  }
  ```
  ```sh
  docker buildx bake app
  ```

## References

- [Docker Buildx Bake documentation](https://docs.docker.com/build/bake/)
