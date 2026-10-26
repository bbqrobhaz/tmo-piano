# TMO Piano

The sampled grand piano used by The Maestro Online's widgets, served from GitHub Pages:
https://bbqrobhaz.github.io/tmo-piano/

- `piano/tmo-piano.js` — one-file ES module (`import { Piano } from '.../piano/tmo-piano.js'`)
- `audio/` — Salamander Grand Piano V3 samples (mp3 + ogg, 16 velocity layers)

Everything is built by `build.sh` on each push (see `.github/workflows/pages.yml`).
Credits and licences: `site/CREDITS.md` — samples CC BY 3.0 (Alexander Holm); code MIT (Yotam Mann).
