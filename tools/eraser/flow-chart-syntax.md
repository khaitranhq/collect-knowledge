# Flow Chart Syntax

## Nodes

- A node is the most basic building block in a flow chart.
- Node definitions consist of a name followed by an optional set of properties.
  - Example: `Start [shape: oval]` (name: `Start`, property: `shape: oval`)
- Node names must be unique.
- Supported properties:
  - `shape`, `icon`, `color`, and `label`.

---

## Groups

- A group is a container that can encapsulate nodes and other groups.
- Group definitions consist of a name followed by `{}`.
  - Example:
    ```
    Loop {
      Issue1, Issue2, Issue3
    }
    ```
- Nodes (or groups) inside a group can be enumerated using commas or new lines.
  - Example:
    ```
    Loop {
      Issue1
      Issue2
      Issue3
    }
    ```
- Group names must be unique.
- Groups can be nested.
  - Example:
    ```
    Outer Loop {
      Inner Loop {
        Issue1
        Issue2
      }
      Issue3
    }
    ```
- Supported properties:
  - `icon`, `color`, and `label`.

---

## Properties

- Properties are key-value pairs enclosed in `[]` brackets and are optional.
- Allowed properties:
  | Property | Description | Value Example | Default Value |
  |--------------|---------------------------------|-----------------------------------|---------------------|
  | `shape` | Shape of the node | `diamond`, `oval` | `rectangle` |
  | `icon` | Icon | `aws-ec2` | |
  | `color` | Stroke and fill color | `"blue"`, `"#000000"` | |
  | `label` | Text label | `"Main Server"` | Name of node/group |
  | `colorMode` | Fill color lightness | `pastel`, `bold`, `outline` | `pastel` |
  | `styleMode` | Embellishments | `shadow`, `plain`, `watercolor` | `shadow` |
  | `typeface` | Text typeface | `rough`, `clean`, `mono` | `rough` |

- Example of multiple properties:
  ```
  Start [shape: oval, icon: flag]
  ```

---

## Connections

- Represent relationships between nodes and groups.
- Example:
  ```
  Issue > Bug
  ```

### Types of Connectors

| Syntax | Description          |
| ------ | -------------------- |
| `>`    | Left-to-right arrow  |
| `<`    | Right-to-left arrow  |
| `<>`   | Bi-directional arrow |
| `-`    | Line                 |
| `--`   | Dotted line          |
| `-->`  | Dotted arrow         |

### Connection Labels

- Add labels to connections.
  - Example:
    ```
    Issue > Bug: Triage
    ```

### Branching Connections

- Create one-to-many connections in a single statement.
  - Example:
    ```
    Issue > Bug, Feature
    ```

### Chained Connections

- Chain a sequence of connection statements.
  - Example:
    ```
    Issue > Bug > Duplicate?
    ```

### Connection Properties

| Property | Description | Example                              |
| -------- | ----------- | ------------------------------------ |
| `color`  | Line color  | `Issue > Bug: Triage [color: green]` |

---

## Icons

- Lists of icons you can use:
  - AWS Icons
  - Google Cloud Icons
  - Azure Icons
  - Tech Logos
  - General Icons

---

## Escape Strings

- Certain characters are reserved in node and group names.
- To use them, wrap the name in quotes.
  - Example:
    ```
    User > "https://localhost:8080": GET
    ```

---

## Direction

- Change the flow chart's direction using the `direction` statement.
- Allowed directions:
  - `down` (default)
  - `up`
  - `right`
  - `left`
- Example:
  ```
  direction right
  ```

---

## Styling

- Styles can be applied at the diagram level.
- Properties:
  | Property | Values | Default Value | Example Syntax |
  |--------------|-------------------------|---------------|---------------------|
  | `colorMode` | `pastel`, `bold`, `outline` | `pastel` | `colorMode bold` |
  | `styleMode` | `shadow`, `plain`, `watercolor` | `shadow` | `styleMode shadow` |
  | `typeface` | `rough`, `clean`, `mono` | `rough` | `typeface clean` |
