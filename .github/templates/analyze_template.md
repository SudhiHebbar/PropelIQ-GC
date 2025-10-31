name: "Codebase Analysis Report Template - Comprehensive Reverse Engineering"
description: |

## Purpose
Template for comprehensive codebase analysis and reverse engineering documentation, optimized for stakeholder communication and technical understanding.

## Core Principles
1. **Comprehensive Discovery**: Document all aspects of the system architecture and implementation
2. **Stakeholder Alignment**: Provide both executive summaries and technical deep-dives
3. **Actionable Insights**: Include prioritized recommendations with effort estimates
4. **Quality Assessment**: Validate findings with metrics and confidence levels
5. **Global Rules**: Follow all guidelines in CLAUDE.md and References/Gotchas

---

## 1. Executive Summary

### System Overview
[System purpose and business context in <100 words]

### Analysis Confidence Level
**Overall Confidence**: [High/Medium/Low]
**Key Assumptions**: [List critical assumptions made during analysis]

---

## 2. Technical Architecture Documentation

### System Architecture Overview
[High-level description of system architecture and design philosophy]

### Design Patterns Identified
| Pattern Type | Pattern Name | Usage | Location |
|--------------|--------------|--------|----------|
| Architectural | [Pattern] | [How it's used] | [Where in codebase] |
| Design | [Pattern] | [How it's used] | [Where in codebase] |
| Integration | [Pattern] | [How it's used] | [Where in codebase] |

### Anti-Patterns Detected
| Anti-Pattern | Impact | Location | Remediation |
|--------------|---------|----------|-------------|
| [Anti-pattern name] | [Impact description] | [File/module] | [Fix approach] |

### System Topology
- **Entry Points**: [List of system entry points]
- **Communication Protocols**: [REST, GraphQL, gRPC, WebSocket, etc.]
- **Data Flow**: [Description of data flow patterns]
- **External Integrations**: [Third-party services and APIs]

---

## 3. Technology Stack Inventory

## Technical Context

<!--
  ACTION REQUIRED: Replace the content in this section with the technical details for the project. The structure here is presented in advisory capacity to guide the iteration process.
-->

**Language/Version**: [e.g., Python 3.11, Swift 5.9, Rust 1.75 or NEEDS CLARIFICATION]  
**Primary Dependencies**: [e.g., FastAPI, UIKit, LLVM or NEEDS CLARIFICATION]  
**Storage**: [if applicable, e.g., PostgreSQL, CoreData, files or N/A]  
**Testing**: [e.g., pytest, XCTest, cargo test or NEEDS CLARIFICATION]  
**Target Platform**: [e.g., Linux server, iOS 15+, WASM or NEEDS CLARIFICATION]
**Project Type**: [single/web/mobile - determines source structure]  
**Performance Goals**: [domain-specific, e.g., 1000 req/s, 10k lines/sec, 60 fps or NEEDS CLARIFICATION]  
**Constraints**: [domain-specific, e.g., <200ms p95, <100MB memory, offline-capable or NEEDS CLARIFICATION]  
**Scale/Scope**: [domain-specific, e.g., 10k users, 1M LOC, 50 screens or NEEDS CLARIFICATION]

---

## 4. Critical Business Logic Documentation

### Core Business Logic Classes
| Class/Module | Location | Business Purpose | Key Methods | Business Rules | Dependencies |
|--------------|----------|------------------|-------------|----------------|--------------|
| [ClassName] | [File path] | [Plain English description of what business problem this solves] | [Primary methods and their purpose] | [Key business rules enforced] | [Critical dependencies] |
| [UserAuthentication] | auth/services/auth.ts | Manages user login, session validation, and access control | authenticate(), validateToken(), checkPermissions() | Password must be 8+ chars, sessions expire after 24h, max 3 login attempts | JWT library, User model |
| [PaymentProcessor] | billing/services/payment.ts | Handles payment transactions, refunds, and subscription management | processPayment(), refund(), updateSubscription() | Min transaction $1, refunds within 30 days, retry failed payments 3x | Stripe API, Transaction model |
| [InventoryManager] | inventory/services/stock.ts | Tracks product availability and manages stock levels | checkStock(), reserveItems(), updateQuantity() | Prevent overselling, auto-reorder at 20% threshold, FIFO allocation | Database, Product model |

### Business Process Flows
| Process Name | Entry Class | Flow Description | Critical Decision Points | Error Handling |
|--------------|-------------|------------------|--------------------------|----------------|
| [Process] | [Starting class] | [Step-by-step business flow in plain English] | [Where business logic branches] | [How failures are handled] |
| Order Fulfillment | OrderService | 1. Validate customer 2. Check inventory 3. Process payment 4. Create shipment 5. Send confirmation | Payment approval, Stock availability, Shipping restrictions | Rollback on failure, notify customer |

### Business Rule Validation
| Rule Category | Implementation Location | Description | Validation Logic | Failure Impact |
|---------------|------------------------|-------------|------------------|----------------|
| [Category] | [Class/Method] | [Plain English rule] | [How it's checked] | [What happens if violated] |
| Pricing Rules | PricingEngine.calculate() | Apply discounts based on customer tier and volume | Check tier status, calculate volume discount, apply max 50% total | Order rejected, manual review required |
| Compliance | ComplianceChecker.validate() | Ensure transactions meet regulatory requirements | Verify customer KYC, check transaction limits, validate geographic restrictions | Transaction blocked, compliance alert triggered |

---

## 5. Source Code Organization

### Repository Structure

#### Frontend Applications
```
[Tree structure of frontend code]
```
**Notable Patterns**: [Observations about organization]

#### Backend Services
```
[Tree structure of backend code]
```
**Notable Patterns**: [Observations about organization]

#### Shared Libraries
```
[Tree structure of shared code]
```
**Notable Patterns**: [Observations about organization]

#### Infrastructure as Code
```
[Tree structure of IaC]
```
**Notable Patterns**: [Observations about organization]

[Delete unused options]
---

## 6. Routes & Entry Points

### UI Routes
| Route Path | Component | Purpose | Authentication |
|------------|-----------|---------|----------------|
| [Path] | [Component] | [Purpose] | [Required/Optional/None] |

### API Endpoints
| Method | Path | Purpose | Authentication | Rate Limit |
|--------|------|---------|----------------|------------|
| [GET/POST/etc] | [Path] | [Purpose] | [Auth type] | [Limit] |

### Background Jobs
| Job Name | Trigger | Schedule | Purpose | Dependencies |
|----------|---------|----------|---------|--------------|
| [Name] | [Type] | [CRON/Timer] | [Purpose] | [Services] |

### Message Queues/Events
| Topic/Queue | Producer | Consumer | Message Type | Purpose |
|-------------|----------|----------|--------------|---------|
| [Name] | [Service] | [Service] | [Type] | [Purpose] |

[Delete unused options]

---

## 7. Dependency Analysis

### Critical Dependencies
| Dependency | Version | Status | Risk | Recommended Action |
|------------|---------|--------|------|-------------------|
| [Library/Service] | [Version] | [Active/Deprecated/EOL] | [Security/Performance/Maintenance] | [Update/Replace/Monitor] |

---

*This codebase analysis report provides a comprehensive understanding of the system architecture, core business logic and code organization to support informed decision-making.*