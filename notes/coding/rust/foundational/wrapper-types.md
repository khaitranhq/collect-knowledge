# Wrapper Types in Rust

Smart pointers and wrapper types that provide additional ownership, memory management, and concurrency capabilities.

---

## **Box<T>** - Heap Allocation
**Usage:** Store data on the heap instead of stack. Useful for large data, recursive types, or trait objects.

```rust
let boxed = Box::new(5);
println!("{}", boxed); // 5
```

---

## **Rc<T>** - Reference Counting
**Usage:** Multiple ownership in single-threaded contexts. Cloning increases reference count.

```rust
use std::rc::Rc;

let a = Rc::new(5);
let b = Rc::clone(&a);
println!("count: {}", Rc::strong_count(&a)); // count: 2
```

---

## **Arc<T>** - Atomic Reference Counting
**Usage:** Thread-safe shared ownership. Like `Rc` but for multi-threaded contexts.

```rust
use std::sync::Arc;
use std::thread;

let data = Arc::new(5);
let data_clone = Arc::clone(&data);

thread::spawn(move || {
    println!("{}", data_clone);
});
```

---

## **RefCell<T>** - Interior Mutability
**Usage:** Allows mutation through shared references. Borrow checking at runtime.

```rust
use std::cell::RefCell;

let data = RefCell::new(5);
*data.borrow_mut() += 1;
println!("{}", data.borrow()); // 6
```

---

## **Mutex<T>** - Mutual Exclusion
**Usage:** Thread-safe interior mutability. Lock data for exclusive access across threads.

```rust
use std::sync::Mutex;

let m = Mutex::new(5);
{
    let mut num = m.lock().unwrap();
    *num = 6;
}
println!("{:?}", m); // Mutex { data: 6 }
```

---

## **RwLock<T>** - Read-Write Lock
**Usage:** Multiple readers or one writer. More efficient than Mutex for read-heavy workloads.

```rust
use std::sync::RwLock;

let lock = RwLock::new(5);
let r1 = lock.read().unwrap();
let r2 = lock.read().unwrap(); // Multiple readers OK
```

---

## **Cell<T>** - Interior Mutability (Copy Types)
**Usage:** Interior mutability for `Copy` types without runtime borrowing checks.

```rust
use std::cell::Cell;

let c = Cell::new(5);
c.set(10);
println!("{}", c.get()); // 10
```

---

## **Cow<T>** - Clone-on-Write
**Usage:** Abstracts over borrowed and owned data. Clones only when mutation is needed.

```rust
use std::borrow::Cow;

fn process(input: Cow<str>) -> Cow<str> {
    if input.contains("hello") {
        Cow::Owned(input.replace("hello", "hi")) // Clone only when modifying
    } else {
        input // No clone, just return borrowed
    }
}

let s = "hello world";
let result = process(Cow::Borrowed(s));
```

**Common Use Cases:**
- Avoiding unnecessary allocations when data might not be modified
- APIs that accept both `&str`/`&[T]` and `String`/`Vec<T>`
- Optimization for read-heavy, occasionally-write scenarios

---

## Common Combinations

```rust
// Shared mutable state across threads
Arc<Mutex<T>>

// Shared state with multiple readers
Arc<RwLock<T>>

// Single-threaded shared mutable state
Rc<RefCell<T>>
```
