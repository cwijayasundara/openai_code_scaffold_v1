# SDSL Workflow Guide

## Spec-Driven Software Lifecycle

This project follows the SDSL methodology: **Specifications, not prompts or code, are the fundamental unit of work.**

## The Harness Engineer's Role

> Ref: [OpenAI — Harness Engineering](https://openai.com/index/harness-engineering/)

You are a **harness engineer**, not a coder. Your job is to design the environment that makes agents productive. You write zero lines of application code. Instead, you:

### What You Do

1. **Write specs** — Collaborate with the spec-writer agent or fill in `specs/templates/feature_spec.md` manually.
2. **Approve plans** — Review execution plans before implementation begins.
3. **Review output** — Read the agent's code, run `bash scripts/lint_all.sh`, run `make test`.
4. **Evolve the harness** — When agents make mistakes, fix the harness: linter rules, agent instructions, spec templates.

### What You Never Do

- Write application code directly
- Fix bugs by editing `src/` — write a bug-fix spec instead
- Skip review — every agent output gets human review before merge

### Daily Workflow

```
Morning:   Review open PRs, read execution plan updates, check linter/test results
Work:      Write specs → approve plans → invoke agents → review output → iterate
Retro:     Capture review insights as linter rules, doc updates, or agent instruction changes
```

## Workflow Phases

```
SPEC → PLAN → APPROVE → IMPLEMENT → SPEC REVIEW → CODE REVIEW
(collab.)  (agent)  (human)   (agent)     (agent)       (agent)
```

### Phase 1: Write the Spec (Human + spec-writer agent)

The spec-writer agent interviews you to draw out requirements, then drafts the spec section by section for your approval.

```bash
# Option A: Collaborative (recommended)
# Claude Code: "Use the spec-writer agent to brainstorm a spec for [rough idea]"

# Option B: Manual
cp specs/templates/feature_spec.md specs/features/my_feature.md
```

Output: `specs/features/<name>.md`

### Phase 2: Plan (Agent — mandatory, requires human approval)

The agent writes an execution plan. **No implementation begins until you approve the plan.**

```bash
# Claude Code: "Write an execution plan for specs/features/my_feature.md"
# Produces docs/designs/plan-<feature-name>.md with status "draft"
```

The plan includes:
- **Small tasks** (2-5 minutes each) with exact file paths
- **Verification steps** for each task
- **Milestones** grouping related tasks

You review and approve. Status changes from "draft" to "approved".

### Phase 3: Implement (Agent — implementer)

The implementer writes code satisfying the spec, following the approved plan.

```bash
# Claude Code: "Use the implementer agent to implement specs/features/my_feature.md"
```

### Phase 4: Test (Agent — test-writer)

The test-writer creates tests derived from spec acceptance criteria.

```bash
# Claude Code: "Use the test-writer agent to write tests for specs/features/my_feature.md"
```

### Phase 5: Spec Review (Agent — spec-reviewer)

Checks: Did we build what the spec says? Are all acceptance criteria met?

```bash
# Claude Code: "Use the spec-reviewer agent to review my_feature against its spec"
```

### Phase 6: Code Review (Agent — code-reviewer)

Checks: Is the code well-written? Does it follow conventions?

```bash
# Claude Code: "Use the code-reviewer agent to review the implementation of my_feature"
```

### Continuous: Refactoring (Agent — refactorer)

Run periodically to prevent technical debt accumulation.

```bash
# Claude Code: "Use the refactorer agent to scan and fix structural issues"
```

## Feedback Loops — Evolving the Harness

**When something fails, don't "try harder" — ask what capability is missing and make it enforceable.**

| You notice... | You fix... | By... |
|---|---|---|
| Agent violates a convention | Linter rules | Adding a check to `scripts/linters/` |
| Agent misunderstands architecture | Agent instructions | Updating `.claude/agents/*.md` |
| Spec was ambiguous | Spec template | Adding a section to `specs/templates/feature_spec.md` |
| Reviewer catches a pattern | CLAUDE.md or conventions | Encoding the pattern in docs |

**Never fix code directly. Fix the harness that prevents the class of error from recurring.**
