---
description: Reglas globales Flutter
alwaysApply: true
---

# Reglas globales
- Usar MVVM + Clean Architecture
- Estado con Riverpod
- ...

# Project Rules (Flutter)

1. Arquitectura obligatoria: MVVM + Clean Architecture.
2. Estado global: Riverpod (no mezclar con otros patrones).
3. Toda feature debe separar capas: presentation, domain, data.
4. ViewModel maneja estado/UI; domain maneja reglas de negocio; data maneja APIs/DB.
5. Dependencias solo hacia adentro: presentation -> domain -> data.
6. Naming consistente: snake_case archivos, PascalCase clases, camelCase variables.
7. No lógica de negocio en widgets.
8. Manejo de errores centralizado y mensajes claros para el usuario.
9. Código nuevo debe incluir al menos pruebas en domain o viewmodel.
10. Mantener reglas simples y globales; detalles de implementación se resuelven con skills.