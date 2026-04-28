# Using Aliases to Move Resources to a Parent

When moving a resource from having no parent to being owned by a parent component, use `pulumi.Alias` with `NoParent: pulumi.Bool(true)` to maintain state continuity and avoid resource replacement.

## Problem

If you refactor code to move a resource into a component resource (parent), Pulumi sees the resource's URN has changed due to the new parent. Without aliasing, this causes the old resource to be deleted and a new one created, losing all data.

## Solution

Add an alias that matches the resource's previous URN when it had no parent:

```go
import "github.com/pulumi/pulumi/sdk/v3/go/pulumi"

// When moving an existing resource into a parent
db, err := rds.NewInstance(ctx, "app-db", &rds.InstanceArgs{
    // ... config
}, pulumi.Parent(comp), pulumi.Aliases([]pulumi.Alias{
    {NoParent: pulumi.Bool(true)},
}))
```

## How It Works

- `NoParent: true` tells Pulumi to look for a resource with the same name and type but **no parent** during import
- Pulumi will find the existing resource and adopt it under the new parent
- The state is preserved; no replacement occurs

## Example: Refactoring into a Component

**Before** (standalone resource):
```go
db, err := rds.NewInstance(ctx, "postgres-db", &rds.InstanceArgs{
    Engine:        pulumi.String("postgres"),
    AllocatedStorage: pulumi.Int(100),
    // ...
})
```

**After** (moved into a component):
```go
db, err := rds.NewInstance(ctx, "postgres-db", &rds.InstanceArgs{
    Engine:        pulumi.String("postgres"),
    AllocatedStorage: pulumi.Int(100),
    // ...
}, pulumi.Parent(comp), pulumi.Aliases([]pulumi.Alias{
    {NoParent: pulumi.Bool(true)},
}))
```

When you run `pulumi up`, the existing resource is imported into the component hierarchy without recreation.

## Key Takeaway

Use `Alias{NoParent: pulumi.Bool(true)}` whenever moving a standalone resource into a parent to maintain state and avoid unintended resource replacement.
