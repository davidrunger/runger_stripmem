## Unreleased
- [index.erb] Bust cache via version query strings for asset requests.

## v1.0.0 (2026-09-23)
- **BREAKING:** Include swap usage (not just RAM usage). This is a breaking change, because, due to how this functionality is implemented, `runger_stripmem` now only works on Linux.

## v0.1.4 (2026-09-23)
- Ignore any Puma config (e.g. `config/puma.rb`) in the current directory.

## v0.1.3 (2026-09-23)
- Explicitly define `StripMem` module to (hopefully really) fix "uninitialized constant StripMem" `NameError`.

## v0.1.2 (2026-09-23)
- Fix "uninitialized constant StripMem" `NameError`.

## v0.1.1 (2026-09-23)
- Release via RubyGems.

## v0.1.0 (2026-09-22)
- Release as `runger_stripmem` gem.
