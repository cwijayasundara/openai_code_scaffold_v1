# Architecture Reference

## Problem & Scope

This project is a spec-driven application built with Claude Code agents. It provides a layered
architecture that agents can navigate predictably, with mechanical enforcement of invariants
via linters and hooks. The harness is technology-agnostic in the layers above Types, but ships
with Python/FastAPI defaults.

## Layer Model

This project enforces a strict forward-only dependency model:

```
Types → Config → Repo → Service → Runtime → UI
  0       1       2       3         4       5
```

Each layer has a rank. A file may only import from layers with **equal or lower rank**.

### Types (rank 0) — `src/types/`

- Shared types, enums, constants, schema definitions
- **Imports from**: nothing (standalone)
- **Examples**: `UserType`, `OrderStatus`, `ErrorCode`

### Config (rank 1) — `src/config/`

- Configuration loading, environment variable parsing, defaults
- **Imports from**: Types
- **Examples**: `app_config.py`, `database_config.py`

### Repo (rank 2) — `src/repo/`

- Data access layer: database operations, external API clients, file I/O
- **Imports from**: Types, Config
- **Examples**: `user_repo.py`, `order_repo.py`

### Service (rank 3) — `src/service/`

- Business logic, orchestration, domain rules
- **Imports from**: Types, Config, Repo
- **Examples**: `user_service.py`, `order_service.py`
- **Requirement**: Must reference a spec file (see spec_coverage linter)

### Runtime (rank 4) — `src/runtime/`

- Server bootstrap, middleware, lifecycle management, structured logger
- **Imports from**: Types, Config, Repo, Service
- **Examples**: `server.py`, `middleware.py`, `logger.py`

### UI (rank 5) — `src/ui/`

- Presentation layer: CLI output, API response formatting, user-facing messages
- **Imports from**: all layers
- **Examples**: `cli.py`, `api_routes.py`

## Intentional Constraints

These are deliberate architectural decisions, not oversights:

- **Service has no direct I/O** — all database, HTTP, and filesystem access goes through Repo. Service operates on types only.
- **Types has no project imports** — it depends on the standard library and Pydantic only. This keeps it the stable foundation.
- **No global mutable state** — configuration is loaded once in Config and injected forward. No module-level singletons.
- **No cross-layer type definitions** — a type used by multiple layers must live in Types, not defined inline.
- **No raw primitives for domain concepts** — use refined Pydantic types (e.g., `UserId`, `Email`) instead of bare `str` or `int`. This makes code self-documenting for agents and enforces validation at parse boundaries.

## Invariants

These are enforced mechanically by linters (never by convention alone):

1. **Layer dependencies flow forward only** — enforced by `layer_deps.sh`
2. **Structured logging everywhere** — enforced by `structured_logging.sh`
3. **snake_case files/functions, PascalCase classes** — enforced by `naming_conventions.sh`
4. **Max 300 lines/file, 50 lines/function** — enforced by `file_size.sh`
5. **Every service module traces to a spec** — enforced by `spec_coverage.sh`

## Why These Constraints?

> "While these rules might feel pedantic or constraining in a human-first workflow,
> with agents they become multipliers: once encoded, they apply everywhere at once."

Constraints allow speed without decay. When agents can rely on a consistent, enforced
structure, they can reason about the full business domain directly from the repository.

## Directory Structure

```
├── CLAUDE.md                    # Agent instructions (map, not manual)
├── Makefile                     # Build, lint, test targets
├── Dockerfile                   # Container build
├── pyproject.toml               # Python project config
├── requirements.txt             # Production dependencies
├── requirements-dev.txt         # Dev/test dependencies
├── .env.example                 # Required environment variables
├── specs/
│   ├── templates/               # Spec templates
│   │   ├── feature_spec.md
│   │   ├── design_doc.md
│   │   └── execution_plan.md
│   └── features/                # Active feature specs (source of truth)
├── docs/
│   ├── workflow.md              # SDSL workflow guide
│   ├── architecture.md          # This file
│   ├── conventions.md           # Coding standards and type conventions
│   └── designs/                 # Design docs and execution plans
├── src/
│   ├── types/                   # Layer 0: Types (refined Pydantic models)
│   ├── config/                  # Layer 1: Config
│   ├── repo/                    # Layer 2: Repo (parse boundary)
│   ├── service/                 # Layer 3: Service (operates on types only)
│   ├── runtime/                 # Layer 4: Runtime
│   └── ui/                      # Layer 5: UI
├── tests/                       # Mirrors src/ structure
│   ├── types/
│   ├── config/
│   ├── repo/
│   ├── service/
│   ├── runtime/
│   └── ui/
├── scripts/
│   ├── lint_all.sh              # Master linter runner
│   ├── linters/                 # Custom enforcement linters
│   └── hooks/                   # Claude Code hook scripts
└── .claude/
    ├── settings.json            # Hooks and permissions
    └── agents/                  # Sub-agent definitions
        ├── spec-writer.md
        ├── implementer.md
        ├── reviewer.md
        ├── refactorer.md
        └── test-writer.md
```
