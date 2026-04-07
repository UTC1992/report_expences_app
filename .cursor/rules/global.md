---
description: Flutter global rules
alwaysApply: true
---

# Global Rules
- Use MVVM + Clean Architecture
- State management with Riverpod
- ...

# Project Rules (Flutter)

1. Required architecture: MVVM + Clean Architecture.
2. Global state management: Riverpod (do not mix with other patterns).
3. Every feature must separate layers: presentation, domain, data.
4. ViewModel handles UI/state; domain handles business rules; data handles APIs/DB.
5. Dependencies must point inward only: presentation -> domain -> data.
6. Consistent naming: snake_case for files, PascalCase for classes, camelCase for variables.
7. No business logic inside widgets.
8. Centralized error handling and clear user-facing messages.
9. New code must include at least tests in domain or viewmodel.
10. Keep rules simple and global; implementation details should be handled with skills.
11. Use TDD for each feature or modification or fix an error, test base on interaction like react testing library philosophy