# Go: Struct Methods vs Dedicated Functions

## Quick Decision Guide

**Use a Method when:**
- Logic belongs to the type's abstraction
- Need to satisfy an interface
- Accessing or modifying internal state
- Building fluent/chainable APIs

**Use a Function when:**
- Generic utility logic
- Operating on multiple unrelated types
- Constructor pattern
- Pure/stateless operations

---

## 1. Use Methods for Type Behavior

**When:** The operation is a natural behavior of the type.

```go
// ✅ GOOD: Natural behavior as method
type User struct {
    FirstName string
    LastName  string
}

func (u *User) FullName() string {
    return u.FirstName + " " + u.LastName
}
```

```go
// ❌ BAD: Awkward as function
func GetUserFullName(firstName, lastName string) string {
    return firstName + " " + lastName
}
```

---

## 2. Use Methods for Interface Satisfaction

**When:** Type needs to implement an interface.

```go
// ✅ GOOD: Method implements io.Writer
type Logger struct {
    prefix string
}

func (l *Logger) Write(p []byte) (n int, err error) {
    log.Printf("%s: %s", l.prefix, string(p))
    return len(p), nil
}
```

```go
// ❌ BAD: Function can't satisfy interface
func LoggerWrite(prefix string, p []byte) (int, error) {
    log.Printf("%s: %s", prefix, string(p))
    return len(p), nil
}
// Can't use this where io.Writer is expected
```

---

## 3. Use Methods for State Access/Modification

**When:** Operation needs private fields or modifies state.

```go
// ✅ GOOD: Method accesses/modifies state
type BankAccount struct {
    balance float64
    locked  bool
}

func (ba *BankAccount) Deposit(amount float64) error {
    if ba.locked {
        return errors.New("account locked")
    }
    ba.balance += amount
    return nil
}
```

```go
// ❌ BAD: Can't access private fields
type BankAccount struct {
    balance float64 // private
}

func Deposit(account BankAccount, amount float64) error {
    // Can't access account.balance!
    return nil
}
```

---

## 4. Use Functions for Generic Utilities

**When:** Logic applies to multiple types or is general-purpose.

```go
// ✅ GOOD: Generic utility function
func Max(a, b int) int {
    if a > b {
        return a
    }
    return b
}

func Contains(slice []string, item string) bool {
    for _, s := range slice {
        if s == item {
            return true
        }
    }
    return false
}
```

```go
// ❌ BAD: Artificial type for utility
type IntUtils struct{}

func (iu IntUtils) Max(a, b int) int {
    if a > b {
        return a
    }
    return b
}
```

---

## 5. Use Functions for Multi-Type Operations

**When:** Logic coordinates between unrelated types.

```go
// ✅ GOOD: Function operates on multiple types
type User struct {
    ID   int
    Name string
}

type Post struct {
    AuthorID int
    Content  string
}

func CanUserEditPost(user *User, post *Post) bool {
    return user.ID == post.AuthorID
}
```

```go
// ❌ BAD: Unclear which type should own this
func (u *User) CanEditPost(post *Post) bool {
    return u.ID == post.AuthorID
}
// Why is this on User? Could be on Post too. Confusing.
```

---

## 6. Use Functions for Constructors

**When:** Creating and initializing instances.

```go
// ✅ GOOD: Constructor function
type Server struct {
    port int
    handler http.Handler
}

func NewServer(port int, handler http.Handler) (*Server, error) {
    if port <= 0 {
        return nil, errors.New("invalid port")
    }
    return &Server{port: port, handler: handler}, nil
}
```

```go
// ❌ BAD: Can't have "constructor" as method
// Methods require an instance to already exist!
```

---

## 7. Use Methods for Fluent APIs

**When:** Building chainable interfaces.

```go
// ✅ GOOD: Method chaining
type QueryBuilder struct {
    query strings.Builder
}

func (qb *QueryBuilder) Select(fields ...string) *QueryBuilder {
    qb.query.WriteString("SELECT " + strings.Join(fields, ", "))
    return qb
}

func (qb *QueryBuilder) From(table string) *QueryBuilder {
    qb.query.WriteString(" FROM " + table)
    return qb
}

// Usage: NewQueryBuilder().Select("id", "name").From("users")
```

```go
// ❌ BAD: Can't chain functions naturally
func Select(qb *QueryBuilder, fields ...string) *QueryBuilder {
    // ...
}

func From(qb *QueryBuilder, table string) *QueryBuilder {
    // ...
}

// Usage: From(Select(qb, "id", "name"), "users") - awkward!
```

---

## 8. Use Functions for Pure/Stateless Logic

**When:** No state or side effects involved.

```go
// ✅ GOOD: Pure function
func CalculateDiscount(price, percentage float64) float64 {
    return price * (percentage / 100.0)
}

func FormatCurrency(amount float64) string {
    return fmt.Sprintf("$%.2f", amount)
}
```

```go
// ❌ BAD: Unnecessary wrapper
type PriceCalculator struct{}

func (pc PriceCalculator) CalculateDiscount(price, percentage float64) float64 {
    return price * (percentage / 100.0)
}
// Doesn't use any state, why is it a method?
```

---

## Pointer vs Value Receivers

**Use Pointer Receiver (\*T) when:**
- Method modifies the receiver
- Type is large (avoid copying)
- Type contains sync primitives
- For consistency with other pointer methods

**Use Value Receiver (T) when:**
- Type is small and cheap to copy
- Method is read-only
- Type is immutable by design

```go
// ✅ Pointer: Modifies state
func (c *Counter) Increment() {
    c.count++
}

// ✅ Value: Small, read-only
func (p Point) Distance() float64 {
    return math.Sqrt(float64(p.X*p.X + p.Y*p.Y))
}
```

---

## Common Pitfalls

### 1. Method Doesn't Use Receiver
```go
// ❌ BAD
func (m *MathUtils) Add(a, b int) int {
    return a + b // Doesn't use m!
}

// ✅ GOOD
func Add(a, b int) int {
    return a + b
}
```

### 2. Forgetting Pointer for Mutations
```go
// ❌ BAD - Modifies copy
func (c Counter) Increment() {
    c.count++
}

// ✅ GOOD
func (c *Counter) Increment() {
    c.count++
}
```

### 3. Too Many Parameters → Should Be Method
```go
// ❌ BAD
func UpdateUser(db *sql.DB, id int, name, email string, active bool) error

// ✅ GOOD
type User struct {
    ID     int
    Name   string
    Email  string
    Active bool
}

func (u *User) Update(db *sql.DB) error
```

---

## Decision Checklist

- [ ] Implements interface? → **Method**
- [ ] Accesses private fields? → **Method**
- [ ] Natural behavior of type? → **Method**
- [ ] Works with multiple types? → **Function**
- [ ] Generic utility? → **Function**
- [ ] Constructor? → **Function** (`NewX` pattern)
- [ ] Pure/stateless? → **Function**

**Default:** When in doubt, use a **function**. It's easier to convert function → method later than vice versa.

---

## References

- [Effective Go - Methods](https://go.dev/doc/effective_go#methods)
- [Go FAQ - Pointers vs Values](https://go.dev/doc/faq#methods_on_values_or_pointers)
