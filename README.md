# SDSL Project — Claude Code Harness

A minimal, spec-driven harness for building software with Claude Code agents.

> **Philosophy**: Humans steer. Agents execute.
> Specifications are the fundamental unit of work. Humans write specs and review. Agents do everything else.

## What's Included

- **CLAUDE.md** — Concise map pointing to detailed docs
- **3 hooks** — Pre-write checks, post-write linting, spec enforcement
- **5 agents** — Specialized sub-agents for specs, implementation, testing, review, and refactoring
- **5 custom linters** — Layer deps, naming, file size, logging, spec coverage
- **Spec templates** — Feature spec, design doc, execution plan
- **Infrastructure** — Makefile, Dockerfile, pyproject.toml pre-configured

## Stack

- **Backend**: Python 3.12 / FastAPI
- **Layer Architecture**: Types → Config → Repo → Service → Runtime → UI
- **Coverage**: Mechanically enforced at 80% minimum

## Workflow

```
SPEC (human) → DESIGN (agent) → PLAN (agent) → IMPLEMENT (agent) → REVIEW (agent)
```

See [docs/workflow.md](docs/workflow.md) for the full workflow guide.

## Quickstart

```bash
# 1. Clone and enter
git clone <this-repo> my-project
cd my-project

# 2. Install dependencies
pip install -r requirements-dev.txt

# 3. Write a feature spec
cp specs/templates/feature_spec.md specs/features/my-feature.md

# 4. Implement via Claude Code agents
# Use the implementer agent to generate code from specs

# 5. Run linters and tests
bash scripts/lint_all.sh
make test
```

## Project Structure

```
.claude/
  agents/         # 5 sub-agents (spec-writer, implementer, test-writer, reviewer, refactorer)
  settings.json   # Hook wiring + permissions
scripts/
  hooks/          # 3 automated hooks
  linters/        # 5 custom linter scripts
  lint_all.sh     # Master linter runner
specs/
  templates/      # feature_spec.md, design_doc.md, execution_plan.md
  features/       # Feature specs (source of truth)
docs/
  architecture.md # Layer model, intentional constraints, testing strategy
  workflow.md     # Full SDSL workflow guide
  conventions.md  # Coding standards and type conventions
src/
  types/          # Shared types and schemas
  config/         # Configuration
  repo/           # Data access layer
  service/        # Business logic
  runtime/        # Server bootstrap
  ui/             # Presentation layer
tests/            # Mirrors src/ structure
```

## Agents

| Agent | Role |
|-------|------|
| `spec-writer` | Intent → structured specs |
| `implementer` | Spec-driven code with layer rules |
| `test-writer` | Test generation and coverage |
| `reviewer` | Spec compliance and quality review |
| `refactorer` | Continuous debt reduction |

## Custom Linters

Run all linters: `bash scripts/lint_all.sh`

| Linter | Enforces |
|--------|----------|
| `layer_deps` | Forward-only layer imports |
| `structured_logging` | No raw print/console |
| `naming_conventions` | snake_case/PascalCase rules |
| `file_size` | 300-line file / 50-line function limits |
| `spec_coverage` | Service modules trace to specs |

All linters produce actionable error messages with remediation instructions.

## Key Principles

- **No manual code** — All code is agent-generated from specs
- **Mechanical enforcement** — Linters and hooks enforce invariants, not conventions
- **Parse don't validate** — Refined Pydantic types at boundaries, no raw `str`/`int` for domain concepts
- **Forward-only dependencies** — Code may only depend forward through layers (enforced by `layer_deps`)
- **Fix the harness, not the code** — When something fails, fix the linter/agent/doc to prevent recurrence

## License

MIT
