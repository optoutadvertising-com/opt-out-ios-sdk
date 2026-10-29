## Changelog

### 3.0.1

- Fixed a crash when several ads were loaded at the same time.
- `initialize` and `enableGPSServices` now run on the main actor. Callers on the main thread need no changes; from other async contexts, call them with `await`.
