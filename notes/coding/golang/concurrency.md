# Golang Concurrency

## Select

### Basic usage - Blocking

It blocks until one of the cases is ready. If multiple cases are ready, one is chosen at random.

**Common patterns:**

- Timeout
  ```go
  select {
  case msg := <-ch:
      fmt.Println("Received message:", msg)
  case <-time.After(2 * time.Second):
      fmt.Println("Timeout occurred")
  }
  ```
- Terminal signals:

  ```go
  quit := make(chan bool)
  select {
  // other cases...
  case <-quit:
      fmt.Println("Received quit signal")
  }
  ```

### With default case - Non-blocking

It allows the program to continue executing if no cases are ready.

**Common patterns:**

- Non-blocking receive: check if a channel has data without pausing execution.
  ```go
  select {
  case msg := <-ch:
      fmt.Println("Received message:", msg)
  default:
      fmt.Println("No message received, doing other work")
  }
  ```
- Non-blocking send: attempt to send data only if the channel is ready to receive.
  ```go
  select {
  case ch <- msg:
      fmt.Println("Sent message:", msg)
  default:
      fmt.Println("Channel is full, cannot send message")
  }
  ```
- Rate limiting/Throttling: executing task only if a certain time has passed.

  ```go
  ticker := time.NewTicker(1 * time.Second)
  defer ticker.Stop()

  for {
      select {
      case <-ticker.C:
          fmt.Println("Tick at", time.Now())
      default:
          // Do other work or sleep briefly to avoid busy waiting
          // e.g time.Sleep(100 * time.Millisecond)
      }
  }
  ```
