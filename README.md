# zedra-sovereign

A small public repo holding an **agentic lens experiment** plus notes and
helper scripts around [zedra](https://github.com/tanlethanh/zedra) (the
phone-side Zed agent). It is **not** a zedra mirror — no Rust source lives
here — and the helper scripts only work on the author's own machine
(see "Machine-local scripts").

## What's actually in here

### Agentic lens layer (Node.js)

`lib/lens-orchestrator.js` (`v2.0.0-agentic`) auto-discovers `lens_*.js`
modules from `src/_11ty/lenses/` and runs them against content. Each lens
exports `{ name, description, analyze(content, meta) }`.

| Lens | Description |
|---|---|
| `tectonic` | Repository health scoring and drift detection |
| `stylometric` | Linguistic fingerprinting and authorship attribution |
| `osint` | Infrastructure reconnaissance and digital forensics |
| `cryptographic` | Cryptographic artifact detection and entropy analysis |

```js
const { LensOrchestrator } = require('./lib/lens-orchestrator');
const orch = new LensOrchestrator();          // or { lensDir: '...' }
await orch.discover();                        // finds lens_*.js
const all = await orch.analyzeAll(content);   // run every lens
const one = await orch.analyze('tectonic', content, { lastPush, repo });
```

### CI

- **Agentic Lens-First CI** (`.github/workflows/agentic-lens-ci.yml`) — runs
  on push to `main`, PRs, and manually. Discovers the lenses and runs the
  perception pipeline (bun if `package.json` exists, node fallback).
- **Tectonic Drift Detection** (`.github/workflows/tectonic-drift.yml`) —
  daily cron (`0 6 * * *` UTC) plus manual runs. Scores repository health via
  the tectonic lens and fails the run if the health score drops below the
  threshold (default 50). Note: the workflow currently targets the
  `effusion-labs` repo by name.

### Configuration

`.env.example` documents the knobs: `LENS_ENABLED`, `LENS_SWARM_CONCURRENCY`,
`SWARM_MAX_CONCURRENCY`, `SWARM_TIMEOUT_MS`, `LENS_AUTO_COMMIT`, and
`ZEDRA_DAEMON_HOST` (default `localhost:17357`). Never hardcode secrets —
inject via env or a vault.

### Machine-local scripts (awrawr-pc only)

These hardcode `/home/toxic/...` paths and will **not** work for anyone else:

- `check-zedra-host.sh` — `cd`s into `/home/toxic/projects/zedra-tanlethanh`
  and runs `cargo check -p zedra-host`.
- `fetch-vendor.sh` — clones the `tanlethanh/zed` fork (`feat/gpui-mobile`
  branch, pinned commit) into `vendor/zed` under that same local path.

### AUDIT.md

A 2026-07-20 audit of `tanlethanh/zedra`: a mobile GPUI app (Android/iOS) plus
a Linux/macOS/Windows host daemon (`zedra-host`) relaying editor/terminal/
git/AI over an e2e-encrypted iroh P2P tunnel. It maps the crate layout and
notes that the daemon's `AiPrompt` RPC can be pointed at a wrapper calling
the local sovereign router (`:25104`) — that wrapper lives on the author's
machine (`~/.local/bin/zedra-ai-wrapper.sh`), not in this repo.

## What this repo is not

- Not a mirror of zedra: there is no Rust, no GPUI, no `Cargo.toml` here.
- No host daemon ships in this tree.
- The `:25104` binding mentioned in `AUDIT.md` refers to a machine-local
  wrapper, not to anything in this repo.
