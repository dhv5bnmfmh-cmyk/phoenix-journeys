import '../models/story_content.dart';
import 'journey_data.dart';
import 'luoyang_longmen_one_pass.dart';

class DailyJourneyExperience {
  const DailyJourneyExperience({
    required this.id,
    required this.city,
    required this.cityCode,
    required this.place,
    required this.appBarTitle,
    required String storyTitle,
    required String headline,
    required String description,
    required String discoveryTeaser,
    required this.distanceLabel,
    required this.stampSymbol,
    required JourneyContentRecord content,
    required List<ReadingAnnotation> storyAnnotations,
    required List<WordEntry> words,
    required List<DiscoveryEntry> discoveries,
    required String wonderQuestion,
    required String expressQuestion,
  })  : _storyTitle = storyTitle,
        _headline = headline,
        _description = description,
        _discoveryTeaser = discoveryTeaser,
        _content = content,
        _storyAnnotations = storyAnnotations,
        _words = words,
        _discoveries = discoveries,
        _wonderQuestion = wonderQuestion,
        _expressQuestion = expressQuestion;

  final String id;
  final String city;
  final String cityCode;
  final String place;
  final String appBarTitle;
  final String _storyTitle;
  final String _headline;
  final String _description;
  final String _discoveryTeaser;
  final String distanceLabel;
  final String stampSymbol;
  final JourneyContentRecord _content;
  final List<ReadingAnnotation> _storyAnnotations;
  final List<WordEntry> _words;
  final List<DiscoveryEntry> _discoveries;
  final String _wonderQuestion;
  final String _expressQuestion;

  bool get _isLongmenGold => id == luoyangLongmenJourneyId;
  get _longmenBase => luoyangLongmenOnePassLevelContent(5);

  String get storyTitle =>
      _isLongmenGold ? luoyangLongmenCanonicalTitle : _storyTitle;
  String get headline => _isLongmenGold ? luoyangLongmenHeadline : _headline;
  String get description =>
      _isLongmenGold ? luoyangLongmenDescription : _description;
  String get discoveryTeaser =>
      _isLongmenGold ? luoyangLongmenDiscoveryTeaser : _discoveryTeaser;

  JourneyContentRecord get content {
    if (!_isLongmenGold) return _content;
    final level = _longmenBase;
    return JourneyContentRecord(
      id: luoyangLongmenJourneyId,
      title: luoyangLongmenCanonicalTitle,
      geoNodeId: _content.geoNodeId,
      languageCode: 'zh-CN',
      verificationStatus: StoryVerificationStatus.published,
      tags: _content.tags,
      sections: <JourneyStorySection>[
        for (var index = 0; index < level.storyParagraphs.length; index++)
          JourneyStorySection(
            id: 'story-$index',
            text: level.storyParagraphs[index],
            sourceIds: const <String>[
              'unesco-luoyang-longmen-grottoes',
              'longmen-academy-wanfo-virtual-restoration',
            ],
          ),
      ],
    );
  }

  List<ReadingAnnotation> get storyAnnotations =>
      _isLongmenGold ? _longmenBase.storyAnnotations : _storyAnnotations;
  List<WordEntry> get words => _isLongmenGold ? _longmenBase.words : _words;
  List<DiscoveryEntry> get discoveries =>
      _isLongmenGold ? _longmenBase.discoveries : _discoveries;
  String get wonderQuestion =>
      _isLongmenGold ? _longmenBase.wonderQuestion : _wonderQuestion;
  String get expressQuestion =>
      _isLongmenGold ? _longmenBase.expressQuestion : _expressQuestion;

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
