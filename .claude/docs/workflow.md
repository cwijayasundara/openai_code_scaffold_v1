# SDSL Workflow Guide

## The Harness Engineer's Role

> Ref: [OpenAI — Harness Engineering](https://openai.com/index/harness-engineering/)

You are a **harness engineer**. You write zero application code. Instead:

1. **Write specs** — Collaborate with the spec-writer agent or fill in `.claude/templates/feature_spec.md`
2. **Approve plans** — Review execution plans before implementation begins
3. **Review output** — Read the agent's code, run `bash .claude/lint_all.sh`
4. **Evolve the harness** — When agents make mistakes, fix linter rules, agent instructions, or templates

## Workflow Phases

```
SPEC (collaborative) → PLAN (agent) → APPROVE (human) → IMPLEMENT (agent) → REVIEW (agent)
```

### Phase 1: Write the Spec (Human + spec-writer agent)

The spec-writer interviews you to draw out requirements, then drafts the spec for your approval.

```bash
# Option A: Collaborative (recommended)
# Claude Code: "Use the spec-writer agent to brainstorm a spec for [rough idea]"

# Option B: Manual
cp .claude/templates/feature_spec.md specs/features/my_feature.md
```

Output: `specs/features/<name>.md`

### Phase 2: Plan (Agent — requires human approval)

The agent writes an execution plan. **No implementation begins until the human approves.**

```bash
# Claude Code: "Write an execution plan for specs/features/my_feature.md"
```

Plans live at: `specs/plans/<feature-name>.md`

You review and approve by changing Status to "**Approved**".

> **Enforcement**: The pre-write hook blocks ALL writes to `src/` unless an approved plan exists.

### Phase 3: Implement (Agent — implementer)

```bash
# Claude Code: "Use the implementer agent to implement specs/features/my_feature.md"
```

The implementer writes code and tests following the approved plan.

### Phase 4: Review (Agent — reviewer)

Checks both spec compliance and code quality in a single pass.

```bash
# Claude Code: "Use the reviewer agent to review my_feature"
```

## Feedback Loops

**When something fails, don't "try harder" — fix the harness.**

| You notice... | You fix... | By... |
|---|---|---|
| Agent violates a convention | Linter rules | Adding a check to `.claude/linters/` |
| Agent misunderstands architecture | Agent instructions | Updating `.claude/agents/*.md` |
| Spec was ambiguous | Spec template | Adding a section to `.claude/templates/feature_spec.md` |
| Reviewer catches a pattern | CLAUDE.md or conventions | Encoding the pattern in docs |
