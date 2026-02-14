# Design Doc: [Feature Name]

> **Spec**: specs/features/[feature-name].md
> **Status**: Draft | Approved
> **Date**: [YYYY-MM-DD]

## Overview

[Brief summary of the design approach for implementing the spec.]

## Architecture

### Component Diagram

```
[ASCII or mermaid diagram showing components and their relationships]
```

### Layer Breakdown

| Layer | Files to Create/Modify | Purpose |
|-------|----------------------|---------|
| Types | `src/types/...` | [what types are needed] |
| Config | `src/config/...` | [what config is needed] |
| Repo | `src/repo/...` | [data access changes] |
| Service | `src/service/...` | [business logic] |
| Runtime | `src/runtime/...` | [server/middleware] |
| UI | `src/ui/...` | [user-facing] |

## Implementation Plan

### Phase 1: [Foundation]
1. [Task 1 — estimated complexity: low/medium/high]
2. [Task 2]

### Phase 2: [Core Logic]
1. [Task 3]
2. [Task 4]

### Phase 3: [Integration]
1. [Task 5]
2. [Task 6]

## Dependencies

- [External packages needed]
- [Internal modules this depends on]

## Testing Strategy

- Unit tests for: [list service functions]
- Integration tests for: [list integration points]
- Edge case tests for: [list from spec]

## Alternatives Considered

| Approach | Pros | Cons | Decision |
|----------|------|------|----------|
| [Option A] | [pros] | [cons] | **Chosen** / Rejected |
| [Option B] | [pros] | [cons] | Chosen / **Rejected** |

## Risks

- [Risk 1 — mitigation strategy]
