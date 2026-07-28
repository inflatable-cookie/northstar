import { existsSync, readFileSync, readdirSync } from "node:fs";
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

function markdownFilesUnder(directory: string): string[] {
  return readdirSync(directory, { withFileTypes: true }).flatMap((entry) => {
    const entryPath = path.join(directory, entry.name);
    if (entry.isDirectory()) {
      return markdownFilesUnder(entryPath);
    }

    return entry.isFile() && entry.name.endsWith(".md") ? [entryPath] : [];
  });
}

export function requirePortableMarkdownLinks(
  repoRoot: string,
  directory: string,
): void {
  const portableRoot = path.resolve(repoRoot, directory);
  requireFile(repoRoot, directory);

  for (const markdownFile of markdownFilesUnder(portableRoot)) {
    const text = readFileSync(markdownFile, "utf8");
    for (const match of text.matchAll(/!?\[[^\]]*]\(([^)]+)\)/g)) {
      const rawTarget = match[1].trim();
      const target = rawTarget.startsWith("<")
        ? rawTarget.slice(1, rawTarget.indexOf(">"))
        : rawTarget.split(/\s+/, 1)[0];

      if (!target || /^(?:[a-z][a-z0-9+.-]*:|#|\/\/)/i.test(target)) {
        continue;
      }

      const fileTarget = target.split(/[?#]/, 1)[0];
      const resolvedTarget = path.resolve(path.dirname(markdownFile), fileTarget);
      const relativeTarget = path.relative(portableRoot, resolvedTarget);
      const escapesRoot =
        relativeTarget === ".." ||
        relativeTarget.startsWith(`..${path.sep}`) ||
        path.isAbsolute(relativeTarget);
      const sourceFile = path.relative(repoRoot, markdownFile);

      if (escapesRoot) {
        fail(`non-portable Markdown link in ${sourceFile}: ${target}`);
      }

      if (!existsSync(resolvedTarget)) {
        fail(`broken Markdown link in ${sourceFile}: ${target}`);
      }
    }
  }
}

export function pass(message: string): void {
  console.log(message);
}
