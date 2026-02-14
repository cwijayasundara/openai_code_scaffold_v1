# Execution Plan: [Task Title]

**Feature Spec**: `specs/features/[feature-name].md`
**Created**: [YYYY-MM-DD]
**Status**: [draft | approved | in-progress | completed | abandoned]
**Approved by**: [human name or "pending"]

> **This plan requires human approval before implementation begins.**
> No code is written until status changes from "draft" to "approved".

## Purpose

What someone can do after this change that they could not do before.

## Context and Orientation

Current state of the codebase relevant to this task.
Name files with full repository-relative paths.

## Plan of Work

Prose description of the approach. Why this approach over alternatives.

## Tasks

Break the work into small, atomic tasks. Each task should take **2-5 minutes** for an agent to execute.

### Milestone 1: [Name]

What this milestone achieves.

#### Task 1.1: [Short description]

- **What**: [Exact action — e.g., "Create ExampleId refined type and ExampleStatus enum"]
- **Where**: `src/types/example.py`
- **Details**: [Complete description of the code to write, or the change to make]
- **Verify**: `python -c "from src.types.example import ExampleId, ExampleStatus"` succeeds

#### Task 1.2: [Short description]

- **What**: [Exact action]
- **Where**: [file path]
- **Details**: [Complete description]
- **Verify**: [command + expected output]

**Milestone verification**: [Observable acceptance — e.g., "`pytest tests/unit/` shows 0 failures"]

### Milestone 2: [Name]

#### Task 2.1: ...

**Milestone verification**: ...

## Progress

- [ ] [YYYY-MM-DD HH:MM] Plan approved by human
- [ ] [YYYY-MM-DD HH:MM] Milestone 1 completed

## Surprises & Discoveries

- [None yet]

## Decision Log

| Date | Decision | Rationale |
|------|----------|-----------|
| | | |

## Acceptance Criteria

Observable, demonstrable behaviors that prove the work is complete.

1. [ ] [Observable behavior 1]
2. [ ] [Observable behavior 2]
