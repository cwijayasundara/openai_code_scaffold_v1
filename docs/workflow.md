# SDSL Workflow Guide

## Spec-Driven Software Lifecycle

This project follows the SDSL methodology: **Specifications, not prompts or code, are the fundamental unit of work.**

## The Harness Engineer's Role

> Ref: [OpenAI — Harness Engineering](https://openai.com/index/harness-engineering/)

You are a **harness engineer**, not a coder. Your job is to design the environment that makes agents productive. You write zero lines of application code. Instead, you:

### What You Do

1. **Write specs** — Copy `specs/templates/feature_spec.md`, fill in every section (data model, API contracts, UI layout, interaction flows, acceptance criteria). The more precise the spec, the better the agent's output.
2. **Orchestrate agents** — Tell Claude Code which agent to use and which spec to implement. You give the instruction; the agent does the work.
3. **Review output** — Read the agent's code, run `bash scripts/lint_all.sh`, run `make test`. Check acceptance criteria against the spec.
4. **Evolve the harness** — When agents make mistakes, don't fix the code. Fix the harness: update linter rules, refine agent instructions, improve spec templates, add conventions to docs.
5. **Manage execution plans** — Read `docs/designs/plan-*.md` to track progress, surprises, and decisions across sessions.

### What You Never Do

- Write application code directly
- Fix bugs by editing `src/` — instead, write a bug-fix spec and let the agent fix it
- Give vague instructions — if you can't spec it precisely, you're not ready to build it
- Skip review — every agent output gets human review before merge

### Daily Workflow

```
Morning:   Review open PRs, read execution plan updates, check linter/test results
Work:      Write specs → invoke agents → review output → iterate
Retro:     Capture review insights as linter rules, doc updates, or agent instruction changes
```

```
┌─────────┐    ┌─────────┐    ┌─────────┐    ┌───────────┐    ┌─────────┐
│  SPEC   │───▶│ DESIGN  │───▶│  PLAN   │───▶│ IMPLEMENT │───▶│ REVIEW  │
│ (human) │    │ (agent) │    │ (agent) │    │  (agent)  │    │ (agent) │
└─────────┘    └─────────┘    └─────────┘    └───────────┘    └─────────┘
     │                                              │               │
     │              ┌──────────┐                    │               │
     └─────────────▶│ REFACTOR │◀───────────────────┘               │
                    │  (agent) │                                    │
                    └──────────┘                                    │
                         ▲                                          │
                         └──────────────────────────────────────────┘
```

## Phase 1: Write the Spec (Human)

The human writes or dictates a feature specification.

```bash
# Create from template
cp specs/templates/feature_spec.md specs/features/my_feature.md
# Edit the spec with your intent
```

**Key**: Be precise about acceptance criteria. Each criterion becomes a test.

## Phase 2: Design (Agent — spec-writer)

The spec-writer agent can help refine rough ideas into structured specs, or the implementer agent can produce a design doc.

```bash
# Use the spec-writer sub-agent
# Claude Code: "Use the spec-writer agent to create a spec for [feature]"
```

Output: `specs/features/<name>.md` and optionally `docs/designs/<name>.md`

## Phase 3: Plan (Agent)

Create an execution plan — a living document updated during implementation.

```bash
# Create from template
cp specs/templates/execution_plan.md docs/designs/plan-<feature-name>.md
# Fill in: purpose, context, concrete steps, milestones, acceptance criteria
# Update during implementation: progress, surprises, decisions
```

The execution plan captures the *trace* of implementation — not just what to do, but what happened, what was learned, and how to prove it worked.

## Phase 4: Implement (Agent — implementer)

The implementer agent writes code satisfying the spec.

```bash
# Use the implementer sub-agent
# Claude Code: "Use the implementer agent to implement specs/features/my_feature.md"
```

**Enforcement**: Post-write hooks automatically run linters after every file change.

## Phase 5: Test (Agent — test-writer)

The test-writer agent creates tests derived from spec acceptance criteria.

```bash
# Use the test-writer sub-agent
# Claude Code: "Use the test-writer agent to write tests for specs/features/my_feature.md"
```

## Phase 6: Review (Agent — reviewer)

The reviewer agent validates implementation against the spec.

```bash
# Use the reviewer sub-agent
# Claude Code: "Use the reviewer agent to review the implementation of my_feature"
```

## Phase 7: Continuous Refactoring (Agent — refactorer)

Run periodically to prevent technical debt accumulation.

```bash
# Use the refactorer sub-agent
# Claude Code: "Use the refactorer agent to scan and fix structural issues"
```

## Feedback Loops — Evolving the Harness

The key insight from [harness engineering](https://openai.com/index/harness-engineering/): **when something fails, don't "try harder" — ask what capability is missing and make it enforceable.**

### Triggers and Actions

| You notice... | You fix... | By... |
|---|---|---|
| Agent writes code that violates a convention | Linter rules | Adding a check to `scripts/linters/` |
| Agent misunderstands architecture | Agent instructions | Updating `.claude/agents/*.md` |
| Spec was ambiguous, agent guessed wrong | Spec template | Adding a section to `specs/templates/feature_spec.md` |
| Architecture drifts from the layer model | Structural tests | Adding assertions to the layer_deps linter |
| Reviewer catches a pattern of issues | CLAUDE.md or conventions | Encoding the pattern in docs |
| Agent produces low-quality output repeatedly | Golden principles | Adding opinionated rules to `docs/conventions.md` |

### The Rule

Every human review insight must be captured as one of:
1. A documentation update in `docs/`
2. A new or refined linter rule in `scripts/linters/`
3. An update to agent instructions in `.claude/agents/`

**Never fix code directly. Fix the harness that prevents the class of error from recurring.**
