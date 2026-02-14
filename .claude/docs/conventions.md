# Coding Conventions

## Python

### Naming
- **Files**: `snake_case.py` (e.g., `user_service.py`)
- **Functions**: `snake_case` (e.g., `create_user`)
- **Classes**: `PascalCase` (e.g., `UserService`)
- **Constants**: `UPPER_SNAKE_CASE` (e.g., `MAX_RETRIES`)
- **Private**: prefix with `_` (e.g., `_validate_email`)

### Types — Parse, Don't Validate
- All function signatures must have type annotations
- No `Any` type — use specific types or Generics
- **Use refined types for domain concepts** — `UserId` not `int`, `Email` not `str`
- Push validation to boundaries (Repo layer); after parsing, types carry the proof
- Use `NewType` for simple wrappers, `BaseModel` for structured data

```python
from typing import NewType
from pydantic import BaseModel, EmailStr, Field

UserId = NewType("UserId", int)

class UserCreate(BaseModel):
    email: EmailStr
    display_name: str = Field(min_length=1, max_length=100)
```

### Logging
```python
import logging
logger = logging.getLogger(__name__)

logger.info("User created: email=%s", user.email)
logger.error("Failed to connect", exc_info=True)
```
Never use `print()` in production code.

### Error Handling
```python
try:
    response = await client.get(url, timeout=10)
    response.raise_for_status()
except httpx.HTTPError as e:
    logger.error("API call failed: url=%s", url, exc_info=e)
    raise ServiceError(f"External API unavailable: {url}") from e
```
- Catch specific exceptions, never bare `except:`
- Always log with context before re-raising
- Use custom exception classes from `src/types/`

### Imports
```python
# 1. Standard library
import logging
from pathlib import Path

# 2. Third-party
from fastapi import APIRouter
from pydantic import BaseModel

# 3. Project (layer order)
from src.types.user import UserCreate
from src.config.settings import Settings
```

## File Size Limits

| Metric | Limit | Warning |
|--------|-------|---------|
| Lines per file | 300 | 250 |
| Lines per function | 50 | 40 |

When a file exceeds limits, split into focused modules following the layer model.

## Git Workflow

- Feature branches: `feature/<feature-name>`
- Commit messages: imperative mood, reference spec
- One logical change per commit
- PR required for all merges to main

## Secrets

- Never hardcode API keys, passwords, tokens, or credentials
- Use environment variables loaded through `src/config/`
- Store development values in `.env` (gitignored)
- Document required variables in `.env.example`

## Test Coverage

- Every service function needs a corresponding test
- Tests live in `tests/` mirroring `src/`
- Minimum 80% coverage enforced via `--cov-fail-under=80`
- Each test must trace back to a spec acceptance criterion
