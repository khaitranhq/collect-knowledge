# Docker Provenance

Docker provenance refers to the metadata that tracks the origin, history, and authenticity of container images. It provides transparency about how images are built and ensures supply chain security.

## What is Docker Provenance?

Provenance data answers key questions:

- **Who** built the image?
- **When** was it built?
- **What** went into building it (build context, dependencies)?
- **How** was it built (build instructions, tools)?
- **Where** did it come from?

## Key Components

| Component                             | Purpose                                 |
| ------------------------------------- | --------------------------------------- |
| **Build Attestation**                 | Records details about the build process |
| **SBoM (Software Bill of Materials)** | Lists all components and dependencies   |
| **Signatures**                        | Cryptographic proof of authenticity     |
| **Metadata**                          | Creation time, builder info, labels     |

## Docker Buildx and Provenance

Docker Buildx supports provenance recording through build attestations. When enabled, it captures comprehensive build information.

### Enable Provenance in Builds

```bash
# Build with provenance (default format: v1)
docker buildx build --provenance=true -t myimage:latest .

# Build with provenance and push to registry
docker buildx build --provenance=true -t myregistry.com/myimage:latest --push .

# Use specific provenance format
docker buildx build --provenance=mode=min -t myimage:latest .
```

### Provenance Modes

| Mode    | Description                                |
| ------- | ------------------------------------------ |
| `max`   | Full provenance with all details (default) |
| `min`   | Minimal provenance information             |
| `true`  | Enable provenance with default settings    |
| `false` | Disable provenance recording               |

## View Image Provenance

### Using Docker Scout

```bash
# View provenance of a local image
docker scout cves myimage:latest --include-build-info

# View detailed attestation
docker buildx build --provenance=true -t myimage:latest . --output type=oci
```

### Using ORAS (OCI Artifact Store)

```bash
# Install ORAS
curl -sSLO https://github.com/oras-project/oras/releases/download/v1.0.0/oras_1.0.0_linux_amd64.tar.gz
tar xzf oras_1.0.0_linux_amd64.tar.gz

# Pull provenance attestation from registry
oras pull registry.example.com/myimage:latest
```

## SBOM (Software Bill of Materials)

Generate SBoM during build:

```bash
# Build with SBoM generation
docker buildx build --sbom=true -t myimage:latest .

# Specify SBoM format (cyclonedx, spdx)
docker buildx build --sbom=type=cyclonedx -t myimage:latest .
```

## Signing and Verifying Images

### Sign an Image with Cosign

```bash
# Sign an image
cosign sign --key cosign.key registry.example.com/myimage:latest

# Verify image signature
cosign verify --key cosign.pub registry.example.com/myimage:latest

# Attach attestation
cosign attest --key cosign.key --predicate attestation.json registry.example.com/myimage:latest
```

## Best Practices

- **Always enable provenance** for production images
- **Store attestations securely** in your registry
- **Verify signatures** before deploying images
- **Include build context** in provenance for transparency
- **Use signed commits** in source control
- **Automate verification** in CI/CD pipelines

## Example: Complete Build with Provenance

```dockerfile
# Dockerfile
FROM alpine:3.18
LABEL maintainer="devops@example.com"
LABEL version="1.0"
RUN apk add --no-cache python3 py3-pip
COPY requirements.txt .
RUN pip install -r requirements.txt
CMD ["python3", "app.py"]
```

```bash
# Build with full provenance and push
docker buildx build \
  --provenance=true \
  --sbom=type=spdx \
  -t myregistry.com/myapp:v1.0 \
  --push \
  .
```

## Benefits

✅ **Supply chain security** - Track image origins and authenticity
✅ **Compliance** - Meet regulatory requirements for software provenance
✅ **Vulnerability tracking** - Link vulnerabilities to build information
✅ **Audit trail** - Complete history of image creation
✅ **Trust** - Verify images come from trusted sources

## References

- [Docker Buildx Provenance Documentation](https://docs.docker.com/build/attestations/)
- [ORAS - OCI Artifact Store](https://oras.land/)
- [Cosign - Container Signing](https://docs.sigstore.dev/cosign/overview/)
- [SLSA Framework](https://slsa.dev/)
