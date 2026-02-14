# SDSL Project — Claude Code Harness

A minimal, spec-driven harness for building software with Claude Code agents.

> **Philosophy**: Humans steer. Agents execute.
> Specifications are the fundamental unit of work. Humans write specs and review. Agents do everything else.

## What's Included

- **CLAUDE.md** — Concise map pointing to detailed docs
- **3 hooks** — Pre-write checks, post-write linting, spec enforcement
- **6 agents** — Specialized sub-agents for specs, implementation, testing, review, and refactoring
- **5 custom linters** — Layer deps, naming, file size, logging, spec coverage
- **Spec templates** — Feature spec, design doc, execution plan
- **Infrastructure** — Makefile, Dockerfile, pyproject.toml pre-configured

## Stack

- **Backend**: Python 3.12 / FastAPI
- **Layer Architecture**: Types → Config → Repo → Service → Runtime → UI
- **Coverage**: Mechanically enforced at 80% minimum

## Your Role: Harness Engineer

> Inspired by [OpenAI — Harness Engineering](https://openai.com/index/harness-engineering/)

You are a **harness engineer**. You write zero lines of application code. Your job:

1. **Write specs** — Collaborate with the spec-writer agent or fill in `.claude/templates/feature_spec.md`
2. **Approve plans** — Review execution plans before implementation begins
3. **Review output** — Run linters, run tests, check acceptance criteria
4. **Evolve the harness** — When agents make mistakes, fix linter rules / agent instructions / spec templates — not code

See [.claude/docs/workflow.md](.claude/docs/workflow.md) for the full orchestration guide.

## Workflow

```
SPEC (collaborative) → PLAN (agent) → APPROVE (human) → IMPLEMENT (agent) → SPEC REVIEW + CODE REVIEW (agent)
```

## Quickstart

```bash
# 1. Clone and enter
git clone <this-repo> my-project
cd my-project

# 2. Install dependencies
pip install -r requirements-dev.txt

# 3. Write a feature spec
cp .claude/templates/feature_spec.md specs/features/my-feature.md

# 4. Implement via Claude Code agents
# Use the implementer agent to generate code from specs

# 5. Run linters and tests
bash .claude/lint_all.sh
make test
```

## Project Structure

```
.claude/                # All framework scaffolding
  agents/               # 6 sub-agents
  docs/                 # Framework docs (workflow, architecture, conventions)
  hooks/                # 3 automated hooks
  linters/              # 5 custom linter scripts
  templates/            # feature_spec.md, design_doc.md, execution_plan.md
  lint_all.sh           # Master linter runner
  settings.json         # Hook wiring + permissions
specs/
  features/             # Feature specs (project content, source of truth)
src/
  types/ config/ repo/ service/ runtime/ ui/
tests/                  # Mirrors src/ structure
```

## Agents

| Agent | Role |
|-------|------|
| `spec-writer` | Brainstorming interviewer: collaborates with human to produce specs |
| `implementer` | Spec-driven code with layer rules |
| `test-writer` | Test generation and coverage |
| `spec-reviewer` | Validates implementation against spec (spec compliance) |
| `code-reviewer` | Validates code quality and conventions |
| `refactorer` | Continuous debt reduction |

## Custom Linters

Run all linters: `bash .claude/lint_all.sh`

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
