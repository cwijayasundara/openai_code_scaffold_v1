# Coding Conventions

## Naming
- **Files**: `snake_case.py` (e.g., `user_service.py`)
- **Functions**: `snake_case` (e.g., `create_user`)
- **Classes**: `PascalCase` (e.g., `UserService`)
- **Constants**: `UPPER_SNAKE_CASE` (e.g., `MAX_RETRIES`)
- **Private**: prefix with `_` (e.g., `_validate_email`)

## Types — Parse, Don't Validate
- All function signatures must have type annotations
- No `Any` type — use specific types or Generics
- **Use refined types for domain concepts** — `UserId` not `int`, `Email` not `str`
- Push validation to boundaries (Repo layer); after parsing, types carry the proof

```python
from typing import NewType
from pydantic import BaseModel, EmailStr, Field

UserId = NewType("UserId", int)

class UserCreate(BaseModel):
    email: EmailStr
    display_name: str = Field(min_length=1, max_length=100)
```

## Error Handling
- Catch specific exceptions, never bare `except:`
- Log with context before re-raising
- Use custom exception classes from `src/types/`

## Imports
```python
# 1. Standard library
# 2. Third-party
# 3. Project (layer order)
from src.types.user import UserCreate
from src.config.settings import Settings
```

## Secrets
- Never hardcode API keys, passwords, tokens, or credentials
- Use environment variables loaded through `src/config/`
- Document required variables in `.env.example`

## Git
- Feature branches: `feature/<feature-name>`
- Commit messages: imperative mood, reference spec
- One logical change per commit

## Tests
- Every service function needs a corresponding test
- Tests live in `tests/` mirroring `src/`
- Minimum 80% coverage
