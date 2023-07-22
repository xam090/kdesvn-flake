# kdesvn Nix flake!
See:
- https://apps.kde.org/de/kdesvn/
- https://invent.kde.org/sdk/kdesvn

**Usage:**
```
(builtins.getFlake "github:xam090/kdesvn-flake/{commit-hash}").packages.x86_64-linux.default
```