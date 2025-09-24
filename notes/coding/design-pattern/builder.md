# Builder Design Pattern in Go

The **Builder Pattern** is a creational design pattern that constructs complex objects step by step, separating the construction process from the object's representation. This pattern is particularly useful in Go when dealing with objects that have many optional parameters or require complex initialization logic.

## 📋 Table of Contents

- [Overview](#overview)
- [When to Use](#when-to-use)
- [Basic Implementation](#basic-implementation)
- [Interface-Based Builder](#interface-based-builder)
- [Fluent Builder with Validation](#fluent-builder-with-validation)
- [Builder with Director](#builder-with-director)
- [Comparison with Functional Options](#comparison-with-functional-options)
- [Best Practices](#best-practices)
- [Common Pitfalls](#common-pitfalls)

## Overview

The Builder pattern allows you to create complex objects with:

- **Step-by-step construction**: Build objects incrementally
- **Method chaining**: Fluent interface for better readability
- **Validation**: Ensure object consistency before construction
- **Flexibility**: Support different representations of the same object

### Key Components

1. **Product**: The complex object being built
2. **Builder**: Interface or struct that constructs the product
3. **Concrete Builder**: Implements the building steps
4. **Director** (optional): Controls the building process

## When to Use

Use the Builder pattern when:

- ✅ Objects have **many optional parameters** (5+ fields)
- ✅ Object construction is **complex** or requires **validation**
- ✅ You need **different representations** of the same object
- ✅ You want to ensure **object immutability** after creation
- ✅ **Constructor telescoping** becomes unwieldy

Avoid when:

- ❌ Objects are **simple** with **few fields**
- ❌ **All fields are required**
- ❌ Object state **changes frequently** after creation

## Basic Implementation

### Simple User Builder

```go
package main

import (
    "fmt"
    "strings"
)

// User represents the complex product we want to build
type User struct {
    Name        string
    Email       string
    Age         int
    Permissions []string
    IsActive    bool
}

// UserBuilder is the concrete builder
type UserBuilder struct {
    user User
}

// NewUserBuilder creates a new UserBuilder with mandatory fields
func NewUserBuilder(name, email string) *UserBuilder {
    return &UserBuilder{
        user: User{
            Name:        name,
            Email:       email,
            Permissions: []string{}, // Initialize slice
            IsActive:    true,       // Default value
        },
    }
}

// WithAge sets the user's age (fluent interface)
func (ub *UserBuilder) WithAge(age int) *UserBuilder {
    ub.user.Age = age
    return ub
}

// AddPermission adds a permission to the user
func (ub *UserBuilder) AddPermission(permission string) *UserBuilder {
    ub.user.Permissions = append(ub.user.Permissions, permission)
    return ub
}

// SetInactive sets the user's active status to false
func (ub *UserBuilder) SetInactive() *UserBuilder {
    ub.user.IsActive = false
    return ub
}

// Build finalizes construction and returns the User object
func (ub *UserBuilder) Build() (*User, error) {
    // Validation logic before returning the user
    if ub.user.Age < 0 {
        return nil, fmt.Errorf("age cannot be negative")
    }
    if len(strings.TrimSpace(ub.user.Name)) == 0 {
        return nil, fmt.Errorf("name cannot be empty")
    }

    // Return a copy to prevent modification
    userCopy := ub.user
    userCopy.Permissions = append([]string(nil), ub.user.Permissions...)

    return &userCopy, nil
}

func main() {
    // Build an admin user with method chaining
    adminUser, err := NewUserBuilder("Alice", "alice@example.com").
        WithAge(30).
        AddPermission("admin").
        AddPermission("read").
        AddPermission("write").
        Build()

    if err != nil {
        fmt.Printf("Error building admin user: %v\n", err)
        return
    }
    fmt.Printf("Admin User: %+v\n", *adminUser)

    // Build a guest user
    guestUser, err := NewUserBuilder("Bob", "bob@example.com").
        WithAge(25).
        SetInactive().
        Build()

    if err != nil {
        fmt.Printf("Error building guest user: %v\n", err)
        return
    }
    fmt.Printf("Guest User: %+v\n", *guestUser)

    // Build with only mandatory fields
    basicUser, err := NewUserBuilder("Charlie", "charlie@example.com").Build()
    if err != nil {
        fmt.Printf("Error building basic user: %v\n", err)
        return
    }
    fmt.Printf("Basic User: %+v\n", *basicUser)
}
```

**Output:**

```
Admin User: {Name:Alice Email:alice@example.com Age:30 Permissions:[admin read write] IsActive:true}
Guest User: {Name:Bob Email:bob@example.com Age:25 Permissions:[] IsActive:false}
Basic User: {Name:Charlie Email:charlie@example.com Age:0 Permissions:[] IsActive:true}
```

## Interface-Based Builder

For more flexibility and testability, use interface-based builders:

```go
package main

import (
    "fmt"
    "errors"
)

// Car represents the product being built
type Car struct {
    color        string
    engineType   string
    hasSunroof   bool
    hasNavigation bool
}

// GetDescription returns a description of the car
func (c *Car) GetDescription() string {
    return fmt.Sprintf("Car: %s %s, Sunroof: %t, Navigation: %t",
        c.color, c.engineType, c.hasSunroof, c.hasNavigation)
}

// CarBuilder interface defines the building contract
type CarBuilder interface {
    SetColor(color string) CarBuilder
    SetEngineType(engineType string) CarBuilder
    SetSunroof(hasSunroof bool) CarBuilder
    SetNavigation(hasNavigation bool) CarBuilder
    Build() (*Car, error)
}

// carBuilder implements the CarBuilder interface
type carBuilder struct {
    car *Car
}

// NewCarBuilder creates a new CarBuilder instance
func NewCarBuilder() CarBuilder {
    return &carBuilder{
        car: &Car{
            color:        "white", // default color
            engineType:   "petrol", // default engine
        },
    }
}

func (cb *carBuilder) SetColor(color string) CarBuilder {
    cb.car.color = color
    return cb
}

func (cb *carBuilder) SetEngineType(engineType string) CarBuilder {
    cb.car.engineType = engineType
    return cb
}

func (cb *carBuilder) SetSunroof(hasSunroof bool) CarBuilder {
    cb.car.hasSunroof = hasSunroof
    return cb
}

func (cb *carBuilder) SetNavigation(hasNavigation bool) CarBuilder {
    cb.car.hasNavigation = hasNavigation
    return cb
}

func (cb *carBuilder) Build() (*Car, error) {
    // Validation
    if cb.car.color == "" {
        return nil, errors.New("color cannot be empty")
    }
    if cb.car.engineType == "" {
        return nil, errors.New("engine type cannot be empty")
    }

    // Return a copy to prevent external modification
    carCopy := &Car{
        color:        cb.car.color,
        engineType:   cb.car.engineType,
        hasSunroof:   cb.car.hasSunroof,
        hasNavigation: cb.car.hasNavigation,
    }

    return carCopy, nil
}

func main() {
    // Build a luxury car
    luxuryCar, err := NewCarBuilder().
        SetColor("black").
        SetEngineType("hybrid").
        SetSunroof(true).
        SetNavigation(true).
        Build()

    if err != nil {
        fmt.Printf("Error: %v\n", err)
        return
    }

    fmt.Println(luxuryCar.GetDescription())

    // Build a basic car
    basicCar, err := NewCarBuilder().
        SetColor("blue").
        Build()

    if err != nil {
        fmt.Printf("Error: %v\n", err)
        return
    }

    fmt.Println(basicCar.GetDescription())
}
```

**Output:**

```
Car: black hybrid, Sunroof: true, Navigation: true
Car: blue petrol, Sunroof: false, Navigation: false
```

## Fluent Builder with Validation

Advanced builder with comprehensive validation and error handling:

```go
package main

import (
    "fmt"
    "net/url"
    "regexp"
    "strings"
    "time"
)

// DatabaseConfig represents a complex database configuration
type DatabaseConfig struct {
    Host            string
    Port            int
    Database        string
    Username        string
    Password        string
    MaxConnections  int
    ConnectionTimeout time.Duration
    SSLEnabled      bool
    BackupEnabled   bool
    BackupSchedule  string
}

// DatabaseConfigBuilder builds DatabaseConfig instances
type DatabaseConfigBuilder struct {
    config DatabaseConfig
    errors []error
}

// NewDatabaseConfigBuilder creates a new builder with defaults
func NewDatabaseConfigBuilder() *DatabaseConfigBuilder {
    return &DatabaseConfigBuilder{
        config: DatabaseConfig{
            Port:              5432,
            MaxConnections:    10,
            ConnectionTimeout: 30 * time.Second,
            SSLEnabled:        true,
            BackupEnabled:     false,
        },
        errors: []error{},
    }
}

// WithHost sets the database host
func (b *DatabaseConfigBuilder) WithHost(host string) *DatabaseConfigBuilder {
    if strings.TrimSpace(host) == "" {
        b.errors = append(b.errors, fmt.Errorf("host cannot be empty"))
        return b
    }

    // Validate host format
    if _, err := url.Parse("http://" + host); err != nil {
        b.errors = append(b.errors, fmt.Errorf("invalid host format: %s", host))
        return b
    }

    b.config.Host = host
    return b
}

// WithPort sets the database port
func (b *DatabaseConfigBuilder) WithPort(port int) *DatabaseConfigBuilder {
    if port <= 0 || port > 65535 {
        b.errors = append(b.errors, fmt.Errorf("port must be between 1 and 65535, got: %d", port))
        return b
    }

    b.config.Port = port
    return b
}

// WithDatabase sets the database name
func (b *DatabaseConfigBuilder) WithDatabase(database string) *DatabaseConfigBuilder {
    if strings.TrimSpace(database) == "" {
        b.errors = append(b.errors, fmt.Errorf("database name cannot be empty"))
        return b
    }

    // Validate database name (alphanumeric and underscores only)
    if matched, _ := regexp.MatchString(`^[a-zA-Z0-9_]+$`, database); !matched {
        b.errors = append(b.errors, fmt.Errorf("database name can only contain letters, numbers, and underscores: %s", database))
        return b
    }

    b.config.Database = database
    return b
}

// WithCredentials sets username and password
func (b *DatabaseConfigBuilder) WithCredentials(username, password string) *DatabaseConfigBuilder {
    if strings.TrimSpace(username) == "" {
        b.errors = append(b.errors, fmt.Errorf("username cannot be empty"))
    } else {
        b.config.Username = username
    }

    if len(password) < 8 {
        b.errors = append(b.errors, fmt.Errorf("password must be at least 8 characters long"))
    } else {
        b.config.Password = password
    }

    return b
}

// WithConnectionPool sets connection pool configuration
func (b *DatabaseConfigBuilder) WithConnectionPool(maxConnections int, timeout time.Duration) *DatabaseConfigBuilder {
    if maxConnections <= 0 {
        b.errors = append(b.errors, fmt.Errorf("max connections must be positive, got: %d", maxConnections))
    } else {
        b.config.MaxConnections = maxConnections
    }

    if timeout <= 0 {
        b.errors = append(b.errors, fmt.Errorf("connection timeout must be positive, got: %v", timeout))
    } else {
        b.config.ConnectionTimeout = timeout
    }

    return b
}

// WithSSL enables or disables SSL
func (b *DatabaseConfigBuilder) WithSSL(enabled bool) *DatabaseConfigBuilder {
    b.config.SSLEnabled = enabled
    return b
}

// WithBackup configures backup settings
func (b *DatabaseConfigBuilder) WithBackup(enabled bool, schedule string) *DatabaseConfigBuilder {
    b.config.BackupEnabled = enabled

    if enabled && strings.TrimSpace(schedule) == "" {
        b.errors = append(b.errors, fmt.Errorf("backup schedule cannot be empty when backup is enabled"))
    } else if enabled {
        // Basic cron validation (simplified)
        parts := strings.Fields(schedule)
        if len(parts) != 5 {
            b.errors = append(b.errors, fmt.Errorf("invalid cron schedule format: %s", schedule))
        } else {
            b.config.BackupSchedule = schedule
        }
    }

    return b
}

// Build creates the final DatabaseConfig
func (b *DatabaseConfigBuilder) Build() (*DatabaseConfig, error) {
    // Check for accumulated errors
    if len(b.errors) > 0 {
        return nil, fmt.Errorf("validation errors: %v", b.errors)
    }

    // Final validation - required fields
    if b.config.Host == "" {
        return nil, fmt.Errorf("host is required")
    }
    if b.config.Database == "" {
        return nil, fmt.Errorf("database name is required")
    }
    if b.config.Username == "" {
        return nil, fmt.Errorf("username is required")
    }
    if b.config.Password == "" {
        return nil, fmt.Errorf("password is required")
    }

    // Return a copy to prevent modification
    configCopy := b.config
    return &configCopy, nil
}

func main() {
    // Build a valid database configuration
    config, err := NewDatabaseConfigBuilder().
        WithHost("localhost").
        WithPort(5432).
        WithDatabase("myapp_production").
        WithCredentials("admin", "secure_password123").
        WithConnectionPool(50, 60*time.Second).
        WithSSL(true).
        WithBackup(true, "0 2 * * *"). // Daily at 2 AM
        Build()

    if err != nil {
        fmt.Printf("Error building config: %v\n", err)
        return
    }

    fmt.Printf("Database Config: %+v\n", *config)

    // Example of validation errors
    fmt.Println("\n--- Validation Error Example ---")
    invalidConfig, err := NewDatabaseConfigBuilder().
        WithHost("").                     // Empty host
        WithPort(-1).                     // Invalid port
        WithDatabase("invalid-db-name").  // Invalid characters
        WithCredentials("user", "123").   // Password too short
        WithBackup(true, "invalid cron"). // Invalid cron
        Build()

    if err != nil {
        fmt.Printf("Expected validation error: %v\n", err)
    } else {
        fmt.Printf("Unexpected success: %+v\n", *invalidConfig)
    }
}
```

## Builder with Director

The Director pattern orchestrates the building process:

```go
package main

import (
    "fmt"
)

// House represents the complex product
type House struct {
    Rooms       int
    HasGarage   bool
    HasGarden   bool
    HasPool     bool
    Description string
}

// HouseBuilder interface defines the building contract
type HouseBuilder interface {
    SetRooms(rooms int) HouseBuilder
    AddGarage() HouseBuilder
    AddGarden() HouseBuilder
    AddPool() HouseBuilder
    SetDescription(desc string) HouseBuilder
    Build() *House
}

// normalHouseBuilder builds regular houses
type normalHouseBuilder struct {
    house House
}

func NewNormalHouseBuilder() HouseBuilder {
    return &normalHouseBuilder{
        house: House{
            Rooms: 1, // Default
        },
    }
}

func (b *normalHouseBuilder) SetRooms(rooms int) HouseBuilder {
    b.house.Rooms = rooms
    return b
}

func (b *normalHouseBuilder) AddGarage() HouseBuilder {
    b.house.HasGarage = true
    return b
}

func (b *normalHouseBuilder) AddGarden() HouseBuilder {
    b.house.HasGarden = true
    return b
}

func (b *normalHouseBuilder) AddPool() HouseBuilder {
    b.house.HasPool = true
    return b
}

func (b *normalHouseBuilder) SetDescription(desc string) HouseBuilder {
    b.house.Description = desc
    return b
}

func (b *normalHouseBuilder) Build() *House {
    houseCopy := b.house
    return &houseCopy
}

// luxuryHouseBuilder builds luxury houses with enhanced features
type luxuryHouseBuilder struct {
    house House
}

func NewLuxuryHouseBuilder() HouseBuilder {
    return &luxuryHouseBuilder{
        house: House{
            Rooms: 3, // Luxury houses start with more rooms
        },
    }
}

func (b *luxuryHouseBuilder) SetRooms(rooms int) HouseBuilder {
    // Luxury houses have minimum 3 rooms
    if rooms < 3 {
        rooms = 3
    }
    b.house.Rooms = rooms
    return b
}

func (b *luxuryHouseBuilder) AddGarage() HouseBuilder {
    b.house.HasGarage = true
    return b
}

func (b *luxuryHouseBuilder) AddGarden() HouseBuilder {
    b.house.HasGarden = true
    return b
}

func (b *luxuryHouseBuilder) AddPool() HouseBuilder {
    b.house.HasPool = true
    return b
}

func (b *luxuryHouseBuilder) SetDescription(desc string) HouseBuilder {
    b.house.Description = "Luxury " + desc
    return b
}

func (b *luxuryHouseBuilder) Build() *House {
    houseCopy := b.house
    return &houseCopy
}

// HouseDirector orchestrates the building process
type HouseDirector struct {
    builder HouseBuilder
}

func NewHouseDirector(builder HouseBuilder) *HouseDirector {
    return &HouseDirector{builder: builder}
}

// BuildStandardHouse creates a standard house configuration
func (d *HouseDirector) BuildStandardHouse() *House {
    return d.builder.
        SetRooms(3).
        AddGarage().
        SetDescription("Standard Family Home").
        Build()
}

// BuildLuxuryHouse creates a luxury house configuration
func (d *HouseDirector) BuildLuxuryHouse() *House {
    return d.builder.
        SetRooms(5).
        AddGarage().
        AddGarden().
        AddPool().
        SetDescription("Luxury Estate").
        Build()
}

// BuildBasicHouse creates a minimal house configuration
func (d *HouseDirector) BuildBasicHouse() *House {
    return d.builder.
        SetRooms(2).
        SetDescription("Starter Home").
        Build()
}

func main() {
    fmt.Println("=== Building with Normal Builder ===")

    // Use director with normal builder
    normalBuilder := NewNormalHouseBuilder()
    director := NewHouseDirector(normalBuilder)

    standardHouse := director.BuildStandardHouse()
    fmt.Printf("Standard House: %+v\n", *standardHouse)

    // Build luxury house with normal builder
    normalBuilder = NewNormalHouseBuilder() // Reset builder
    director = NewHouseDirector(normalBuilder)
    luxuryHouse := director.BuildLuxuryHouse()
    fmt.Printf("Luxury House (Normal Builder): %+v\n", *luxuryHouse)

    fmt.Println("\n=== Building with Luxury Builder ===")

    // Use director with luxury builder
    luxuryBuilder := NewLuxuryHouseBuilder()
    director = NewHouseDirector(luxuryBuilder)

    luxuryHouseBuilt := director.BuildLuxuryHouse()
    fmt.Printf("Luxury House (Luxury Builder): %+v\n", *luxuryHouseBuilt)

    // Build basic house with luxury builder
    luxuryBuilder = NewLuxuryHouseBuilder() // Reset builder
    director = NewHouseDirector(luxuryBuilder)
    basicHouseLuxury := director.BuildBasicHouse()
    fmt.Printf("Basic House (Luxury Builder): %+v\n", *basicHouseLuxury)
}
```

## Comparison with Functional Options

Go also supports the Functional Options pattern, which is sometimes preferred:

```go
// Functional Options Pattern
type ServerOptions struct {
    Port    int
    Timeout time.Duration
    SSL     bool
}

type ServerOption func(*ServerOptions)

func WithPort(port int) ServerOption {
    return func(opts *ServerOptions) {
        opts.Port = port
    }
}

func WithTimeout(timeout time.Duration) ServerOption {
    return func(opts *ServerOptions) {
        opts.Timeout = timeout
    }
}

func WithSSL(ssl bool) ServerOption {
    return func(opts *ServerOptions) {
        opts.SSL = ssl
    }
}

func NewServer(host string, options ...ServerOption) *Server {
    opts := &ServerOptions{
        Port:    8080,
        Timeout: 30 * time.Second,
        SSL:     false,
    }

    for _, option := range options {
        option(opts)
    }

    return &Server{
        Host:    host,
        Port:    opts.Port,
        Timeout: opts.Timeout,
        SSL:     opts.SSL,
    }
}

// Usage
server := NewServer("localhost",
    WithPort(9000),
    WithTimeout(60*time.Second),
    WithSSL(true),
)
```

**When to choose Builder vs Functional Options:**

| Builder Pattern                  | Functional Options          |
| -------------------------------- | --------------------------- |
| Complex object construction      | Simple configuration        |
| Multiple validation steps        | Minimal validation          |
| Stateful building process        | Stateless configuration     |
| Different object representations | Single object type          |
| Method chaining preference       | Functional style preference |

## Best Practices

### 1. **Immutable Products**

```go
// Good: Return copies to prevent external modification
func (b *UserBuilder) Build() (*User, error) {
    userCopy := b.user
    userCopy.Permissions = append([]string(nil), b.user.Permissions...)
    return &userCopy, nil
}
```

### 2. **Validation in Build()**

```go
func (b *ConfigBuilder) Build() (*Config, error) {
    if b.config.Host == "" {
        return nil, fmt.Errorf("host is required")
    }
    // More validations...
    return &b.config, nil
}
```

### 3. **Reset Capability**

```go
// Reset allows reusing the same builder
func (b *UserBuilder) Reset() *UserBuilder {
    b.user = User{}
    return b
}
```

### 4. **Builder Interface for Flexibility**

```go
type UserBuilder interface {
    WithName(name string) UserBuilder
    WithEmail(email string) UserBuilder
    Build() (*User, error)
}
```

### 5. **Pointer Receivers for Fluent Interface**

```go
// Good: Use pointer receiver to modify builder state
func (b *UserBuilder) WithName(name string) *UserBuilder {
    b.user.Name = name
    return b
}
```

## Common Pitfalls

### 1. **Forgetting to Handle Errors**

```go
// Bad: Ignoring build errors
user := NewUserBuilder("", "").Build() // This should fail!

// Good: Handle errors properly
user, err := NewUserBuilder("", "").Build()
if err != nil {
    log.Fatalf("Failed to build user: %v", err)
}
```

### 2. **Mutable Product After Build**

```go
// Bad: Returning pointer to internal state
func (b *UserBuilder) Build() *User {
    return &b.user // External code can modify this!
}

// Good: Return a copy
func (b *UserBuilder) Build() *User {
    userCopy := b.user
    return &userCopy
}
```

### 3. **No Default Values**

```go
// Good: Provide sensible defaults
func NewServerBuilder() *ServerBuilder {
    return &ServerBuilder{
        server: Server{
            Port:    8080,    // Sensible default
            Timeout: 30 * time.Second,
            SSL:     true,    // Secure by default
        },
    }
}
```

### 4. **Missing Reset Between Builds**

```go
// Bad: Reusing builder without reset
builder := NewUserBuilder()
user1 := builder.WithName("Alice").Build()
user2 := builder.WithName("Bob").Build() // user2 might have Alice's data!

// Good: Reset or create new builder
builder.Reset().WithName("Bob").Build()
// or
NewUserBuilder().WithName("Bob").Build()
```

---

## Summary

The Builder pattern in Go provides a clean, flexible way to construct complex objects step by step. It's particularly valuable when:

- Objects have many optional parameters
- Construction requires validation
- You need fluent, readable APIs
- Object immutability is important

Choose the right approach based on your needs:

- **Simple Builder**: For basic construction with validation
- **Interface-based Builder**: For flexibility and testing
- **Builder with Director**: For standardized construction processes
- **Functional Options**: For simple configuration scenarios

The pattern promotes code readability, maintainability, and type safety while providing a pleasant API for object construction.

