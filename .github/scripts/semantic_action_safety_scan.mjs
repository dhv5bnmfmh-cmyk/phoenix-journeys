import { readFile } from 'node:fs/promises';
import { pathToFileURL } from 'node:url';

export function unsafeSemanticActionFindings(source, path = '<source>') {
  const findings = [];
  const rules = [
    {
      id: 'snapshot-index-action',
      pattern: /locator\(\s*['"]flt-semantics['"]\s*\)\.nth\([^\n)]*(?:index|snapshot)[^\n)]*\)\s*\.(?:click|tap|dragTo|boundingBox)\s*\(/g,
    },
    {
      id: 'numeric-nth-semantic-action',
      pattern: /locator\(\s*['"]flt-semantics['"]\s*\)\.nth\([^\n)]*\)\s*\.(?:click|tap|dragTo|boundingBox)\s*\(/g,
    },
    {
      id: 'generated-active-harness',
      pattern: /writeFile\([\s\S]{0,1200}import\(pathToFileURL\(/g,
    },
  ];
  for (const rule of rules) {
    for (const match of source.matchAll(rule.pattern)) {
      findings.push({ path, rule: rule.id, excerpt: match[0].slice(0, 240) });
    }
  }
  return findings;
}

async function cli() {
  const paths = process.argv.slice(2);
  if (!paths.length) throw new Error('usage: semantic_action_safety_scan.mjs <active-script> [...]');
  const findings = [];
  for (const path of paths) {
    findings.push(...unsafeSemanticActionFindings(await readFile(path, 'utf8'), path));
  }
  if (findings.length) {
    for (const finding of findings) {
      console.error(`UNSAFE SEMANTIC ACTION | ${finding.rule} | ${finding.path} | ${finding.excerpt}`);
    }
    process.exitCode = 1;
    return;
  }
  console.log(`SEMANTIC ACTION SAFETY SCAN = PASS | FILES=${paths.length}`);
}

if (process.argv[1] && import.meta.url === pathToFileURL(process.argv[1]).href) {
  cli().catch((error) => {
    console.error(error?.stack || String(error));
    process.exitCode = 1;
  });
}
