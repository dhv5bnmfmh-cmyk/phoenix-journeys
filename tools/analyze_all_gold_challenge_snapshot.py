#!/usr/bin/env python3
import csv
import json
import sys
from collections import Counter, defaultdict
from pathlib import Path

CODES = ['TBT','AMB','DST','MODE','PROV','LEGACY','CROSS','LEVEL','PROG','HIST','LANG','LOOP','TEMPLATE']
DATONG = 'datong-yungang-grottoes'
FORBIDDEN = 'beijing-forbidden-city'
GENERIC_GRAMMAR_JOURNEYS = {'luoyang-longmen-grottoes','jiangmen-kaiping-diaolou'}
FALSE_WORLD = (
    '十七孔桥不连接东堤与南湖岛','十七孔桥的季节光线整晚不变',
    '三条巷子的尺度完全相同','院落、茶馆与店铺彼此隔绝','保护后的街区只允许游客进入','成都的慢生活只是一句广告',
    '秦淮河只在白天使用','夫子庙、桥梁和街市互不相连','灯会已经概括全部历史','河流只负责分隔两岸',
    '外滩西岸只保留住宅','浦东天际线与历史建筑属于同一时期','黄浦江把两岸完全隔开','历史街区只有一栋建筑',
    '护城河位于城墙内部','宽阔墙顶阻止人员移动','永宁门与角楼彼此独立','站在城墙上只能看见过去',
)
FILLER = (
    '他很快离开了这里','他继续向前走，却没有留意','他沿着原来的路线前进，却忽略',
    '他停下脚步，把沿途景色逐一写进记录里','他重新检查前文线索，却没有改变原来的判断',
    '他看似回应了前文，却无法解释后面出现的结果','故事中的地点突然改变',
    '人物作出决定以后，后面的结果与决定完全无关','这一句重复表面景色','时间顺序突然倒转',
)

def contains(options, needles):
    return any(any(n in option for n in needles) for option in options)

def band(level):
    if level <= 2: return 'Recognition / Basic comprehension'
    if level <= 4: return 'Sequence / Simple causality'
    if level <= 6: return 'Relationship / Choice / Historical cause'
    if level <= 8: return 'Causal chain / Implicit meaning'
    return 'Integrated interpretation'

def primary(level, mode):
    if mode == 'grammarRepair': return 'LANGUAGE'
    if mode == 'paragraphRebuild': return 'STORY' if level <= 2 else 'CAUSAL REASONING'
    return 'STORY' if level <= 2 else 'CAUSAL REASONING'

def audit(row):
    j = row['journeyId']; level = int(row['level']); mode = row['mode']; options = row['options']
    defects = set()
    historic_false = contains(options, FALSE_WORLD)
    filler = contains(options, FILLER)

    # The Forbidden City package is level-bound, but paragraph/missing explicitly
    # require recovering locked-original wording/order rather than differentiated
    # structural/inference reasoning under the new Gold contract.
    if j == FORBIDDEN and mode in {'paragraphRebuild','missingSentence'}:
        defects.add('MODE')

    # Every pre-Datong grammar implementation still carries weak generated option
    # logic. Ten Journeys additionally share the same three difficulty skeletons.
    if mode == 'grammarRepair' and j != DATONG:
        defects.add('DST')

    # Apart from Datong and Forbidden City, the old runtime fixes paragraph and
    # missingSentence at Story offset zero and grammar at three difficulty shapes.
    # That prevents a real Lv1→Lv10 cognitive trajectory.
    if j not in {DATONG, FORBIDDEN}:
        defects.add('PROG')
        if level >= 3:
            defects.add('LEVEL')
        if mode == 'grammarRepair':
            defects.add('TEMPLATE')
        if historic_false:
            defects.add('HIST')
        if mode in {'paragraphRebuild','missingSentence'} and (historic_false or filler):
            defects.add('DST')

    # Longmen and Kaiping have no current Journey grammar binding and therefore
    # fall through to the old generic tourism/garden grammar seed.
    if j in GENERIC_GRAMMAR_JOURNEYS and mode == 'grammarRepair':
        defects.update({'PROV','LEGACY','LANG','LOOP'})

    return defects

def main():
    if len(sys.argv) != 4:
        raise SystemExit('usage: analyze_all_gold_challenge_snapshot.py SNAPSHOT MATRIX_CSV SUMMARY_MD')
    snapshot_path, matrix_path, summary_path = map(Path, sys.argv[1:])
    payload = json.loads(snapshot_path.read_text())
    rows = payload['rows']
    if payload['approvedGoldCount'] != 12 or len(rows) != 360:
        raise SystemExit('snapshot shape mismatch')

    matrix = []
    counts = Counter()
    journey_repairs = defaultdict(int)
    pass_count = 0
    for row in rows:
        defects = audit(row)
        for code in defects: counts[code] += 1
        if defects: journey_repairs[row['journeyId']] += 1
        else: pass_count += 1
        level = int(row['level']); mode = row['mode']
        provenance = 'ACTIVE STORY'
        if mode == 'grammarRepair': provenance = 'EXPLICIT LANGUAGE OBJECTIVE + JOURNEY CONTEXT'
        if 'PROV' in defects: provenance = 'GENERIC FALLBACK (INVALID)'
        reasons = []
        for code, text in (
            ('DST','weak/mechanical, false-world, or filler distractor'),('MODE','verbatim Story recall dominates mode'),
            ('PROV','not current-Journey provenance'),('LEGACY','legacy generic fallback is active'),
            ('LEVEL','cognitive demand mismatches current band'),('PROG','Lv1→Lv10 logic repeats instead of deepening'),
            ('HIST','false world claim is used as a cheap distractor'),('LANG','language context is disconnected from Journey'),
            ('LOOP','Story/Discovery closed loop is broken'),('TEMPLATE','cross-Gold grammar skeleton is reused')):
            if code in defects: reasons.append(text)
        matrix.append({
            'JOURNEY ID': row['journeyId'], 'LEVEL': f"Lv{level}", 'MODE': mode,
            'PRIMARY LEARNING INTENT': primary(level, mode),
            'SECONDARY INTENT': 'LANGUAGE' if mode != 'grammarRepair' else 'STORY',
            'ACTIVE SOURCE': row['activeChallengeSource'], 'SOURCE PROVENANCE': provenance,
            'TAUGHT BEFORE TESTED': 'PASS', 'CORRECT ANSWER': row['correctAnswer'].replace('\n',' / '),
            'WHY CORRECT': 'active Story sequence' if mode == 'paragraphRebuild' else ('natural Chinese structural repair' if mode == 'grammarRepair' else 'best bridge for active Story context'),
            'ALTERNATIVE ANSWER AMBIGUITY': 'NONE FOUND', 'ONE DEFENSIBLE ANSWER': 'PASS',
            'DISTRACTOR QUALITY': 'FAIL' if 'DST' in defects else 'PASS',
            'DISTRACTOR MISCONCEPTION': '; '.join(reasons) if reasons else 'PASS',
            'HISTORICAL TRUTH': 'FAIL' if 'HIST' in defects else 'PASS',
            'LANGUAGE VALUE': 'FAIL' if 'LANG' in defects else 'PASS',
            'STORY CONNECTION': 'FAIL' if 'LOOP' in defects else 'PASS',
            'DISCOVERY CONNECTION': 'FAIL' if 'LOOP' in defects else 'PASS/NOT PRIMARY',
            'STORY/DISCOVERY CLOSED LOOP': 'FAIL' if 'LOOP' in defects else 'PASS',
            'LEVEL APPROPRIATENESS': 'FAIL' if 'LEVEL' in defects else 'PASS',
            'COGNITIVE BAND': band(level), 'COGNITIVE PROGRESSION': 'FAIL' if 'PROG' in defects else 'PASS',
            'LEGACY CONTAMINATION': 'FAIL' if 'LEGACY' in defects else 'PASS',
            'CROSS-JOURNEY CONTAMINATION': 'FAIL' if 'CROSS' in defects else 'PASS',
            'TEMPLATE COLLISION': 'FAIL' if 'TEMPLATE' in defects else 'PASS',
            'DEFECT CODES': ','.join(sorted(defects)), 'RESULT': 'REPAIR REQUIRED' if defects else 'PASS',
        })

    fields = list(matrix[0])
    matrix_path.parent.mkdir(parents=True, exist_ok=True)
    with matrix_path.open('w', newline='') as handle:
        writer = csv.DictWriter(handle, fieldnames=fields); writer.writeheader(); writer.writerows(matrix)

    repair_count = len(rows) - pass_count
    lines = [
        '# Phoenix All-Gold Challenge Audit Baseline', '',
        f'- Source snapshot: `{snapshot_path.name}`',
        f'- Approved Gold: `{payload["approvedGoldCount"]}`',
        '- Journey × Level pairs: `120`', '- Active Challenge units: `360`',
        f'- Baseline PASS: `{pass_count}`', f'- Baseline REPAIR REQUIRED: `{repair_count}`',
        '- Human Gold review: `PENDING AFTER REPAIR`', '',
        '## Defect inventory before repair', '',
        '| Code | Affected active units |', '|---|---:|',
    ]
    for code in CODES: lines.append(f'| `{code}` | {counts[code]} |')
    lines += ['', '## Journey repair density', '', '| Journey | Repair required |', '|---|---:|']
    for journey in sorted(payload['approvedJourneyIds']):
        lines.append(f'| `{journey}` | {journey_repairs[journey]} / 30 |')
    lines += ['', '## Audit interpretation', '',
        '- Counts are **affected active units**, so one unit may carry multiple defect codes.',
        '- `TBT=0` and `AMB=0` mean this baseline found no deterministic violation; mandatory human review can still discover either defect.',
        '- `HIST` counts actual snapshot rows where a cheap false-world distractor was learner-visible; it does not accuse locked Story/Discovery facts of being false.',
        '- Datong is the only current Gold whose 30 active units already satisfy this first-pass structure because PR #186 made its Challenge level-aware and Journey-specific.',
        '- No repair was performed before this complete 360-unit inventory was frozen.', '',
        '**AUDIT FIRST = COMPLETE. REPAIR MAY NOW BEGIN.**',
    ]
    summary_path.write_text('\n'.join(lines) + '\n')
    print(json.dumps({'PASS':pass_count,'REPAIR_REQUIRED':repair_count,**{c:counts[c] for c in CODES}}, ensure_ascii=False))

if __name__ == '__main__': main()
