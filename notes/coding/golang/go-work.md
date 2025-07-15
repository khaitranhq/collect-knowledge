# Go Workspaces

Go workspaces were introduced in Go 1.18 as a feature that allows you to work with multiple modules simultaneously without having to edit individual `go.mod` files. This document provides comprehensive information about Go workspaces, their benefits, and how to configure them.

## Table of Contents

- [What are Go Workspaces?](#what-are-go-workspaces)
- [Benefits of Go Workspaces](#benefits-of-go-workspaces)
- [How to Configure Go Workspaces](#how-to-configure-go-workspaces)
- [go.work File Structure](#gowork-file-structure)
- [Common Commands](#common-commands)
- [Practical Examples](#practical-examples)
- [Best Practices](#best-practices)
- [Migration from GOPATH](#migration-from-gopath)
- [Troubleshooting](#troubleshooting)

## What are Go Workspaces?

Go workspaces are a feature that allows you to work on multiple Go modules simultaneously within a single workspace. A workspace is defined by a `go.work` file that specifies relative paths to the module directories of each module in the workspace.

### Key Concepts

- **Workspace**: A collection of modules on disk that are used as the main modules when running minimal version selection (MVS)
- **go.work file**: The file that defines the set of modules to be used in a workspace
- **Multi-module development**: The ability to work on multiple related modules simultaneously
- **Unified dependency management**: Managing dependencies across multiple modules from a single workspace

### When to Use Workspaces

- Developing multiple related modules that depend on each other
- Working on a module and its dependencies simultaneously
- Testing changes across multiple modules before publishing
- Managing a monorepo with multiple Go modules
- Local development with unpublished dependencies

## Benefits of Go Workspaces

### 1. Simplified Multi-Module Development

Before workspaces, working on multiple modules required:
- Using `replace` directives in `go.mod` files
- Manually managing local file paths
- Editing multiple `go.mod` files for each change

With workspaces:
- Single `go.work` file manages all modules
- No need to modify individual `go.mod` files
- Clean separation between repository files and local development setup

### 2. Unified Dependency Resolution

- All modules in the workspace share a common dependency graph
- Minimal Version Selection (MVS) operates across all workspace modules
- Consistent dependency versions across all modules
- Easier to manage and resolve version conflicts

### 3. Clean Repository State

- `go.work` files are typically not committed to version control
- Individual `go.mod` files remain clean and publishable
- No temporary `replace` directives that might be accidentally committed
- Local development doesn't affect the module's published state

### 4. Improved Developer Experience

- Easier to navigate and work with related modules
- Better IDE support for multi-module projects
- Simplified build and test commands across modules
- Reduced cognitive overhead in managing dependencies

### 5. Flexible Module Organization

- Modules don't have to be in the same repository
- Can work with any combination of local and remote modules
- Supports both monorepo and multi-repo development patterns
- Easy to add or remove modules from workspace

## How to Configure Go Workspaces

### Basic Setup

1. **Create a workspace directory structure**:
```bash
mkdir my-workspace
cd my-workspace
mkdir module1 module2
```

2. **Initialize individual modules**:
```bash
cd module1
go mod init example.com/module1
# Add some code...

cd ../module2
go mod init example.com/module2
# Add some code...
```

3. **Initialize the workspace**:
```bash
cd .. # Back to workspace root
go work init ./module1 ./module2
```

### Environment Variables

- **GOWORK**: Controls workspace behavior
  - Empty: Search for `go.work` file in current and parent directories
  - `off`: Disable workspace mode
  - Path to file: Use specific `go.work` file

```bash
# Disable workspace mode
GOWORK=off go build .

# Use specific workspace file
GOWORK=/path/to/custom.work go build .
```

### Directory Structure Example

```
my-workspace/
├── go.work
├── go.work.sum
├── module1/
│   ├── go.mod
│   ├── go.sum
│   └── main.go
├── module2/
│   ├── go.mod
│   ├── go.sum
│   └── lib.go
└── external-module/
    ├── go.mod
    ├── go.sum
    └── utils.go
```

## go.work File Structure

The `go.work` file uses a syntax similar to `go.mod` files and contains several directives:

### Basic Structure

```go
go 1.23.0

use (
    ./module1
    ./module2
    ./external-module
)

replace example.com/old-module => ./local-fork
```

### Directives

#### `go` Directive
Specifies the minimum Go version required for the workspace:
```go
go 1.23.0
```

#### `toolchain` Directive
Declares a suggested Go toolchain to use:
```go
toolchain go1.21.0
```

#### `use` Directive
Adds modules to the workspace:
```go
use ./path/to/module

use (
    ./module1
    ./module2
    ../external/module3
)
```

#### `replace` Directive
Replaces module versions or paths (similar to `go.mod`):
```go
replace example.com/old-module => ./local-fork
replace example.com/module v1.2.3 => ./local-version
```

#### `godebug` Directive
Declares GODEBUG settings for the workspace:
```go
godebug default=go1.21
```

### go.work.sum File

Similar to `go.sum`, this file contains checksums for dependencies that are not in the collective workspace modules' `go.sum` files.

## Common Commands

### Workspace Management

#### Initialize a new workspace
```bash
go work init [module-directories...]
```

Examples:
```bash
# Initialize empty workspace
go work init

# Initialize with modules
go work init ./module1 ./module2

# Initialize with recursive search
go work init -r .
```

#### Add modules to workspace
```bash
go work use [module-directories...]
```

Examples:
```bash
# Add single module
go work use ./new-module

# Add multiple modules
go work use ./module1 ./module2

# Add modules recursively
go work use -r ./projects
```

#### Edit workspace file
```bash
go work edit [flags]
```

Common flags:
- `-fmt`: Format the go.work file
- `-use=path`: Add use directive
- `-dropuse=path`: Remove use directive
- `-replace=old=new`: Add replace directive
- `-dropreplace=old`: Remove replace directive

#### Synchronize workspace
```bash
go work sync
```

This command:
- Computes the workspace build list using MVS
- Updates each module's `go.mod` file with consistent versions
- Ensures all modules use compatible dependency versions

### Development Commands

All standard Go commands work within workspaces:

```bash
# Build all modules
go build ./...

# Test all modules
go test ./...

# Run specific module
go run ./module1

# List modules in workspace
go list -m all

# Get dependencies
go get example.com/dependency
```

## Practical Examples

### Example 1: Basic Multi-Module Project

```bash
# Create workspace structure
mkdir my-project
cd my-project

# Create modules
mkdir app lib
cd app
go mod init example.com/myproject/app
echo 'package main
import "fmt"
func main() { fmt.Println("Hello from app") }' > main.go

cd ../lib
go mod init example.com/myproject/lib
echo 'package lib
func Hello() string { return "Hello from lib" }' > lib.go

# Initialize workspace
cd ..
go work init ./app ./lib
```

### Example 2: Working with External Dependencies

```bash
# Clone external dependency
git clone https://github.com/some/dependency external-dep

# Add to workspace
go work use ./external-dep

# Now you can modify external-dep and see changes immediately
```

### Example 3: Monorepo Setup

```bash
# Typical monorepo structure
monorepo/
├── go.work
├── services/
│   ├── api/
│   │   ├── go.mod
│   │   └── main.go
│   └── worker/
│       ├── go.mod
│       └── main.go
├── libs/
│   ├── common/
│   │   ├── go.mod
│   │   └── utils.go
│   └── database/
│       ├── go.mod
│       └── db.go
└── tools/
    ├── generator/
    │   ├── go.mod
    │   └── main.go
    └── migrator/
        ├── go.mod
        └── main.go

# Initialize with all modules
go work init ./services/api ./services/worker ./libs/common ./libs/database ./tools/generator ./tools/migrator
```

### Example 4: Cross-Module Dependencies

```go
// In workspace go.work
go 1.23.0

use (
    ./app
    ./lib
)

// In app/go.mod
module example.com/myproject/app

require example.com/myproject/lib v0.0.0

// In app/main.go
package main

import (
    "fmt"
    "example.com/myproject/lib"
)

func main() {
    fmt.Println(lib.Hello())
}
```

## Best Practices

### 1. Workspace Organization

- Keep the `go.work` file at the root of your development workspace
- Use relative paths in `use` directives for portability
- Organize modules logically within the workspace directory

### 2. Version Control

- **Don't commit `go.work` files** to version control in most cases
- Add `go.work` and `go.work.sum` to `.gitignore`
- Each developer can have their own workspace setup
- Exception: Committed `go.work` files may be appropriate for exclusive module development

### 3. Module Independence

- Ensure each module can be built independently
- Don't rely on workspace-specific configurations in module code
- Regular testing outside the workspace context
- Modules should be publishable without workspace dependencies

### 4. Dependency Management

- Run `go work sync` regularly to keep dependencies consistent
- Use workspace-level `replace` directives for temporary local changes
- Avoid workspace-specific `replace` directives for production dependencies
- Test with and without the workspace to ensure compatibility

### 5. CI/CD Integration

- Build and test modules individually in CI/CD pipelines
- Don't rely on workspace setup in automated builds
- Consider separate pipelines for workspace-level integration tests
- Use matrix builds to test different module combinations

### 6. IDE Configuration

- Configure your IDE to recognize the workspace structure
- Set up proper Go module roots for each module
- Use workspace-aware debugging configurations
- Consider IDE-specific workspace files (e.g., VS Code workspace files)

## Migration from GOPATH

Workspaces provide some convenience for developers migrating from GOPATH:

### GOPATH Compatibility

- `GOPATH` users can place a `go.work` file at `$GOPATH`
- This provides some GOPATH-like convenience with module benefits
- Not a complete recreation of GOPATH workflows
- Still provides module dependency management

### Migration Steps

1. **Assess current GOPATH structure**:
   ```bash
   ls $GOPATH/src
   ```

2. **Identify related projects**:
   - Group related projects into workspace candidates
   - Identify dependencies between projects

3. **Create workspace structure**:
   ```bash
   mkdir ~/dev-workspace
   cd ~/dev-workspace
   ```

4. **Move and initialize modules**:
   ```bash
   # For each project
   cp -r $GOPATH/src/example.com/project ./project
   cd project
   go mod init example.com/project
   go mod tidy
   cd ..
   ```

5. **Initialize workspace**:
   ```bash
   go work init ./project1 ./project2
   ```

## Troubleshooting

### Common Issues

#### 1. Module Not Found

**Problem**: `go: module example.com/mymodule: not found`

**Solutions**:
- Ensure the module is added to `go.work` with `go work use ./path/to/module`
- Verify the module path in `go.mod` matches the import path
- Check that the module directory contains a valid `go.mod` file

#### 2. Version Conflicts

**Problem**: Different modules require incompatible versions

**Solutions**:
- Run `go work sync` to resolve version conflicts
- Use `replace` directives in `go.work` for temporary fixes
- Update modules to use compatible versions

#### 3. Build Failures

**Problem**: Code builds in workspace but fails outside

**Solutions**:
- Test modules individually: `cd module && go build`
- Check for workspace-specific dependencies
- Ensure all dependencies are properly declared in `go.mod`

#### 4. IDE Issues

**Problem**: IDE doesn't recognize workspace structure

**Solutions**:
- Restart IDE after workspace changes
- Check IDE Go plugin configuration
- Verify GOWORK environment variable
- Use IDE-specific workspace files

### Debugging Commands

```bash
# Check workspace status
go env GOWORK

# List all modules
go list -m all

# Show module graph
go mod graph

# Verify module integrity
go mod verify

# Show why a module is needed
go mod why example.com/module
```

### Performance Considerations

- Large workspaces may slow down some operations
- Consider splitting very large workspaces
- Use `-r` flag carefully with `go work use`
- Monitor build times and adjust workspace size accordingly

## Advanced Topics

### Custom Workspace Locations

```bash
# Use custom workspace file
GOWORK=/path/to/custom.work go build

# Workspace in different directory
cd /other/location
GOWORK=/workspace/go.work go build
```

### Workspace with Remote Modules

```bash
# Mix of local and remote modules
go work init ./local-module
go work use ./another-local-module

# Remote modules are still fetched normally
# Local modules take precedence via workspace
```

### Integration with Docker

```dockerfile
# Dockerfile for workspace development
FROM golang:1.23

WORKDIR /workspace
COPY go.work go.work.sum ./
COPY module1/ ./module1/
COPY module2/ ./module2/

RUN go work sync
RUN go build ./...
```

### Testing Strategies

```bash
# Test entire workspace
go test ./...

# Test specific module in workspace context
go test ./module1/...

# Test module independently
cd module1 && go test ./...
```

## Adding Dependencies to Specific Modules

### Method 1: Navigate to Module Directory (Recommended)

The most straightforward approach is to navigate to the specific module directory and use `go get`:

```bash
# Navigate to specific module
cd module1
go get github.com/gin-gonic/gin@v1.9.1

# Or add multiple dependencies
go get github.com/gin-gonic/gin github.com/gorilla/mux

# Go back to workspace root
cd ..
```

### Method 2: Use Module Path from Workspace Root

From the workspace root, you can specify the module path:

```bash
# From workspace root
go get -C ./module1 github.com/gin-gonic/gin

# Or using the module path
go get -C module1 github.com/gin-gonic/gin@latest
```

### Method 3: Using go work edit (Advanced)

You can use `go work edit` to add dependencies, but this requires more steps:

```bash
# Add dependency to specific module's go.mod
go work edit -require=github.com/gin-gonic/gin@v1.9.1 ./module1/go.mod

# Then run go mod tidy in that module
cd module1 && go mod tidy && cd ..
```

### Method 4: Direct go.mod Editing

You can manually edit the module's `go.mod` file:

```bash
# Edit module1/go.mod
vim module1/go.mod

# Add to require section:
require (
    github.com/gin-gonic/gin v1.9.1
    // other dependencies...
)

# Then tidy the module
cd module1 && go mod tidy && cd ..
```

### Practical Examples

#### Example 1: Adding Web Framework to API Module

```bash
# Workspace structure
myproject/
├── go.work
├── api/
│   ├── go.mod
│   └── main.go
├── worker/
│   ├── go.mod
│   └── main.go
└── common/
    ├── go.mod
    └── utils.go

# Add Gin to API module only
cd api
go get github.com/gin-gonic/gin@v1.9.1
go get github.com/gin-contrib/cors@v1.4.0

# Add database driver to both API and worker
cd ../worker
go get github.com/lib/pq@v1.10.9
cd ../api
go get github.com/lib/pq@v1.10.9

# Back to workspace root
cd ..
```

#### Example 2: Adding Development Tools

```bash
# Add testing tools to specific module
cd api
go get -t github.com/stretchr/testify@v1.8.4

# Add build tools (won't be included in binary)
go get -d github.com/golang/mock/mockgen@v1.6.0
```

#### Example 3: Adding Internal Dependencies

```bash
# In api/go.mod, add dependency on common module
cd api
go get example.com/myproject/common

# This will be resolved automatically by the workspace
# No need to publish common module
```

### Best Practices for Workspace Dependencies

#### 1. Module-Specific Dependencies

```bash
# Each module should declare its own dependencies
# API module might need:
cd api
go get github.com/gin-gonic/gin
go get github.com/golang-jwt/jwt

# Worker module might need:
cd ../worker  
go get github.com/robfig/cron
go get github.com/go-redis/redis

# Common module might need:
cd ../common
go get github.com/sirupsen/logrus
```

#### 2. Version Consistency

```bash
# After adding dependencies to multiple modules
go work sync  # This ensures consistent versions across workspace

# Check for version conflicts
go list -m all | grep "module-name"
```

#### 3. Workspace-Level Replace Directives

For temporary development dependencies:

```bash
# In go.work file
go work edit -replace=github.com/some/dependency=./local-fork

# This affects all modules in the workspace
```

#### 4. Testing Dependencies

```bash
# Add test dependencies to specific module
cd api
go get -t github.com/stretchr/testify/assert
go get -t github.com/golang/mock/gomock

# These are only used for testing
```

### Common Workflows

#### Adding a New External Library

```bash
# 1. Navigate to the module that needs the dependency
cd module1

# 2. Add the dependency
go get github.com/new/library@v1.2.3

# 3. Use it in your code
echo 'import "github.com/new/library"' >> main.go

# 4. Return to workspace root
cd ..

# 5. Sync workspace (optional, but recommended)
go work sync
```

#### Adding Cross-Module Dependencies

```bash
# If module1 needs to use module2
cd module1

# Add dependency (module2 is in the same workspace)
go get example.com/myproject/module2

# The workspace will resolve this locally
# No need to publish module2
```

#### Upgrading Dependencies

```bash
# Upgrade specific dependency in specific module
cd module1
go get github.com/some/library@latest

# Or upgrade all dependencies in a module
go get -u ./...

# Return to workspace root and sync
cd ..
go work sync
```

### Troubleshooting Dependency Issues

#### Check Module Dependencies

```bash
# List dependencies for specific module
cd module1
go list -m all

# Check why a dependency is needed
go mod why github.com/some/dependency

# Verify module integrity
go mod verify
```

#### Resolve Version Conflicts

```bash
# If you have version conflicts across modules
go work sync

# Check the unified dependency graph
go list -m all

# Use replace directive if needed
go work edit -replace=github.com/conflicting/lib@v1.0.0=github.com/conflicting/lib@v1.1.0
```

#### Clean Up Dependencies

```bash
# Remove unused dependencies from specific module
cd module1
go mod tidy

# This removes unused dependencies from module1's go.mod
```

### Key Points to Remember

1. **Each module maintains its own `go.mod`** - Dependencies are module-specific
2. **Use `go work sync`** after adding dependencies to ensure consistency
3. **Navigate to the module directory** - This is the most reliable method
4. **Workspace resolves local modules** - Internal dependencies are resolved automatically
5. **Test independently** - Ensure each module can build without the workspace

This approach gives you fine-grained control over dependencies while benefiting from workspace-level dependency resolution and version management.

This comprehensive guide covers the essential aspects of Go workspaces, from basic concepts to advanced usage patterns. Workspaces are a powerful feature that significantly improves the multi-module development experience in Go.