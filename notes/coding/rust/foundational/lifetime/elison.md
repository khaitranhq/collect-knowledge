# Lifetime Elision in Rust

**Elision** = Rust automatically infers lifetimes so you don't have to write them explicitly.

Think of it as Rust saying: _"I can guess what you mean, so you don't need to spell it out."_

---

## 📏 The Three Elision Rules

Rust applies these rules when inferring lifetimes:

1. **Each reference parameter gets its own lifetime**
2. **Single input lifetime** → assigned to all output lifetimes
3. **Multiple input lifetimes with `&self` or `&mut self`** → `self`'s lifetime assigned to output

---

## ✅ Examples

### Rule #2: Single Input Lifetime

**Without Elision:**

```rust
fn get_first<'a>(s: &'a str) -> &'a str {
    &s[0..1]
}
```

**With Elision:**

```rust
fn get_first(s: &str) -> &str {
    &s[0..1]
}
```

### Rule #3: Using `&self`

```rust
impl MyStruct {
    fn name(&self) -> &str {
        &self.name
    }
}
```

_Rust automatically uses `self`'s lifetime for the return value._

---

## ❌ When Elision Fails

```rust
fn longest(x: &str, y: &str) -> &str {
    if x.len() > y.len() { x } else { y }
}
```

**Error:** Rust can't determine if the returned reference comes from `x` or `y`.

### ✅ Solution: Explicit Lifetimes

```rust
fn longest<'a>(x: &'a str, y: &'a str) -> &'a str {
    if x.len() > y.len() { x } else { y }
}
```

Both `x` and `y` share lifetime `'a`, guaranteeing the return value lives at least as long as `'a`.
