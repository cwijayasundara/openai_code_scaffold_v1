# SDSL Project — Claude Code Harness

A minimal, spec-driven harness for scaffolding new projects with Claude Code agents.

> **Philosophy**: Humans steer. Agents execute.
> Specifications are the fundamental unit of work. Humans write specs and review. Agents do everything else.

## Quickstart

```bash
# 1. Clone the scaffold
git clone https://github.com/cwijayasundara/openai_code_scaffold_v1.git my-project
cd my-project

# 2. Remove the scaffold's git history — start fresh
rm -rf .git
git init
git add -A
git commit -m "Initial commit: SDSL harness scaffold"

# 3. Install dependencies
pip install -r requirements-dev.txt

# 4. Write your first feature spec
cp .claude/templates/feature_spec.md specs/features/my-feature.md

# 5. Implement via Claude Code agents
# Use the implementer agent to generate code from specs

# 6. Run linters
bash .claude/lint_all.sh
```

## What's Included

- **CLAUDE.md** — Concise map pointing to detailed docs
- **2 hooks** — Pre-write plan approval gate, post-write linting
- **3 agents** — Spec-writer, implementer, reviewer
- **3 custom linters** — Layer deps, naming, spec coverage
- **Templates** — Feature spec, execution plan
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

See [.claude/docs/workflow.md](.claude/docs/workflow.md) for the full guide.

## Workflow

```
SPEC (collaborative) → PLAN (agent) → APPROVE (human) → IMPLEMENT (agent) → REVIEW (agent)
```

## Project Structure

```
.claude/                # All framework scaffolding
  agents/               # 3 sub-agents
  docs/                 # Framework docs (workflow, architecture, conventions)
  hooks/                # 2 automated hooks
  linters/              # 3 custom linter scripts
  templates/            # feature_spec.md, execution_plan.md
  lint_all.sh           # Master linter runner
  settings.json         # Hook wiring + permissions
specs/
  features/             # Feature specs (source of truth)
  plans/                # Execution plans (must be Approved)
src/
  types/ config/ repo/ service/ runtime/ ui/
tests/                  # Mirrors src/ structure
```

## Agents

| Agent | Role |
|-------|------|
| `spec-writer` | Interviews human to produce specs through Socratic dialogue |
| `implementer` | Writes code satisfying specs, layer by layer |
| `reviewer` | Checks spec compliance and code quality |

## Custom Linters

Run all: `bash .claude/lint_all.sh`

| Linter | Enforces |
|--------|----------|
| `layer_deps` | Forward-only layer imports |
| `naming_conventions` | snake_case/PascalCase rules |
| `spec_coverage` | Service modules trace to specs |

All linters produce actionable error messages with remediation instructions.

## Key Principles

- **No manual code** — All code is agent-generated from specs
- **Mechanical enforcement** — Linters and hooks enforce invariants, not conventions
- **Parse don't validate** — Refined Pydantic types at boundaries, no raw `str`/`int` for domain concepts
- **Forward-only dependencies** — Code may only depend forward through layers
- **Fix the harness, not the code** — When something fails, fix the linter/agent/doc to prevent recurrence

## License

MIT
