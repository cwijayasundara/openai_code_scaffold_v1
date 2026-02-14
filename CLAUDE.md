# SDSL Project — Claude Code Harness

> **Philosophy**: Humans are harness engineers. Agents write all code. Specs are the source of truth.
> Ref: [OpenAI — Harness Engineering](https://openai.com/index/harness-engineering/)
> This file is a map, not a manual. Follow pointers to deeper sources of truth.

## Architecture

This project uses **Spec-Driven Software Lifecycle (SDSL)** — specifications, not prompts or code, are the fundamental unit of work.

### Layer Model (strict dependency order)

```
Types → Config → Repo → Service → Runtime → UI
```

Code may only depend **forward** through layers. Backward dependencies are forbidden and enforced by `scripts/linters/layer_deps.sh`.

| Layer     | Path              | Purpose                                      |
|-----------|-------------------|-----------------------------------------------|
| Types     | `src/types/`      | Shared types, enums, constants, schemas       |
| Config    | `src/config/`     | Configuration loading, env parsing, defaults  |
| Repo      | `src/repo/`       | Data access, storage, external API clients    |
| Service   | `src/service/`    | Business logic, orchestration, domain rules   |
| Runtime   | `src/runtime/`    | Server bootstrap, middleware, lifecycle       |
| UI        | `src/ui/`         | Presentation, CLI output, user-facing layer   |

## Workflow: Spec → Plan → Approve → Implement → Review

```
SPEC (collaborative) → PLAN (agent) → APPROVE (human) → IMPLEMENT (agent) → SPEC REVIEW (agent) → CODE REVIEW (agent)
```

1. **Write a spec** — collaborate with the spec-writer agent (Socratic interview) or use `specs/templates/feature_spec.md`
2. **Plan** — agent writes execution plan with 2-5 minute tasks, exact file paths, and verification steps
3. **Approve** — **human reviews and approves the plan before any code is written**
4. **Implement** — execute tasks using Claude Code agents
5. **Spec review** — spec-reviewer validates implementation against the spec
6. **Code review** — code-reviewer validates code quality and conventions

See `docs/workflow.md` for the full workflow guide.

## Conventions

- **Structured logging only** — use the project logger, never raw print/console
- **Naming**: `snake_case` for files and functions, `PascalCase` for classes/types
- **Max file size**: 300 lines. If a file exceeds this, split it.
- **Max function size**: 50 lines. Extract helpers if needed.
- **Types**: Refined Pydantic types for domain concepts — no raw `str`/`int` for IDs, emails, etc.
- **Tests**: Every service function needs a test in `tests/` mirroring `src/`. Coverage minimum: 80%.
- **No manual code**: All code is agent-generated from specs. Humans write specs and review.
- **Git workflow**: Feature branches per spec, merge after both reviews pass. See `docs/git-workflow.md`.

Details: [docs/conventions.md](docs/conventions.md)

## Key Files

| File | Purpose |
|------|---------|
| `specs/` | Feature specifications (source of truth for intent) |
| `docs/workflow.md` | Full SDSL workflow guide |
| `docs/architecture.md` | Detailed architecture reference |
| `docs/conventions.md` | Coding standards and type conventions |
| `docs/git-workflow.md` | Git branching and merge workflow |
| `scripts/linters/` | Custom linters enforcing invariants |
| `.claude/agents/` | Sub-agent definitions for specialized tasks |
| `.claude/settings.json` | Hook configurations and permissions |

## Linter Rules (enforced via hooks)

All linter error messages include **remediation instructions** so agents can self-correct.

- `layer_deps.sh` — enforces layer dependency direction
- `structured_logging.sh` — no raw print/console statements
- `naming_conventions.sh` — file and symbol naming rules
- `file_size.sh` — max file/function size limits
- `spec_coverage.sh` — every implementation must trace to a spec

## Agents (6)

| Agent | Role |
|-------|------|
| `spec-writer` | Brainstorming interviewer: collaborates with human to produce specs through Socratic dialogue |
| `implementer` | Writes code satisfying specs, layer by layer |
| `test-writer` | Creates tests derived from spec acceptance criteria |
| `spec-reviewer` | Validates implementation against spec (did we build what the spec says?) |
| `code-reviewer` | Validates code quality and conventions (is the code well-written?) |
| `refactorer` | Prevents technical debt accumulation |

### Two-Stage Review

Review is split into two independent passes:
1. **Spec review** (spec-reviewer) — checks spec compliance: acceptance criteria, business rules, edge cases, data model, API contracts
2. **Code review** (code-reviewer) — checks code quality: architecture, conventions, test quality, linter compliance

Both must pass before a feature is considered complete.

## Agent Instructions

- Before implementing anything, **read the relevant spec** in `specs/`
- Before modifying a file, **read it first**
- **Plan approval is mandatory** — write the execution plan, wait for human approval, then implement
- After writing code, **run the linters**: `bash scripts/lint_all.sh`
- When a linter fails, read the error message — it contains the fix
- Keep PRs small and focused on a single spec item
- Update `docs/` when behavior changes
- Humans write zero application code — they write specs, review, and evolve the harness
