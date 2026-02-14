# SDSL Workflow Guide

## Spec-Driven Software Lifecycle

This project follows the SDSL methodology: **Specifications, not prompts or code, are the fundamental unit of work.**

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

## Feedback Loops

The key insight from harness engineering: **when something fails, don't "try harder" — ask what capability is missing and make it enforceable.**

- Linter errors → update linter rules + error messages
- Agent mistakes → update CLAUDE.md or sub-agent instructions
- Spec ambiguities → refine the spec template
- Architecture drift → add new structural tests
- Review findings → encode as linter rules

Every human review insight should be captured as either:
1. A documentation update in `docs/`
2. A new linter rule in `scripts/linters/`
3. An update to agent instructions in `.claude/agents/`
