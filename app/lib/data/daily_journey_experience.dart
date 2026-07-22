import '../models/story_content.dart';
import 'journey_data.dart';

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
    required this.storyAnnotations,
    required this.words,
    required this.discoveries,
    required this.wonderQuestion,
    required this.expressQuestion,
  });

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
  final List<ReadingAnnotation> storyAnnotations;
  final List<WordEntry> words;
  final List<DiscoveryEntry> discoveries;
  final String wonderQuestion;
  final String expressQuestion;

  String get cityId {
    final separator = id.indexOf('-');
    return separator <= 0 ? id : id.substring(0, separator);
  }

  String get destinationId {
    final separator = id.indexOf('-');
    if (separator < 0 || separator == id.length - 1) return id;
    return id.substring(separator + 1);
  }

  String get geoNodeId => content.geoNodeId;

  String get locationPath => '$cityId/$destinationId';

  String get stampTitle => '$city · $place';
}
