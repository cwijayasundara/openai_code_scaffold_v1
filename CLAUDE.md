# SDSL Project — Claude Code Harness

> **Philosophy**: Humans steer. Agents execute.
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

## Workflow: Spec → Design → Plan → Implement → Review

1. **Write a spec** — use `specs/templates/feature_spec.md` as a starting point
2. **Design** — produce a design doc in `docs/designs/` referencing the spec
3. **Plan** — break the design into implementation tasks
4. **Implement** — execute tasks using Claude Code agents
5. **Review** — validate against the spec, run linters and tests

See `docs/workflow.md` for the full workflow guide.

## Conventions

- **Structured logging only** — use the project logger, never raw print/console
- **Naming**: `snake_case` for files and functions, `PascalCase` for classes/types
- **Max file size**: 300 lines. If a file exceeds this, split it.
- **Max function size**: 50 lines. Extract helpers if needed.
- **Types**: Refined Pydantic types for domain concepts — no raw `str`/`int` for IDs, emails, etc.
- **Tests**: Every service function needs a test in `tests/` mirroring `src/`. Coverage minimum: 80%.
- **No manual code**: All code is agent-generated from specs. Humans write specs and review.

Details: [docs/conventions.md](docs/conventions.md)

## Key Files

| File | Purpose |
|------|---------|
| `specs/` | Feature specifications (source of truth for intent) |
| `docs/workflow.md` | Full SDSL workflow guide |
| `docs/architecture.md` | Detailed architecture reference |
| `docs/conventions.md` | Coding standards and type conventions |
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

## Agent Instructions

- Before implementing anything, **read the relevant spec** in `specs/`
- Before modifying a file, **read it first**
- After writing code, **run the linters**: `bash scripts/lint_all.sh`
- When a linter fails, read the error message — it contains the fix
- Keep PRs small and focused on a single spec item
- Update `docs/` when behavior changes
