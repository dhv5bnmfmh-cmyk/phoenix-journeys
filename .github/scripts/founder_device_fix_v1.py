from pathlib import Path


def replace_once(path: str, old: str, new: str) -> None:
    p = Path(path)
    text = p.read_text()
    if text.count(old) != 1:
        raise SystemExit(f'{path}: expected one match, found {text.count(old)}')
    p.write_text(text.replace(old, new, 1))


# FIX 1: Sentence Rebuild speaker is unavailable until submit; after submit it
# always narrates the canonical correct answer (question.answer).
replace_once(
    'app/lib/widgets/hsk_story_challenge.dart',
    """  String _narrationText() {\n    if (submitted) {\n      return question.mode == StoryChallengeMode.sentenceRebuild\n          ? question.sourceSentence\n          : question.answer;\n    }\n""",
    """  String _narrationText() {\n    if (submitted) return question.answer;\n""",
)
replace_once(
    'app/lib/widgets/hsk_story_challenge.dart',
    """          Row(\n            children: [\n              const Spacer(),\n              IconButton(\n                key: ValueKey('challenge-speaker-${question.id}'),\n                tooltip: '朗读当前题目',\n                onPressed: () => unawaited(\n                  widget.onNarrate(\n                    question.id,\n                    widget.displayText(_narrationText()),\n                  ),\n                ),\n                icon: const Icon(\n                  Icons.volume_up_rounded,\n                  color: PhoenixTheme.gold,\n                ),\n              ),\n            ],\n          ),\n""",
    """          if (question.mode != StoryChallengeMode.sentenceRebuild || submitted)\n            Row(\n              children: [\n                const Spacer(),\n                IconButton(\n                  key: ValueKey('challenge-speaker-${question.id}'),\n                  tooltip: '朗读当前题目',\n                  onPressed: () => unawaited(\n                    widget.onNarrate(\n                      question.id,\n                      widget.displayText(_narrationText()),\n                    ),\n                  ),\n                  icon: const Icon(\n                    Icons.volume_up_rounded,\n                    color: PhoenixTheme.gold,\n                  ),\n                ),\n              ],\n            ),\n""",
)

# FIX 2: singular picker API, robust cancel/error path, and lightweight local
# compression before IndexedDB persistence.
Path('app/lib/services/journey_memory_photo_picker.dart').write_text("""import 'dart:typed_data';\n\nimport 'journey_memory_photo_picker_stub.dart'\n    if (dart.library.html) 'journey_memory_photo_picker_web.dart';\n\nFuture<Uint8List?> pickJourneyMemoryPhoto() => pickPhoto();\n""")
Path('app/lib/services/journey_memory_photo_picker_stub.dart').write_text("""import 'dart:typed_data';\n\n// Native UI can bind its platform picker here while keeping persistence and\n// JourneyMemoryRepository platform-neutral.\nFuture<Uint8List?> pickPhoto() async => null;\n""")
Path('app/lib/services/journey_memory_photo_picker_web.dart').write_text("""import 'dart:async';\nimport 'dart:js_interop';\nimport 'dart:math' as math;\nimport 'dart:typed_data';\n\nimport 'package:image/image.dart' as image_lib;\nimport 'package:web/web.dart' as web;\n\nconst int _maxPhotoLongEdge = 1600;\nconst int _jpegQuality = 82;\n\nFuture<Uint8List?> pickPhoto() async {\n  final input = web.HTMLInputElement()\n    ..type = 'file'\n    ..accept = 'image/*'\n    ..multiple = false;\n  final settled = Completer<void>();\n\n  void finish() {\n    if (!settled.isCompleted) settled.complete();\n  }\n\n  input.onchange = ((web.Event _) => finish()).toJS;\n  input.oncancel = ((web.Event _) => finish()).toJS;\n  input.click();\n\n  try {\n    await settled.future.timeout(const Duration(minutes: 2));\n  } on TimeoutException {\n    return null;\n  }\n\n  final files = input.files;\n  if (files == null || files.length == 0) return null;\n  final file = files.item(0);\n  if (file == null) return null;\n\n  final reader = web.FileReader();\n  final loaded = Completer<void>();\n  reader.onload = ((web.ProgressEvent _) {\n    if (!loaded.isCompleted) loaded.complete();\n  }).toJS;\n  reader.onerror = ((web.ProgressEvent _) {\n    if (!loaded.isCompleted) {\n      loaded.completeError(StateError('Photo read failed'));\n    }\n  }).toJS;\n  reader.readAsArrayBuffer(file);\n  await loaded.future;\n\n  final raw = reader.result;\n  if (raw is! JSArrayBuffer) throw StateError('Unsupported photo bytes');\n  return _compressPhoto(raw.toDart.asUint8List());\n}\n\nUint8List _compressPhoto(Uint8List bytes) {\n  final decoded = image_lib.decodeImage(bytes);\n  if (decoded == null || decoded.width <= 0 || decoded.height <= 0) {\n    return bytes;\n  }\n\n  final longest = math.max(decoded.width, decoded.height);\n  final resized = longest <= _maxPhotoLongEdge\n      ? decoded\n      : decoded.width >= decoded.height\n          ? image_lib.copyResize(\n              decoded,\n              width: _maxPhotoLongEdge,\n              interpolation: image_lib.Interpolation.average,\n            )\n          : image_lib.copyResize(\n              decoded,\n              height: _maxPhotoLongEdge,\n              interpolation: image_lib.Interpolation.average,\n            );\n  return Uint8List.fromList(\n    image_lib.encodeJpg(resized, quality: _jpegQuality),\n  );\n}\n""")

replace_once(
    'app/pubspec.yaml',
    "  web: ^1.1.1\n",
    "  web: ^1.1.1\n  image: ^4.3.0\n",
)

replace_once(
    'app/lib/state/app_state.dart',
    """  Future<String> addJourneyMemoryPhoto(JourneyMemoryEntry entry, Uint8List bytes) async {\n    final repository = await _journeyMemoryRepo();\n    final ref = await repository.addPhoto(entry.id, bytes, now: _clock());\n    await saveJourneyMemory(entry.copyWith(photoRefs: [...entry.photoRefs, ref], updatedAt: _clock()));\n    return ref;\n  }\n""",
    """  Future<String> addJourneyMemoryPhoto(JourneyMemoryEntry entry, Uint8List bytes) async {\n    final repository = await _journeyMemoryRepo();\n    final ref = await repository.addPhoto(entry.id, bytes, now: _clock());\n    await saveJourneyMemory(entry.copyWith(photoRefs: [...entry.photoRefs, ref], updatedAt: _clock()));\n    return ref;\n  }\n\n  Future<String> replaceJourneyMemoryPhoto(\n    JourneyMemoryEntry entry,\n    Uint8List bytes,\n  ) async {\n    final repository = await _journeyMemoryRepo();\n    final previousRefs = List<String>.of(entry.photoRefs);\n    final ref = await repository.addPhoto(entry.id, bytes, now: _clock());\n    try {\n      await saveJourneyMemory(\n        entry.copyWith(photoRefs: <String>[ref], updatedAt: _clock()),\n      );\n    } catch (_) {\n      await repository.deletePhoto(ref);\n      rethrow;\n    }\n    for (final previousRef in previousRefs) {\n      if (previousRef == ref) continue;\n      try {\n        await repository.deletePhoto(previousRef);\n      } catch (_) {\n        // The new photo is already persisted and authoritative. A stale local\n        // blob can be cleaned later without breaking the Memory UX.\n      }\n    }\n    return ref;\n  }\n""",
)

Path('app/lib/widgets/journey_memory_photo_panel.dart').write_text("""import 'dart:typed_data';\n\nimport 'package:flutter/material.dart';\n\nclass JourneyMemoryPhotoPanel extends StatefulWidget {\n  const JourneyMemoryPhotoPanel({\n    required this.photoRef,\n    required this.loadPhoto,\n    required this.busy,\n    required this.onPick,\n    this.onDelete,\n    this.errorText,\n    super.key,\n  });\n\n  final String? photoRef;\n  final Future<Uint8List?> Function(String ref) loadPhoto;\n  final bool busy;\n  final VoidCallback onPick;\n  final VoidCallback? onDelete;\n  final String? errorText;\n\n  @override\n  State<JourneyMemoryPhotoPanel> createState() =>\n      _JourneyMemoryPhotoPanelState();\n}\n\nclass _JourneyMemoryPhotoPanelState extends State<JourneyMemoryPhotoPanel> {\n  Future<Uint8List?>? _preview;\n\n  @override\n  void initState() {\n    super.initState();\n    _refreshPreview();\n  }\n\n  @override\n  void didUpdateWidget(covariant JourneyMemoryPhotoPanel oldWidget) {\n    super.didUpdateWidget(oldWidget);\n    if (oldWidget.photoRef != widget.photoRef ||\n        oldWidget.loadPhoto != widget.loadPhoto) {\n      _refreshPreview();\n    }\n  }\n\n  void _refreshPreview() {\n    final ref = widget.photoRef;\n    _preview = ref == null || ref.trim().isEmpty ? null : widget.loadPhoto(ref);\n  }\n\n  @override\n  Widget build(BuildContext context) {\n    final hasPhoto = widget.photoRef?.trim().isNotEmpty ?? false;\n    return Column(\n      key: const ValueKey('journey-memory-photo-panel'),\n      crossAxisAlignment: CrossAxisAlignment.stretch,\n      children: [\n        if (!hasPhoto)\n          OutlinedButton.icon(\n            key: const ValueKey('journey-memory-photo-add'),\n            onPressed: widget.busy ? null : widget.onPick,\n            icon: widget.busy\n                ? const SizedBox(\n                    width: 16,\n                    height: 16,\n                    child: CircularProgressIndicator(strokeWidth: 2),\n                  )\n                : const Icon(Icons.add_photo_alternate_outlined),\n            label: Text(widget.busy ? '正在打开照片…' : '添加照片'),\n          )\n        else ...[\n          FutureBuilder<Uint8List?>(\n            future: _preview,\n            builder: (context, snapshot) {\n              if (snapshot.connectionState == ConnectionState.waiting) {\n                return const SizedBox(\n                  height: 150,\n                  child: Center(\n                    child: CircularProgressIndicator(\n                      key: ValueKey('journey-memory-photo-preview-loading'),\n                      strokeWidth: 2,\n                    ),\n                  ),\n                );\n              }\n              final bytes = snapshot.data;\n              if (snapshot.hasError || bytes == null || bytes.isEmpty) {\n                return Container(\n                  key: const ValueKey('journey-memory-photo-preview-error'),\n                  height: 120,\n                  alignment: Alignment.center,\n                  decoration: BoxDecoration(\n                    color: Colors.black.withValues(alpha: .2),\n                    borderRadius: BorderRadius.circular(12),\n                  ),\n                  child: const Text(\n                    '无法读取照片，请重试',\n                    style: TextStyle(color: Colors.white70),\n                  ),\n                );\n              }\n              return ClipRRect(\n                borderRadius: BorderRadius.circular(12),\n                child: SizedBox(\n                  height: 160,\n                  child: Image.memory(\n                    bytes,\n                    key: const ValueKey('journey-memory-photo-preview'),\n                    width: double.infinity,\n                    fit: BoxFit.cover,\n                    gaplessPlayback: true,\n                  ),\n                ),\n              );\n            },\n          ),\n          const SizedBox(height: 7),\n          Row(\n            children: [\n              Expanded(\n                child: OutlinedButton.icon(\n                  key: const ValueKey('journey-memory-photo-replace'),\n                  onPressed: widget.busy ? null : widget.onPick,\n                  icon: const Icon(Icons.photo_library_outlined, size: 17),\n                  label: const Text('更换照片'),\n                ),\n              ),\n              const SizedBox(width: 7),\n              Expanded(\n                child: TextButton.icon(\n                  key: const ValueKey('journey-memory-photo-delete'),\n                  onPressed: widget.busy ? null : widget.onDelete,\n                  icon: const Icon(Icons.delete_outline_rounded, size: 17),\n                  label: const Text('删除'),\n                ),\n              ),\n            ],\n          ),\n          if (widget.busy) ...[\n            const SizedBox(height: 5),\n            const LinearProgressIndicator(\n              key: ValueKey('journey-memory-photo-busy'),\n              minHeight: 2,\n            ),\n          ],\n        ],\n        const SizedBox(height: 5),\n        const Text(\n          '照片仅保存在此设备',\n          key: ValueKey('journey-memory-photo-local-hint'),\n          style: TextStyle(color: Colors.white60, fontSize: 10),\n        ),\n        if (widget.errorText != null && widget.errorText!.trim().isNotEmpty) ...[\n          const SizedBox(height: 4),\n          Text(\n            widget.errorText!,\n            key: const ValueKey('journey-memory-photo-error'),\n            style: const TextStyle(\n              color: Colors.redAccent,\n              fontSize: 10.5,\n              fontWeight: FontWeight.w700,\n            ),\n          ),\n        ],\n      ],\n    );\n  }\n}\n""")

replace_once(
    'app/lib/screens/journey_screen.dart',
    "import '../widgets/journey_challenge_panel.dart';\n",
    "import '../widgets/journey_challenge_panel.dart';\nimport '../widgets/journey_memory_photo_panel.dart';\n",
)
replace_once(
    'app/lib/screens/journey_screen.dart',
    """  bool _guideLoading = false;\n  bool _writingLoading = false;\n  bool _challengeResolved = false;\n""",
    """  bool _guideLoading = false;\n  bool _writingLoading = false;\n  bool _memoryPhotoBusy = false;\n  String? _memoryPhotoError;\n  bool _challengeResolved = false;\n""",
)
replace_once(
    'app/lib/screens/journey_screen.dart',
    """  Widget _forbiddenCityMemoryPage() {\n""",
    """  Future<void> _pickForbiddenCityMemoryPhoto() async {\n    if (_memoryPhotoBusy) return;\n    setState(() {\n      _memoryPhotoBusy = true;\n      _memoryPhotoError = null;\n    });\n    var photoRead = false;\n    try {\n      final bytes = await pickJourneyMemoryPhoto();\n      if (!mounted) return;\n      if (bytes == null) {\n        setState(() => _memoryPhotoBusy = false);\n        return;\n      }\n      photoRead = true;\n      final entry = await _appState.saveActiveJourneyMemory(\n        memoryController.text,\n        sessionLevel: _sessionLanguageProfile.phoenixLevel ?? 1,\n      );\n      await _appState.replaceJourneyMemoryPhoto(entry, bytes);\n      if (!mounted) return;\n      setState(() => _memoryPhotoBusy = false);\n    } catch (_) {\n      if (!mounted) return;\n      setState(() {\n        _memoryPhotoBusy = false;\n        _memoryPhotoError =\n            photoRead ? '无法保存照片，请重试' : '无法读取照片，请重试';\n      });\n    }\n  }\n\n  Future<void> _deleteForbiddenCityMemoryPhoto() async {\n    if (_memoryPhotoBusy) return;\n    final matches = _appState.journeyMemories\n        .where((entry) => entry.journeyId == _experience.id && !entry.legacy)\n        .toList(growable: false);\n    if (matches.isEmpty || matches.first.photoRefs.isEmpty) return;\n    final entry = matches.first;\n    final ref = entry.photoRefs.first;\n    setState(() {\n      _memoryPhotoBusy = true;\n      _memoryPhotoError = null;\n    });\n    try {\n      await _appState.deleteJourneyMemoryPhoto(entry, ref);\n      if (!mounted) return;\n      setState(() => _memoryPhotoBusy = false);\n    } catch (_) {\n      if (!mounted) return;\n      setState(() {\n        _memoryPhotoBusy = false;\n        _memoryPhotoError = '无法删除照片，请重试';\n      });\n    }\n  }\n\n  Widget _forbiddenCityMemoryPage() {\n""",
)
replace_once(
    'app/lib/screens/journey_screen.dart',
    """    if (memoryController.text.isEmpty && existing.isNotEmpty) {\n      memoryController.text = existing.first.note;\n    }\n    return _page(\n""",
    """    if (memoryController.text.isEmpty && existing.isNotEmpty) {\n      memoryController.text = existing.first.note;\n    }\n    final photoRef = existing.isNotEmpty && existing.first.photoRefs.isNotEmpty\n        ? existing.first.photoRefs.first\n        : null;\n    return _page(\n""",
)
replace_once(
    'app/lib/screens/journey_screen.dart',
    """            const SizedBox(height: 10),\n            OutlinedButton.icon(\n              key: const ValueKey('forbidden-city-add-photo'),\n              onPressed: () async {\n                final result = await pickJourneyMemoryPhotos();\n                if (result.isEmpty) return;\n                // Establish the stable Journey identity without completing the Journey.\n                var entry = await _appState.saveActiveJourneyMemory(\n                  memoryController.text,\n                  sessionLevel: _sessionLanguageProfile.phoenixLevel ?? 1,\n                );\n                for (final bytes in result) {\n                  await _appState.addJourneyMemoryPhoto(entry, bytes);\n                  entry = _appState.journeyMemories\n                      .firstWhere((item) => item.id == entry.id);\n                }\n                if (mounted) setState(() {});\n              },\n              icon: const Icon(Icons.add_photo_alternate_outlined),\n              label: const Text('添加照片'),\n            ),\n            if (existing.isNotEmpty && existing.first.photoRefs.isNotEmpty)\n              Padding(\n                padding: const EdgeInsets.only(top: 8),\n                child: Text('已添加 ${existing.first.photoRefs.length} 张照片',\n                    style: const TextStyle(color: Colors.white70)),\n              ),\n""",
    """            const SizedBox(height: 10),\n            JourneyMemoryPhotoPanel(\n              photoRef: photoRef,\n              loadPhoto: _appState.journeyMemoryPhoto,\n              busy: _memoryPhotoBusy,\n              errorText: _memoryPhotoError,\n              onPick: () => unawaited(_pickForbiddenCityMemoryPhoto()),\n              onDelete: photoRef == null\n                  ? null\n                  : () => unawaited(_deleteForbiddenCityMemoryPhoto()),\n            ),\n""",
)
replace_once(
    'app/lib/screens/journey_screen.dart',
    """    _guideLoading = false;\n    _writingLoading = false;\n    if (mounted) {\n""",
    """    _guideLoading = false;\n    _writingLoading = false;\n    _memoryPhotoBusy = false;\n    _memoryPhotoError = null;\n    if (mounted) {\n""",
)

Path('app/test/founder_device_fix_v1_test.dart').write_text(r"""import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:phoenix_journeys/data/forbidden_city_journey_runtime.dart';
import 'package:phoenix_journeys/models/journey_challenge.dart';
import 'package:phoenix_journeys/services/journey_challenge_engine.dart';
import 'package:phoenix_journeys/widgets/hsk_story_challenge.dart';
import 'package:phoenix_journeys/widgets/journey_memory_photo_panel.dart';

void main() {
  StoryChallengeQuestion rebuildQuestion() {
    return const JourneyChallengeEngine()
        .build(
          journeyId: 'beijing-forbidden-city',
          sessionLevel: 8,
          storyParagraphs: forbiddenCityStoryParagraphsByLevel[7],
        )
        .questions
        .firstWhere((item) => item.mode == StoryChallengeMode.sentenceRebuild);
  }

  List<String> correctChunks(StoryChallengeQuestion question) {
    final available = List<String>.of(question.characterTiles);
    final ordered = <String>[];
    var cursor = 0;
    while (available.isNotEmpty && cursor < question.answer.length) {
      final match = available.indexWhere(
        (tile) => question.answer.startsWith(tile, cursor),
      );
      expect(match, isNonNegative);
      final tile = available.removeAt(match);
      ordered.add(tile);
      cursor += tile.length;
    }
    expect(cursor, question.answer.length);
    return ordered;
  }

  Future<List<String>> pumpRebuild(
    WidgetTester tester,
    StoryChallengeQuestion question,
  ) async {
    final narration = <String>[];
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SizedBox(
            width: 390,
            height: 760,
            child: HskStoryChallenge(
              challenge: StoryChallengeSet(
                journeyId: 'beijing-forbidden-city',
                sessionLevel: 8,
                questions: <StoryChallengeQuestion>[question],
              ),
              displayText: (value) => value,
              onCompleted: () async {},
              onNarrate: (_, text) async => narration.add(text),
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    return narration;
  }

  Future<void> submitRebuild(
    WidgetTester tester,
    StoryChallengeQuestion question, {
    required bool correct,
  }) async {
    final chunks = correctChunks(question);
    if (!correct) {
      expect(chunks.length, greaterThan(1));
      final first = chunks[0];
      chunks[0] = chunks[1];
      chunks[1] = first;
    }
    for (final chunk in chunks) {
      await tester.tap(find.widgetWithText(ActionChip, chunk).first);
      await tester.pump();
    }
    await tester.tap(find.byKey(const ValueKey('challenge-submit')));
    await tester.pump();
  }

  testWidgets('Sentence Rebuild speaker is hidden before submit with no leak', (
    tester,
  ) async {
    final question = rebuildQuestion();
    final narration = await pumpRebuild(tester, question);

    expect(
      find.byKey(ValueKey('challenge-speaker-${question.id}')),
      findsNothing,
    );
    expect(narration, isEmpty);
  });

  testWidgets('Sentence Rebuild speaker uses question.answer after correct submit', (
    tester,
  ) async {
    final question = rebuildQuestion();
    final narration = await pumpRebuild(tester, question);
    await submitRebuild(tester, question, correct: true);

    final speaker = find.byKey(ValueKey('challenge-speaker-${question.id}'));
    expect(speaker, findsOneWidget);
    await tester.tap(speaker);
    await tester.pump();
    expect(narration, <String>[question.answer]);
  });

  testWidgets('Sentence Rebuild speaker also appears after wrong submit', (
    tester,
  ) async {
    final question = rebuildQuestion();
    final narration = await pumpRebuild(tester, question);
    await submitRebuild(tester, question, correct: false);

    final speaker = find.byKey(ValueKey('challenge-speaker-${question.id}'));
    expect(speaker, findsOneWidget);
    await tester.tap(speaker);
    await tester.pump();
    expect(narration, <String>[question.answer]);
  });

  Uint8List previewPng() => base64Decode(
        'iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAQAAAC1HAwCAAAAC0lEQVR42mP8/x8AAusB9Y9ZC7sAAAAASUVORK5CYII=',
      );

  testWidgets('Photo Memory shows add state and local-only hint', (tester) async {
    var picks = 0;
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: JourneyMemoryPhotoPanel(
            photoRef: null,
            loadPhoto: (_) async => null,
            busy: false,
            onPick: () => picks += 1,
          ),
        ),
      ),
    );

    expect(find.byKey(const ValueKey('journey-memory-photo-add')), findsOneWidget);
    expect(find.text('照片仅保存在此设备'), findsOneWidget);
    await tester.tap(find.byKey(const ValueKey('journey-memory-photo-add')));
    expect(picks, 1);
  });

  testWidgets('Photo Memory renders preview with replace and delete controls', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: JourneyMemoryPhotoPanel(
            photoRef: 'local-photo-ref',
            loadPhoto: (_) async => previewPng(),
            busy: false,
            onPick: () {},
            onDelete: () {},
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(
      find.byKey(const ValueKey('journey-memory-photo-preview')),
      findsOneWidget,
    );
    expect(
      find.byKey(const ValueKey('journey-memory-photo-replace')),
      findsOneWidget,
    );
    expect(
      find.byKey(const ValueKey('journey-memory-photo-delete')),
      findsOneWidget,
    );
    expect(find.text('local-photo-ref'), findsNothing);
  });

  testWidgets('Photo Memory busy state blocks duplicate taps and reports failure', (
    tester,
  ) async {
    var picks = 0;
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: JourneyMemoryPhotoPanel(
            photoRef: null,
            loadPhoto: (_) async => null,
            busy: true,
            errorText: '无法读取照片，请重试',
            onPick: () => picks += 1,
          ),
        ),
      ),
    );

    await tester.tap(find.byKey(const ValueKey('journey-memory-photo-add')));
    expect(picks, 0);
    expect(find.text('无法读取照片，请重试'), findsOneWidget);
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('Photo Memory preview read failure is explicit', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: JourneyMemoryPhotoPanel(
            photoRef: 'broken-local-ref',
            loadPhoto: (_) async => throw StateError('read failed'),
            busy: false,
            onPick: () {},
            onDelete: () {},
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('无法读取照片，请重试'), findsOneWidget);
    expect(find.text('broken-local-ref'), findsNothing);
  });
}
""")
