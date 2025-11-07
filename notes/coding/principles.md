# Coding Principles & Design Patterns

## SOLID Principles

### **S - Single Responsibility Principle (SRP)**

- A class should have **one, and only one, reason to change**
- Each class/module handles one specific functionality
- Improves maintainability and reduces coupling

### **O - Open/Closed Principle (OCP)**

- Software entities should be **open for extension, closed for modification**
- Add new functionality without changing existing code
- Use abstraction, inheritance, and polymorphism

### **L - Liskov Substitution Principle (LSP)**

- Subtypes must be **substitutable for their base types**
- Derived classes should enhance, not weaken, base class behavior
- Maintains contract and expected behavior

### **I - Interface Segregation Principle (ISP)**

- Clients shouldn't depend on **interfaces they don't use**
- Create specific, focused interfaces over general-purpose ones
- Reduces unnecessary dependencies

### **D - Dependency Inversion Principle (DIP)**

- Depend on **abstractions, not concretions**
- High-level modules shouldn't depend on low-level modules
- Both should depend on abstractions (interfaces/abstract classes)

---

## DRY - Don't Repeat Yourself

- **Every piece of knowledge should have a single, authoritative representation**
- Eliminate code duplication through abstraction
- Reduces maintenance burden and bugs

---

## KISS - Keep It Simple, Stupid

- **Simplicity should be a key goal in design**
- Avoid unnecessary complexity
- Simple code is easier to understand, test, and maintain

---

## YAGNI - You Aren't Gonna Need It

- **Don't implement features until they're actually needed**
- Avoid speculative development
- Reduces wasted effort and code bloat

---

## Separation of Concerns (SoC)

- **Divide program into distinct sections** handling specific concerns
- Examples: MVC (Model-View-Controller), layered architecture
- Improves modularity and testability

---

## Composition Over Inheritance

- **Favor object composition over class inheritance**
- More flexible and reduces tight coupling
- Easier to modify behavior at runtime

---

## Law of Demeter (Principle of Least Knowledge)

- **A unit should have limited knowledge about other units**
- Only talk to immediate friends: `a.getB().getC().doSomething()` ❌
- Reduces dependencies between components

---

## Fail Fast

- **Detect and report errors as early as possible**
- Validate inputs immediately
- Makes debugging easier and prevents cascading failures

---

## Convention Over Configuration

- **Provide sensible defaults** to reduce configuration needs
- Common in frameworks (Rails, Spring Boot)
- Speeds up development while allowing customization

---

## Boy Scout Rule

- **"Leave the code cleaner than you found it"**
- Continuous incremental improvement
- Small refactorings accumulate over time

---

## Quick Reference Table

| Principle | Core Idea              | Benefit         |
| --------- | ---------------------- | --------------- |
| **SRP**   | One responsibility     | Maintainability |
| **OCP**   | Extend, don't modify   | Stability       |
| **LSP**   | Substitutable subtypes | Reliability     |
| **ISP**   | Focused interfaces     | Decoupling      |
| **DIP**   | Depend on abstractions | Flexibility     |
| **DRY**   | Single source of truth | Consistency     |
| **KISS**  | Simplicity first       | Clarity         |
| **YAGNI** | Build what's needed    | Efficiency      |

---

**💡 Remember**: These are _principles_, not rules. Apply them with pragmatism based on project context and team needs.
