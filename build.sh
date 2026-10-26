#!/usr/bin/env bash
# Builds the TMO Piano site into ./dist:
#  - Salamander Grand Piano samples (CC BY 3.0, Alexander Holm) from Tone Piano, pinned commit
#  - one-file ES module of @tonejs/piano 0.2.1 + Tone.js 14.9.17 (MIT)
set -euo pipefail
SAMPLES_REPO=https://github.com/tambien/Piano.git
SAMPLES_SHA=0cd2c034f820c53e83ab22f5c13bd490b9e4de85
rm -rf dist work && mkdir -p dist/piano work/tambien
git -C work/tambien init -q
git -C work/tambien remote add origin "$SAMPLES_REPO"
git -C work/tambien fetch -q --depth 1 origin "$SAMPLES_SHA"
git -C work/tambien checkout -q FETCH_HEAD
cp -r work/tambien/audio dist/audio
cp work/tambien/LICENSE.md dist/LICENSE-tone-piano.md
cd work
npm init -y >/dev/null
npm install --no-audit --no-fund @tonejs/piano@0.2.1 tone@14.9.17 esbuild@0.24.0 >/dev/null
cp node_modules/tone/build/Tone.js tone-umd.cjs
cp node_modules/tone/build/Tone.js.LICENSE.txt ../dist/LICENSE-tone-bundled-notices.txt
cp node_modules/tone/LICENSE.md ../dist/LICENSE-tone.md
cat > tone-shim.js <<'JS'
import * as T from './tone-umd.cjs';
export const { Frequency, Gain, Midi, Sampler, ToneAudioBuffers, ToneAudioNode, ToneBufferSource, Volume, intervalToFrequencyRatio, isString, optionsFromArguments } = T;
JS
echo "export { Piano } from './node_modules/@tonejs/piano/build/piano/Piano.js';" > entry.js
npx esbuild entry.js --bundle --format=esm --minify --target=es2018 --legal-comments=eof --alias:tone=./tone-shim.js --outfile=../dist/piano/tmo-piano.js
cd ..
cp site/* dist/
touch dist/.nojekyll
echo "Built: $(find dist -type f | wc -l) files"
