# Git Workflow

## Branch Strategy

Every feature gets its own branch. Never commit directly to `main`.

```
main
 └── feature/<spec-name>
```

## Feature Branch Lifecycle

### 1. Create the branch

After the execution plan is approved:

```bash
git checkout -b feature/<spec-name> main
```

### 2. Work on the branch

Commit frequently with meaningful messages:

```bash
git commit -m "feat: add ExampleId type and ExampleStatus enum"
git commit -m "test: add unit tests for ExampleService"
```

### 3. Keep current

```bash
git fetch origin && git rebase origin/main
```

### 4. Review and merge

After both reviews pass (spec-reviewer + code-reviewer):

```bash
# Team projects: create a PR
gh pr create --title "feat: implement <spec-name>" --body "Spec: specs/features/<spec-name>.md"

# Solo projects: merge directly
git checkout main && git merge --no-ff feature/<spec-name> && git branch -d feature/<spec-name>
```

## Git Worktrees (for parallel features)

When working on independent features simultaneously:

```bash
git worktree add ../project-feature-auth feature/auth
cd ../project-feature-auth
# ... implement ...
git worktree remove ../project-feature-auth
```

Use worktrees when features are independent. Use sequential branches when features depend on each other.

## Commit Message Convention

```
<type>: <short description in imperative mood>

Spec: specs/features/<name>.md
```

Types: `feat`, `fix`, `refactor`, `test`, `docs`, `chore`
