# Execution Plan: [Task Title]

**Feature Spec**: `specs/features/[feature-name].md`
**Created**: [YYYY-MM-DD]
**Status**: [in-progress | completed | abandoned]

## Purpose

What someone can do after this change that they could not do before.
Frame in terms of user-visible outcomes, not internal implementation.

## Context and Orientation

Current state of the codebase relevant to this task.
Name files with full repository-relative paths. Define any non-obvious terminology.

## Plan of Work

Prose description of the approach. Why this approach over alternatives.
Reference specific layers, modules, and functions by name.

## Concrete Steps

Step-by-step instructions. Each step must be idempotent (safe to run multiple times).
Include exact commands with expected output where applicable.

### Milestone 1: [Name]

What this milestone achieves and what becomes usable after it.

- [ ] Step 1: [exact action with file paths]
- [ ] Step 2: [exact action with file paths]

**Verify**: [Observable acceptance — e.g., "running `pytest tests/unit/` shows 0 failures"]

### Milestone 2: [Name]

- [ ] Step 1: ...

**Verify**: [Observable acceptance]

## Progress

Update with timestamps as work proceeds.

- [ ] [YYYY-MM-DD HH:MM] Milestone 1 started
- [ ] [YYYY-MM-DD HH:MM] Milestone 1 completed

## Surprises & Discoveries

Document unexpected behaviors, edge cases, or assumptions that proved wrong.
Include evidence (error messages, test output).

- [None yet]

## Decision Log

Every decision made during implementation, with rationale.

| Date | Decision | Rationale |
|------|----------|-----------|
| | | |

## Outcomes & Retrospective

Fill in at completion or at major milestones.

**What worked**:
**What didn't**:
**Follow-up tasks**:

## Acceptance Criteria

Observable, demonstrable behaviors that prove the work is complete.
Not "code compiles" — instead, "starting the server and requesting GET /api/users returns HTTP 200 with a JSON array."

1. [ ] [Observable behavior 1]
2. [ ] [Observable behavior 2]
3. [ ] [Observable behavior 3]
