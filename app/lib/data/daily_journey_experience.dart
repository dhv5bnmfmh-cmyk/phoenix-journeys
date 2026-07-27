import '../models/story_content.dart';
import 'journey_data.dart';
import 'journey_narrative_policy.dart';

class DailyJourneyExperience {
  const DailyJourneyExperience({
    required this.id,
    required this.city,
    required this.cityCode,
    required this.place,
    required this.appBarTitle,
    required this.storyTitle,
    required this.headline,
    required this.description,
    required this.discoveryTeaser,
    required this.distanceLabel,
    required this.stampSymbol,
    required this.content,
    required List<ReadingAnnotation> storyAnnotations,
    required this.words,
    required List<DiscoveryEntry> discoveries,
    required this.wonderQuestion,
    required this.expressQuestion,
  })  : _storyAnnotations = storyAnnotations,
        _discoveries = discoveries;

  final String id;
  final String city;
  final String cityCode;
  final String place;
  final String appBarTitle;
  final String storyTitle;
  final String headline;
  final String description;
  final String discoveryTeaser;
  final String distanceLabel;
  final String stampSymbol;
  final JourneyContentRecord content;
  final List<ReadingAnnotation> _storyAnnotations;
  final List<WordEntry> words;
  final List<DiscoveryEntry> _discoveries;
  final String wonderQuestion;
  final String expressQuestion;

  JourneyNarrativeTone get narrativeTone => resolveJourneyNarrativeTone(
        title: content.title,
        tags: content.tags,
      );

  List<ReadingAnnotation> get storyAnnotations => condenseStoryAnnotations(
        tone: narrativeTone,
        annotations: _storyAnnotations,
      );

  List<DiscoveryEntry> get discoveries => condenseDiscoveries(
        tone: narrativeTone,
        discoveries: _discoveries,
      );

  String get cityId {
    final separator = id.indexOf('-');
    return separator <= 0 ? id : id.substring(0, separator);
  }

  String get destinationId {
    if (id == 'guangzhou-chen-clan-academy') {
      return 'chen-clan-ancestral-hall';
    }
    final separator = id.indexOf('-');
    if (separator < 0 || separator == id.length - 1) return id;
    return id.substring(separator + 1);
  }

  String get geoNodeId => content.geoNodeId;

  String get locationPath => '$cityId/$destinationId';

  String get stampTitle => '$city · $place';
}
