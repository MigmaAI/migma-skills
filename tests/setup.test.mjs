import assert from 'node:assert/strict';
import { cpSync, mkdirSync, mkdtempSync, readFileSync, rmSync, writeFileSync } from 'node:fs';
import { tmpdir } from 'node:os';
import path from 'node:path';
import { spawnSync } from 'node:child_process';
import { fileURLToPath } from 'node:url';
import { test } from 'node:test';

const pluginDir = fileURLToPath(new URL('../', import.meta.url));

function fixture(t) {
  const root = mkdtempSync(path.join(tmpdir(), 'migma bundled setup '));
  t.after(() => rmSync(root, { recursive: true, force: true }));
  const checkout = path.join(root, 'plugin checkout');
  const bin = path.join(root, 'bin');
  const log = path.join(root, 'calls.log');
  mkdirSync(checkout);
  mkdirSync(bin);
  mkdirSync(path.join(checkout, 'skills'));
  for (const file of ['setup.sh', 'install.sh', 'install-cli.sh']) {
    cpSync(path.join(pluginDir, file), path.join(checkout, file));
  }
  for (const command of ['npm', 'npx']) {
    writeFileSync(path.join(bin, command), `#!/bin/sh
printf '%s\\n' "\${0##*/}" "$@" >> "$MIGMA_TEST_LOG"
if [ "$MIGMA_TEST_FAIL" = "\${0##*/}" ]; then exit 17; fi
`, { mode: 0o755 });
  }
  return {
    checkout,
    log,
    run(script = 'setup.sh', overrides = {}) {
      return spawnSync('/bin/sh', [path.join(checkout, script)], {
        cwd: root,
        encoding: 'utf8',
        env: {
          PATH: `${bin}:/usr/bin:/bin`,
          MIGMA_TEST_LOG: log,
          MIGMA_TEST_FAIL: '',
          MIGMA_INSTALL_DRY_RUN: '0',
          ...overrides,
        },
      });
    },
    calls() {
      try { return readFileSync(log, 'utf8').trim().split('\n'); }
      catch (error) { if (error.code === 'ENOENT') return []; throw error; }
    },
  };
}

const cliArgs = ['npm', 'install', '-g', '@migma/cli@latest'];
const skillsArgs = (checkout) => ['npx', '--yes', 'skills', 'add', '--all', '--global', '--yes', checkout];

test('setup runs bundled installers in order from another cwd, including paths with spaces', (t) => {
  const f = fixture(t);
  const result = f.run('setup.sh', {
    MIGMA_INSTALL_BASE_URL: 'https://invalid.example',
    MIGMA_CLI_INSTALL_URL: 'https://invalid.example/cli',
    MIGMA_SKILLS_INSTALL_URL: 'https://invalid.example/skills',
  });
  assert.equal(result.status, 0, result.stderr);
  assert.deepEqual(f.calls(), [...cliArgs, ...skillsArgs(f.checkout)]);
});

test('CLI failure stops setup before skills installation', (t) => {
  const f = fixture(t);
  assert.equal(f.run('setup.sh', { MIGMA_TEST_FAIL: 'npm' }).status, 17);
  assert.deepEqual(f.calls(), cliArgs);
});

test('skills failure propagates through setup', (t) => {
  const f = fixture(t);
  assert.equal(f.run('setup.sh', { MIGMA_TEST_FAIL: 'npx' }).status, 17);
  assert.deepEqual(f.calls(), [...cliArgs, ...skillsArgs(f.checkout)]);
});

test('incomplete checkout fails before any install', (t) => {
  for (const missing of ['install-cli.sh', 'install.sh', 'skills']) {
    const f = fixture(t);
    rmSync(path.join(f.checkout, missing), { recursive: true });
    assert.notEqual(f.run().status, 0, missing);
    assert.deepEqual(f.calls(), [], missing);
  }
});

test('dry run executes no package-manager commands', (t) => {
  const f = fixture(t);
  const result = f.run('setup.sh', { MIGMA_INSTALL_DRY_RUN: '1' });
  assert.equal(result.status, 0, result.stderr);
  assert.match(result.stdout, /Dry run: npm install -g @migma\/cli@latest/);
  assert.ok(result.stdout.includes(`Dry run: install bundled skills from ${f.checkout}`));
  assert.deepEqual(f.calls(), []);
});

test('standalone skills installer uses only the bundled checkout', (t) => {
  const f = fixture(t);
  assert.equal(f.run('install.sh').status, 0);
  assert.deepEqual(f.calls(), skillsArgs(f.checkout));
  rmSync(path.join(f.checkout, 'skills'), { recursive: true });
  assert.notEqual(f.run('install.sh').status, 0);
  assert.deepEqual(f.calls(), skillsArgs(f.checkout));
});
