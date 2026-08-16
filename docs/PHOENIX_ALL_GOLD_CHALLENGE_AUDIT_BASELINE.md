# Phoenix All-Gold Challenge Audit Baseline

- Source snapshot: `all-gold-challenge-snapshot.json`
- Approved Gold: `12`
- Journey × Level pairs: `120`
- Active Challenge units: `360`
- Baseline PASS: `30`
- Baseline REPAIR REQUIRED: `330`
- Human Gold review: `PENDING AFTER REPAIR`

## Defect inventory before repair

| Code | Affected active units |
|---|---:|
| `TBT` | 0 |
| `AMB` | 0 |
| `DST` | 256 |
| `MODE` | 20 |
| `PROV` | 20 |
| `LEGACY` | 20 |
| `CROSS` | 0 |
| `LEVEL` | 240 |
| `PROG` | 300 |
| `HIST` | 92 |
| `LANG` | 20 |
| `LOOP` | 20 |
| `TEMPLATE` | 100 |

## Journey repair density

| Journey | Repair required |
|---|---:|
| `beijing-forbidden-city` | 30 / 30 |
| `beijing-summer-palace` | 30 / 30 |
| `chengdu-kuanzhai-alley` | 30 / 30 |
| `datong-yungang-grottoes` | 0 / 30 |
| `guangzhou-chen-clan-academy` | 30 / 30 |
| `hangzhou-west-lake` | 30 / 30 |
| `jiangmen-kaiping-diaolou` | 30 / 30 |
| `luoyang-longmen-grottoes` | 30 / 30 |
| `nanjing-qinhuai-river` | 30 / 30 |
| `shanghai-bund` | 30 / 30 |
| `suzhou-humble-administrators-garden` | 30 / 30 |
| `xian-city-wall` | 30 / 30 |

## Audit interpretation

- Counts are **affected active units**, so one unit may carry multiple defect codes.
- `TBT=0` and `AMB=0` mean this baseline found no deterministic violation; mandatory human review can still discover either defect.
- `HIST` counts actual snapshot rows where a cheap false-world distractor was learner-visible; it does not accuse locked Story/Discovery facts of being false.
- Datong is the only current Gold whose 30 active units already satisfy this first-pass structure because PR #186 made its Challenge level-aware and Journey-specific.
- No repair was performed before this complete 360-unit inventory was frozen.

**AUDIT FIRST = COMPLETE. REPAIR MAY NOW BEGIN.**
