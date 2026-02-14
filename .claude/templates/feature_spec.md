# Feature Spec: [Feature Name]

> **Status**: Draft | In Review | Approved | Implemented
> **Author**: [name]
> **Date**: [YYYY-MM-DD]
> **Related Specs**: [links to related specs, if any]

## Summary

[One-sentence description of what this feature does and why it exists.]

## Motivation

[Why is this feature needed? What problem does it solve? What user need does it address?]

## Technology Context

> Only list what this feature specifically requires. Skip lines that don't apply.

- **Libraries/packages**: [any new dependencies this feature introduces]
- **External services**: [APIs, databases, third-party services this feature talks to]
- **Environment variables**: [new env vars needed, with example values]

## Affected Layers

- [ ] Types — new types/schemas needed
- [ ] Config — new configuration values
- [ ] Repo — data access changes
- [ ] Service — business logic
- [ ] Runtime — server/middleware changes
- [ ] UI — user-facing changes

## Data Model

> Define every field, type, and constraint. The agent writes code directly from this.

```python
class Example(BaseModel):
    """Describe what this model represents."""
    id: ExampleId          # Primary key — use refined type, not raw int
    name: str              # Human-readable name, max 100 chars
    status: ExampleStatus  # Enum: active, inactive, archived
    created_at: datetime   # Auto-set on creation
    metadata: dict | None = None  # Optional JSON blob
```

### Database Changes

> If this feature adds or modifies tables, list every column.

| Table | Column | Type | Constraints | Notes |
|-------|--------|------|-------------|-------|
| `examples` | `id` | `INTEGER` | `PRIMARY KEY AUTOINCREMENT` | |
| `examples` | `name` | `TEXT` | `NOT NULL, UNIQUE` | Max 100 chars |
| `examples` | `status` | `TEXT` | `NOT NULL DEFAULT 'active'` | Enum: active/inactive/archived |
| `examples` | `created_at` | `TIMESTAMP` | `NOT NULL DEFAULT CURRENT_TIMESTAMP` | |

## API Endpoints

> Define every endpoint this feature adds or modifies. Include full request/response bodies.

### `POST /api/examples` — Create an example

**Request:**
```json
{
  "name": "My Example",
  "metadata": {"key": "value"}
}
```

**Response (201):**
```json
{
  "id": 1,
  "name": "My Example",
  "status": "active",
  "created_at": "2026-01-15T10:30:00Z",
  "metadata": {"key": "value"}
}
```

**Errors:**

| Status | Condition | Response body |
|--------|-----------|---------------|
| `400` | Name is empty or exceeds 100 chars | `{"error": "validation_error", "message": "Name must be 1-100 characters"}` |
| `409` | Name already exists | `{"error": "conflict", "message": "An example with this name already exists"}` |

### `GET /api/examples` — List examples

**Query params:** `?status=active&limit=20&offset=0`

**Response (200):**
```json
{
  "items": [{"id": 1, "name": "My Example", "status": "active", "created_at": "..."}],
  "total": 42,
  "limit": 20,
  "offset": 0
}
```

## UI Changes

> Skip this section entirely if the feature has no user-facing changes.

### Layout

Describe where new UI elements appear and how they relate to existing layout:
- [e.g., "Add a 'Create Example' button in the top-right of the examples list page"]
- [e.g., "New modal dialog for example creation, triggered by the button"]

### Components

| Component | Location | Behavior |
|-----------|----------|----------|
| `CreateExampleButton` | `src/ui/examples/` | Opens creation modal on click |
| `ExampleForm` | `src/ui/examples/` | Validates name length, shows inline errors |
| `ExampleList` | `src/ui/examples/` | Paginated list with status filter dropdown |

### Visual Specs

> Include if relevant: colors, spacing, typography, responsive behavior.

- Button style: primary action (matches existing design system)
- Error text: red (#DC2626), 14px, below the input field
- List items: 48px height, hover highlight, truncate name at 40 chars

## User Interaction Flow

> Step-by-step walkthrough of how a user interacts with this feature. Agents use this to understand exact UX behavior.

1. User navigates to the examples page
2. User clicks "Create Example" button
3. Modal opens with name input and optional metadata fields
4. User enters name and clicks "Save"
5. If validation fails → inline error message appears, modal stays open
6. If save succeeds → modal closes, new example appears at top of list
7. Toast notification confirms "Example created"

## Business Rules

> Precise, testable statements. Each rule maps to one or more acceptance criteria.

1. Example names must be unique (case-insensitive)
2. Example names must be 1-100 characters, alphanumeric plus spaces and hyphens
3. Newly created examples always start with status "active"
4. Deleting an example soft-deletes it (sets status to "archived"), not hard-delete

## Edge Cases

> What happens at boundaries? Agents need these to write correct code.

1. **Empty name** → validation error, example not created
2. **Name with 100 chars** → accepted (boundary)
3. **Name with 101 chars** → validation error
4. **Duplicate name (different case)** → conflict error ("My Example" vs "my example")
5. **Create while offline** → error toast, form state preserved for retry

## Error Handling

| Error Condition | Layer | Error Type | User-Facing Message |
|----------------|-------|-----------|---------------------|
| Name too long | Service | `ValidationError` | "Name must be 1-100 characters" |
| Duplicate name | Repo | `ConflictError` | "An example with this name already exists" |
| Database unreachable | Repo | `ConnectionError` | "Unable to save. Please try again." |

## Implementation Order

> The agent implements in this order. Each step should be independently testable.

1. **Types**: Add `ExampleId`, `ExampleStatus` enum, `Example` model
2. **Repo**: Add `ExampleRepo` with `create()`, `list()`, `get_by_id()` methods
3. **Service**: Add `ExampleService` with business rule validation
4. **Runtime**: Register `ExampleService` in dependency injection
5. **UI**: Add route handler, form component, list component

## Acceptance Criteria

Each criterion must be mechanically verifiable (testable). Map each to the business rules and edge cases above.

- [ ] **AC-1**: Given valid name and metadata, when POST /api/examples, then example is created with status "active" and 201 returned
- [ ] **AC-2**: Given a name that already exists (case-insensitive), when POST /api/examples, then 409 conflict returned
- [ ] **AC-3**: Given name longer than 100 characters, when POST /api/examples, then 400 validation error returned

## Test Strategy

> Map tests to acceptance criteria. The agent writes these alongside implementation.

- **Unit tests**: Test `ExampleService` validation rules (mock repo). Covers AC-1, AC-3.
- **Integration tests**: Test `ExampleRepo` with in-memory SQLite. Covers AC-2.
- **E2E tests**: Test full create flow through UI. Covers AC-1 end-to-end.

## Success Criteria

> How do we know this feature is done? Measurable, verifiable checks.

- [ ] All acceptance criteria have passing tests
- [ ] Coverage for new code is >= 80%
- [ ] All 5 linters pass (`bash .claude/lint_all.sh`)
- [ ] API responses match the documented schemas exactly
- [ ] UI matches the visual specs described above
- [ ] No console errors or unhandled exceptions
- [ ] Edge cases are handled gracefully with user-friendly messages

## Security Considerations

[Any authentication, authorization, input validation, or data protection requirements]

## Performance Requirements

[Expected throughput, latency bounds, resource constraints, if applicable]

## Open Questions

> These MUST be resolved before status moves to "Approved". Agents stop and ask if they encounter these.

- [ ] [Any unresolved questions — these must be answered before moving forward]
