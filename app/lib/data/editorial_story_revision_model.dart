import 'journey_data.dart';

class EditorialStoryRevision {
  const EditorialStoryRevision({
    required this.id,
    required this.protagonist,
    required this.narrativeMode,
    required this.emotionalArc,
    required this.endingMode,
    required this.sections,
    required this.annotations,
    required this.wonderQuestion,
    required this.expressQuestion,
  });

  final String id;
  final String protagonist;
  final String narrativeMode;
  final String emotionalArc;
  final String endingMode;
  final List<String> sections;
  final List<ReadingAnnotation> annotations;
  final String wonderQuestion;
  final String expressQuestion;
}
