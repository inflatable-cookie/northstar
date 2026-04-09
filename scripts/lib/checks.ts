import { existsSync, readFileSync } from "node:fs";
import path from "node:path";

function fail(message: string): never {
  console.error(message);
  process.exit(1);
}

function readText(repoRoot: string, file: string): string {
  const fullPath = path.join(repoRoot, file);
  if (!existsSync(fullPath)) {
    fail(`missing required file: ${file}`);
  }

  return readFileSync(fullPath, "utf8");
}

export function repoRootFrom(scriptDir: string): string {
  return path.resolve(scriptDir, "..");
}

export function requireFile(repoRoot: string, file: string): void {
  const fullPath = path.join(repoRoot, file);
  if (!existsSync(fullPath)) {
    fail(`missing required file: ${file}`);
  }
}

export function requireContains(
  repoRoot: string,
  file: string,
  pattern: string,
  description: string,
): void {
  const text = readText(repoRoot, file);
  if (!text.includes(pattern)) {
    fail(`missing ${description} in ${file}: ${pattern}`);
  }
}

export function forbidContains(
  repoRoot: string,
  file: string,
  pattern: string,
  description: string,
): void {
  const text = readText(repoRoot, file);
  if (text.includes(pattern)) {
    fail(`forbidden ${description} in ${file}: ${pattern}`);
  }
}

export function requireHeading(
  repoRoot: string,
  file: string,
  heading: string,
): void {
  const text = readText(repoRoot, file);
  const expected = `## ${heading}`;
  const lines = text.split(/\r?\n/);
  if (!lines.includes(expected)) {
    fail(`missing heading '${expected}' in ${file}`);
  }
}

export function pass(message: string): void {
  console.log(message);
}
