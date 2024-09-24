# Best Practices for Error handling in Go

## Use `defer` function

Use `defer()` to clean up resources like files, connections, or **goroutines** when a function exits, whether through `return` or `panic`. In the following function, `defer` ensures the file is closed after use.

```go
    f, err := os.Open(path)
    if err != nil {
        return nil, fmt.Errorf("open failed: %w", err)
    }
    defer f.Close()
```

## Provide explicit error information

Cryptic error messages like "ERROR: EPIC FAIL" provide little context, making it difficult to trace their cause, even for the developers. To improve troubleshooting, errors should be wrapped with relevant contextual information before being passed up the call chain.

## Use Panic and Recover only when necessary

Go newcomers often prefer using panic over Go's explicit error handling, but this is unidiomatic and hides the error flow. Errors in Go should be treated as part of the normal program flow, handled or passed up the chain, with panic reserved for unexpected, unrecoverable errors like out-of-memory situations, while predictable failures such as invalid user input should be handled explicitly.

## Use libraries and packages that follow error handling best practices

When choosing between third-party packages with similar functionality, prioritize those that follow best practices for error handling. A package with weak error handling or no context for errors will complicate troubleshooting, so it's worth checking the code to ensure robust error handling.

## Create Custom Error types whenever suiatble

Because `error` is an interface, you can build custom error types with extra functionality as long as they implement `Error()` string.

This error is a `struct` that implements the methods `Error()`, `Unwrap()`, and `Timeout()` and provides the fields `Path`, `Op`, and `Error` to capture detailed error information:

```go
type PathError struct {
  Op   string
  Path string
  Err  error
}

func (e *PathError) Error() string { return e.Op + " " + e.Path + ": " + e.Err.Error() }

func (e *PathError) Unwrap() error { return e.Err }

// Timeout reports whether this error represents a timeout.func (e *PathError) Timeout() bool {
  t, ok := e.Err.(interface{ Timeout() bool })
  return ok && t.Timeout()
}
```
