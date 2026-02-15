# SDSL Project — Claude Code Harness

> **Philosophy**: Humans are harness engineers. Agents write all code. Specs are the source of truth.
> Ref: [OpenAI — Harness Engineering](https://openai.com/index/harness-engineering/)

## Architecture

**Spec-Driven Software Lifecycle (SDSL)** — specifications are the fundamental unit of work.

### Layer Model (strict dependency order)

```
Types → Config → Repo → Service → Runtime → UI
```

Code may only depend **forward** through layers. Enforced by `.claude/linters/layer_deps.sh`.

| Layer   | Path           | Purpose                                |
|---------|----------------|----------------------------------------|
| Types   | `src/types/`   | Shared types, enums, constants         |
| Config  | `src/config/`  | Configuration, env parsing, defaults   |
| Repo    | `src/repo/`    | Data access, storage, API clients      |
| Service | `src/service/` | Business logic, orchestration          |
| Runtime | `src/runtime/` | Server bootstrap, middleware           |
| UI      | `src/ui/`      | Presentation, CLI, user-facing layer   |

Details: `.claude/docs/architecture.md`

## Workflow: Spec → Plan → Approve → Implement → Review

```
SPEC (collaborative) → PLAN (agent) → APPROVE (human) → IMPLEMENT (agent) → REVIEW (agent)
```

1. **Spec** — collaborate with the spec-writer agent or use `.claude/templates/feature_spec.md`
2. **Plan** — agent writes execution plan in `specs/plans/<feature>.md`
3. **Approve** — **human approves the plan** (changes Status to "Approved")
4. **Implement** — implementer writes code following the approved plan
5. **Review** — reviewer checks spec compliance and code quality

> **Hard gate**: The pre-write hook **blocks all writes to `src/`** unless an approved plan exists.
> This is a mechanical check — agents cannot skip the approval step.

See `.claude/docs/workflow.md` for the full guide.

## Conventions

- **Naming**: `snake_case` for files/functions, `PascalCase` for classes/types
- **Types**: Refined Pydantic types for domain concepts — no raw `str`/`int` for IDs, emails, etc.
- **Tests**: Every service function needs a test in `tests/`. Coverage minimum: 80%.
- **No manual code**: All code is agent-generated from specs. Humans write specs and review.
- **Git**: Feature branches per spec, merge after review passes. See `.claude/docs/git-workflow.md`.

Details: `.claude/docs/conventions.md`

## Scaffolding

All framework files live in `.claude/`. The project root stays clean for application code.

| Path | Purpose |
|------|---------|
| `.claude/agents/` | Sub-agent definitions |
| `.claude/docs/` | Workflow, architecture, conventions |
| `.claude/templates/` | Spec and plan templates |
| `.claude/linters/` | Linters enforcing invariants |
| `.claude/hooks/` | Pre/post write hooks |
| `specs/features/` | Feature specifications |
| `specs/plans/` | Execution plans (must be Approved) |
| `src/` | Application code |
| `tests/` | Tests |

## Linters

Run all: `bash .claude/lint_all.sh`

- `layer_deps.sh` — enforces layer dependency direction
- `naming_conventions.sh` — file and symbol naming rules
- `spec_coverage.sh` — every service module must trace to a spec

## Agents (3)

| Agent | Role |
|-------|------|
| `spec-writer` | Interviews human to produce specs through Socratic dialogue |
| `implementer` | Writes code satisfying specs, layer by layer |
| `reviewer` | Checks spec compliance and code quality |

## Agent Instructions

- Before implementing, **read the spec** in `specs/features/`
- Before modifying a file, **read it first**
- **Plan approval is mandatory** — no code without an approved plan
- After writing code, **run the linters**: `bash .claude/lint_all.sh`
- When a linter fails, read the error — it contains the fix
- Humans write zero application code — they write specs, review, and evolve the harness
