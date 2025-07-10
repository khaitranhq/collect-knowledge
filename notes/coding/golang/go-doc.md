# Go Doc Comments - Quick Reference

Doc comments are comments that appear immediately before top-level package, const, func, type, and var declarations. Every exported (capitalized) name should have a doc comment.

## Key Principles

- **Complete sentences**: Start with the declared symbol name
- **Present tense**: Describe what the code does, not how it works
- **Concise**: Focus on what callers need to know
- **Consistent**: Use the same receiver name for methods

## Package Comments

Every package should have a package comment introducing it:

```go
// Package path implements utility routines for manipulating slash-separated paths.
//
// The path package should only be used for paths separated by forward
// slashes, such as the paths in URLs. This package does not deal with
// Windows paths with drive letters or backslashes; to manipulate
// operating system paths, use the [path/filepath] package.
package path
```

**Rules:**

- Start with "Package name"
- Use `[package/name]` for documentation links
- Place in only one source file for multi-file packages

## Types

Explain what each instance represents:

```go
// A Reader serves content from a ZIP archive.
type Reader struct { ... }

// A Buffer is a variable-sized buffer of bytes with Read and Write methods.
// The zero value for Buffer is an empty buffer ready to use.
type Buffer struct { ... }
```

**Concurrency:** State if safe for concurrent use, otherwise assume single-goroutine use.

## Functions and Methods

Explain what the function returns or does:

```go
// Quote returns a double-quoted Go string literal representing s.
func Quote(s string) string { ... }

// Exit causes the current program to exit with the given status code.
// Conventionally, code zero indicates success, non-zero an error.
func Exit(code int) { ... }

// HasPrefix reports whether the string s begins with prefix.
func HasPrefix(s, prefix string) bool { ... }
```

**Tips:**

- Use "reports whether" for boolean returns
- Name results when explaining multiple return values
- Document special cases when important

## Constants and Variables

Group related items with a single comment:

```go
// The result of Scan is one of these tokens or a Unicode character.
const (
    EOF = -(iota + 1)
    Ident
    Int
    Float
)

// Generic file system errors.
var (
    ErrInvalid    = errInvalid()    // "invalid argument"
    ErrPermission = errPermission() // "permission denied"
    ErrExist      = errExist()      // "file already exists"
)
```

## Formatting Syntax

### Paragraphs

- Separate with blank lines
- Use `` ` `` for left quotes, `'` for right quotes
- Line breaks are preserved

### Headings

```go
// Package strconv implements conversions to and from string representations.
//
// # Numeric Conversions
//
// The most common numeric conversions are [Atoi] and [Itoa].
```

### Links

```go
// See the article "[JSON and Go]" for more details.
//
// [JSON and Go]: https://golang.org/doc/articles/json_and_go.html
```

### Doc Links

Reference Go identifiers:

- `[Name]` - current package
- `[pkg.Name]` - other package
- `[*bytes.Buffer]` - pointer types

### Lists

```go
// PublicSuffixList provides the public suffix of a domain. For example:
//   - the public suffix of "example.com" is "com"
//   - the public suffix of "foo.bar.co.uk" is "co.uk"
//
// Processing steps:
//   1. Replace multiple slashes with a single slash
//   2. Eliminate each . path name element
//   3. Eliminate each inner .. path name element
```

### Code Blocks

Indent with spaces or tabs:

```go
// Example usage:
//
//     func main() {
//         fmt.Println("Hello, World!")
//     }
```

## Special Features

### Deprecation

```go
// Deprecated: Use NewReader instead.
func OldReader() *Reader { ... }
```

### Notes

```go
// TODO: refactor to use standard library
// BUG: memory leak under certain conditions
```

## Best Practices

1. **Keep it simple**: Focus on what, not how
2. **Be consistent**: Use same patterns across your codebase
3. **Use gofmt**: It will format your comments correctly
4. **Test examples**: Include runnable examples when helpful
5. **Link related items**: Use doc links to connect related functionality

## Common Mistakes

- **Indenting text unintentionally** creates code blocks
- **Missing blank lines** between sections
- **Inconsistent receiver names** in methods
- **Implementation details** instead of user-facing behavior
- **Incomplete sentences** or unclear references

## Tools

- `go doc` - View documentation in terminal
- `gofmt` - Formats doc comments automatically
- `pkgsite` - Web-based documentation viewer
- `go vet` - Checks for documentation issues

---

_This guide covers Go 1.19+ doc comment features. For older versions, some syntax may not be supported._
