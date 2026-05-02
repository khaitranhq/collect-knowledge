# Amazon EventBridge

## Overview

Amazon EventBridge is a serverless event bus service that makes it easier to build event-driven applications at scale.

## Event Sources & Destinations

![eventbridge-source-dest](/assets/2025-02-22-22-02-59.png)

### Event Buses

Event buses receive events from various sources and match them to rules in your account. Sources include:

- AWS services in your account
- AWS services from other accounts
- Custom applications and services
- Partner applications and services

  ![other-sources-event-buses](/assets/2025-02-22-22-03-15.png)

### Event Archiving

- Events can be archived (all events or filtered) sent to an event bus
- Archive duration can be:
  - Indefinite
  - Set time period
- Archived events can be replayed when needed

## Schema Registry

EventBridge provides powerful schema management capabilities:

- Automatically analyzes events in your bus to infer the schema
- Schema Registry enables code generation for your applications
  - Provides advance knowledge of event bus data structure
  - Helps maintain consistency in event handling
- Supports schema versioning for better evolution management
