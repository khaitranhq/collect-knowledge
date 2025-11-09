# Model Context Protocol (MCP)

## What is MCP?

**Model Context Protocol (MCP)** is an open, standardized protocol for integrating LLM applications with external data sources and tools. Created by Anthropic, inspired by Language Server Protocol (LSP).

**Analogy**: "USB-C port for AI applications" - a universal interface for AI systems to access context and execute actions.

**Version**: `2025-06-18` (current stable)

---

## Architecture

### Three-Tier Model

```
┌─────────────────────────────┐
│   HOST (LLM Application)    │  ← Claude Desktop, Custom Apps
│  ┌────────┐  ┌────────┐     │
│  │Client 1│  │Client 2│     │
└──┴────────┴──┴────────┴─────┘
       │            │
   ┌───▼───┐    ┌──▼────┐
   │Server1│    │Server2│      ← GitHub, Slack, Filesystem
   └───────┘    └───────┘
```

**Components**:

- **Host**: LLM application managing clients and enforcing security
- **Client**: Protocol connector (1:1 with server)
- **Server**: Service exposing Resources, Prompts, and/or Tools

---

## Core Terms

| Term            | Definition                             | Control                         |
| --------------- | -------------------------------------- | ------------------------------- |
| **Resource**    | Contextual data (files, API responses) | Application-controlled          |
| **Prompt**      | Message template with arguments        | User-controlled                 |
| **Tool**        | Executable function                    | Model-controlled                |
| **Sampling**    | Server requests LLM completion         | Client feature                  |
| **Roots**       | Filesystem boundaries                  | Client feature                  |
| **Elicitation** | Server requests user input             | Client feature (NEW 2025-06-18) |

---

## How It Works

### 1. Protocol Foundation

**Base**: JSON-RPC 2.0 with stateful connections

**Message Types**:

- **Requests**: Require response (must have non-null ID)
- **Responses**: Reply to requests
- **Notifications**: One-way messages
- **Auth**: Authorization messages (HTTP only)

### 2. Connection Lifecycle

```
┌─────────────────────────────────────────────┐
│  Phase 1: INITIALIZATION                    │
│  • Version negotiation                      │
│  • Capability exchange                      │
│  • initialize → response → initialized      │
├─────────────────────────────────────────────┤
│  Phase 2: OPERATION                         │
│  • Request/response cycles                  │
│  • Notifications                            │
│  • Bidirectional communication              │
├─────────────────────────────────────────────┤
│  Phase 3: SHUTDOWN                          │
│  • shutdown → response → exit               │
│  • Graceful termination                     │
└─────────────────────────────────────────────┘
```

### 3. Transports

**stdio** (Local):

- Subprocess communication
- Newline-delimited JSON-RPC
- Server reads stdin, writes stdout

**Streamable HTTP** (Remote):

- POST `/messages` - Client → Server
- GET `/sse` - Server → Client (Server-Sent Events)
- Session management via `Mcp-Session-Id` header

### 4. Server Features (What Servers Expose)

**Resources** - Data Access

```json
// List resources
{"method": "resources/list"}

// Read resource
{"method": "resources/read", "params": {"uri": "file:///path"}}

// Subscribe to changes
{"method": "resources/subscribe", "params": {"uri": "..."}}
```

**Prompts** - Workflow Templates

```json
// List prompts
{"method": "prompts/list"}

// Get prompt with arguments
{"method": "prompts/get", "params": {
  "name": "code-review",
  "arguments": {"filepath": "src/auth.ts"}
}}
```

**Tools** - Executable Functions

```json
// List tools
{"method": "tools/list"}

// Call tool
{"method": "tools/call", "params": {
  "name": "get_weather",
  "arguments": {"city": "San Francisco"}
}}
```

### 5. Client Features (What Clients Provide)

**Sampling** - LLM Access

- Servers request LLM completions
- Model preferences: cost/speed/intelligence priorities
- User approval required

**Roots** - Filesystem Boundaries

- Expose filesystem paths to servers
- file:// URIs
- Context-aware operations

**Elicitation** - User Input Requests (NEW)

- Servers request structured input
- JSON Schema-based (flat objects only)
- Three responses: accept/decline/cancel

---

## Use Cases

- **AI Chatbots**: Access knowledge bases, ticketing systems
- **IDE Assistants**: Repository context, code analysis
- **Healthcare AI**: EHR, wearables, lab results integration
- **Content Creation**: Multi-platform automation (YouTube → LinkedIn)
- **Database Agents**: Business intelligence, SQL queries

---

## Security Essentials

**Access Control**:

- Principle of least privilege
- Zero trust architecture
- User consent required

**Credential Management**:

- Use secret management systems
- Environment variables for stdio
- OAuth 2.1 for HTTP
- Never hardcode credentials

**Input Validation**:

- Sanitize all user inputs
- Path traversal prevention
- Command injection protection
- Use `shell=False` in subprocess calls

**Network Security**:

- Bind local servers to `127.0.0.1`
- Validate Origin headers (DNS rebinding protection)
- Use HTTPS for production

**Monitoring**:

- Comprehensive logging
- Rate limiting
- Anomaly detection
- Audit trails

---

## Key Design Principles

1. **Server Simplicity**: Easy to implement and deploy
2. **Composability**: Multiple servers work together seamlessly
3. **Isolation**: Servers don't see conversation history or other servers
4. **Progressive Features**: Optional capabilities via negotiation
5. **Security First**: User consent, access controls, audit logging

---

## Resources

- **Specification**: https://spec.modelcontextprotocol.io
- **GitHub**: https://github.com/modelcontextprotocol
- **Official Site**: https://modelcontextprotocol.io

**SDKs**: TypeScript, Python, Go, Kotlin, Swift, Java, C#, Ruby, Rust, PHP

**Current Version**: `2025-06-18`
