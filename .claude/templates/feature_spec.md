# Feature Spec: [Feature Name]

> **Status**: Draft | Approved | Implemented
> **Author**: [name]
> **Date**: [YYYY-MM-DD]

## Summary

[One sentence: what this feature does and why.]

## Motivation

[Why is this needed? What problem does it solve?]

## Technology Context

> Skip lines that don't apply.

- **Libraries/packages**: [new dependencies]
- **External services**: [APIs, databases]
- **Environment variables**: [new env vars]

## Affected Layers

- [ ] Types
- [ ] Config
- [ ] Repo
- [ ] Service
- [ ] Runtime
- [ ] UI

## Data Model

```python
class Example(BaseModel):
    id: ExampleId
    name: str  # Max 100 chars
    status: ExampleStatus  # Enum: active, inactive
```

## Business Rules

1. [Precise, testable statement]
2. [Each maps to acceptance criteria below]

## Acceptance Criteria

- [ ] **AC-1**: Given [context], when [action], then [result]
- [ ] **AC-2**: ...

## Test Strategy

- **Unit**: [what to test, what to mock]
- **Integration**: [if needed]

## Security / Performance

[One-liner each, or "N/A". Only include if this feature touches auth, user data, or has latency requirements.]

## Open Questions

> Must be resolved before Status moves to "Approved".

- [ ] [Unresolved question]
