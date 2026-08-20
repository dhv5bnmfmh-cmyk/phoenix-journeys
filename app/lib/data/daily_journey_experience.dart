import 'dart:collection';

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

  String get geoNodeId => _content.geoNodeId;

  String get locationPath => '$cityId/$destinationId';

  String get stampTitle => '$city · $place';
}


class DeferredDailyJourneyExperience extends DailyJourneyExperience {
  DeferredDailyJourneyExperience({
    required String id,
    required String city,
    required String cityCode,
    required String place,
    required String distanceLabel,
    required String stampSymbol,
    required String geoNodeId,
    required DailyJourneyExperienceBuilder resolve,
  })  : _resolveBuilder = resolve,
        _identityGeoNodeId = geoNodeId,
        super(
          id: id,
          city: city,
          cityCode: cityCode,
          place: place,
          appBarTitle: '',
          storyTitle: '',
          headline: '',
          description: '',
          discoveryTeaser: '',
          distanceLabel: distanceLabel,
          stampSymbol: stampSymbol,
          content: JourneyContentRecord(
            id: id,
            title: '',
            geoNodeId: geoNodeId,
            languageCode: 'zh-CN',
            sections: const <JourneyStorySection>[],
            verificationStatus: StoryVerificationStatus.draft,
          ),
          storyAnnotations: const <ReadingAnnotation>[],
          words: const <WordEntry>[],
          discoveries: const <DiscoveryEntry>[],
          wonderQuestion: '',
          expressQuestion: '',
        );

  final DailyJourneyExperienceBuilder _resolveBuilder;
  final String _identityGeoNodeId;
  DailyJourneyExperience? _resolvedJourney;

  DailyJourneyExperience get _resolved =>
      _resolvedJourney ??= _resolveBuilder();

  @override
  String get appBarTitle => _resolved.appBarTitle;

  @override
  String get storyTitle => _resolved.storyTitle;

  @override
  String get headline => _resolved.headline;

  @override
  String get description => _resolved.description;

  @override
  String get discoveryTeaser => _resolved.discoveryTeaser;

  @override
  JourneyContentRecord get content => _resolved.content;

  @override
  List<ReadingAnnotation> get storyAnnotations => _resolved.storyAnnotations;

  @override
  List<WordEntry> get words => _resolved.words;

  @override
  List<DiscoveryEntry> get discoveries => _resolved.discoveries;

  @override
  String get wonderQuestion => _resolved.wonderQuestion;

  @override
  String get expressQuestion => _resolved.expressQuestion;

  @override
  String get geoNodeId => _identityGeoNodeId;
}


typedef DailyJourneyExperienceBuilder = DailyJourneyExperience Function();

class LazyJourneyList extends ListBase<DailyJourneyExperience> {
  LazyJourneyList(List<DailyJourneyExperienceBuilder> builders)
      : _builders = List<DailyJourneyExperienceBuilder>.unmodifiable(builders),
        _cache = List<DailyJourneyExperience?>.filled(
          builders.length,
          null,
          growable: false,
        );

  final List<DailyJourneyExperienceBuilder> _builders;
  final List<DailyJourneyExperience?> _cache;

  @override
  int get length => _builders.length;

  @override
  set length(int value) {
    throw UnsupportedError('LazyJourneyList is immutable.');
  }

  @override
  DailyJourneyExperience operator [](int index) {
    RangeError.checkValidIndex(index, this);
    return _cache[index] ??= _builders[index]();
  }

  @override
  void operator []=(int index, DailyJourneyExperience value) {
    throw UnsupportedError('LazyJourneyList is immutable.');
  }
}