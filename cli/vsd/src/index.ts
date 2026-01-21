#!/usr/bin/env node
import { Command } from 'commander';
import { execa } from 'execa';
import fs from 'node:fs/promises';
import path from 'node:path';
import os from 'node:os';

const NULL_SHA = '0000000000000000000000000000000000000000';

type DiffEntry = {
  oldSha: string;
  newSha: string;
  status: string;
  oldPath: string;
  newPath: string;
};

const program = new Command();
program
  .name('vsd')
  .description('Open git diff in VSCode diff editor')
  .option('--staged', 'Use staged changes (git diff --staged)')
  .option('--exclude <paths...>', 'Exclude paths from diff', [])
  .allowUnknownOption(true)
  .parse(process.argv);

const options = program.opts<{ staged?: boolean; exclude?: string[] }>();
const passthroughArgs = program.args;

async function main(): Promise<void> {
  const { preArgs, pathspecs } = splitArgs(passthroughArgs);
  const excludes = normalizeExcludes(options.exclude ?? []);
  const finalPreArgs = applyStagedFlag(preArgs, options.staged ?? false);
  const finalPathspecs = applyExcludes(pathspecs, excludes);

  const diffArgs = [...finalPreArgs, '--raw', '-z'];
  if (finalPathspecs.length > 0) {
    diffArgs.push('--', ...finalPathspecs);
  }

  const { stdout } = await execa('git', ['diff', ...diffArgs], {
    stdout: 'pipe',
    reject: false
  });

  const entries = parseRawDiff(stdout);
  if (entries.length === 0) {
    console.log('No changes.');
    return;
  }

  const tempDir = await fs.mkdtemp(path.join(os.tmpdir(), 'vsd-'));

  for (let i = 0; i < entries.length; i += 1) {
    const entry = entries[i];
    const leftContent = await readContent(entry.oldSha, entry.oldPath);
    const rightContent = await readContent(entry.newSha, entry.newPath);

    const leftPath = await writeTempFile(
      tempDir,
      `left-${i}-${sanitizePath(entry.oldPath || entry.newPath)}`,
      leftContent
    );
    const rightPath = await writeTempFile(
      tempDir,
      `right-${i}-${sanitizePath(entry.newPath || entry.oldPath)}`,
      rightContent
    );

    await execa('code', ['--diff', leftPath, rightPath], { stdio: 'ignore' });
  }
}

function splitArgs(args: string[]): { preArgs: string[]; pathspecs: string[] } {
  const sepIndex = args.indexOf('--');
  if (sepIndex === -1) {
    return { preArgs: [...args], pathspecs: [] };
  }
  return {
    preArgs: args.slice(0, sepIndex),
    pathspecs: args.slice(sepIndex + 1)
  };
}

function normalizeExcludes(excludes: string[]): string[] {
  return excludes.map((value) => value.trim()).filter((value) => value.length > 0);
}

function applyStagedFlag(args: string[], staged: boolean): string[] {
  if (!staged) {
    return [...args];
  }
  if (args.some((arg) => isStagedFlag(arg))) {
    return [...args];
  }
  return ['--staged', ...args];
}

function isStagedFlag(arg: string): boolean {
  return arg === '--staged' || arg === '--cached' || arg.startsWith('--staged=') || arg.startsWith('--cached=');
}

function applyExcludes(pathspecs: string[], excludes: string[]): string[] {
  if (excludes.length === 0) {
    return [...pathspecs];
  }

  const result = [...pathspecs];
  const hasInclude = result.some((spec) => !spec.startsWith(':(exclude)'));
  if (!hasInclude) {
    result.unshift('.');
  }

  return [
    ...result,
    ...excludes.map((value) => (value.startsWith(':(exclude)') ? value : `:(exclude)${value}`))
  ];
}

function parseRawDiff(raw: string): DiffEntry[] {
  const entries: DiffEntry[] = [];
  const parts = raw.split('\0');
  let index = 0;

  while (index < parts.length) {
    const part = parts[index];
    if (!part) {
      index += 1;
      continue;
    }

    if (!part.startsWith(':')) {
      index += 1;
      continue;
    }

    const tabIndex = part.indexOf('\t');
    if (tabIndex === -1) {
      index += 1;
      continue;
    }

    const meta = part.slice(1, tabIndex);
    const path1 = part.slice(tabIndex + 1);
    const metaParts = meta.split(' ');
    const oldSha = metaParts[2] ?? '';
    const newSha = metaParts[3] ?? '';
    const status = metaParts[4] ?? '';

    let oldPath = path1;
    let newPath = path1;

    if (status.startsWith('R') || status.startsWith('C')) {
      const path2 = parts[index + 1] ?? '';
      newPath = path2;
      index += 2;
    } else {
      index += 1;
    }

    entries.push({
      oldSha,
      newSha,
      status: status[0] ?? status,
      oldPath,
      newPath
    });
  }

  return entries;
}

async function readContent(sha: string, filePath: string): Promise<Buffer> {
  if (!sha || sha === NULL_SHA) {
    return Buffer.alloc(0);
  }

  try {
    const { stdout } = await execa('git', ['cat-file', '-p', sha], { encoding: null });
    return stdout as Buffer;
  } catch {
    return readWorktreeFile(filePath);
  }
}

async function readWorktreeFile(filePath: string): Promise<Buffer> {
  if (!filePath) {
    return Buffer.alloc(0);
  }

  try {
    return await fs.readFile(path.resolve(process.cwd(), filePath));
  } catch {
    return Buffer.alloc(0);
  }
}

async function writeTempFile(dir: string, name: string, content: Buffer): Promise<string> {
  const safeName = sanitizePath(name);
  const filePath = path.join(dir, safeName);
  await fs.writeFile(filePath, content);
  return filePath;
}

function sanitizePath(value: string): string {
  return value.replace(/[^a-zA-Z0-9._-]/g, '_');
}

main().catch((error) => {
  console.error(error instanceof Error ? error.message : String(error));
  process.exitCode = 1;
});
