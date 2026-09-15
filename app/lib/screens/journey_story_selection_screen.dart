import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data/daily_journey_experience.dart';
import '../data/journey_story_catalog.dart';
import '../state/access_controlled_app_state.dart';
import '../theme/phoenix_theme.dart';
import 'journey_screen.dart';

Future<void> openJourneyDestination(
  BuildContext context,
  AppState state,
  DailyJourneyExperience destinationJourney,
) async {
  final stories = storiesForJourney(destinationJourney);
  if (stories.length > 1) {
    await Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => JourneyStorySelectionScreen(
          destinationJourney: destinationJourney,
        ),
      ),
    );
    return;
  }

  final story = stories.isEmpty ? destinationJourney : stories.single;
  await state.activateJourney(story.id);
  if (state.journeyCompleted) await state.restartJourney();
  if (!context.mounted) return;
  await Navigator.of(context).push(
    MaterialPageRoute<void>(
      builder: (_) => JourneyScreen(journeyId: story.id),
    ),
  );
}

class JourneyStorySelectionScreen extends StatelessWidget {
  const JourneyStorySelectionScreen({
    super.key,
    required this.destinationJourney,
  });

  final DailyJourneyExperience destinationJourney;

  Future<void> _openStory(
    BuildContext context,
    AppState state,
    DailyJourneyExperience story,
  ) async {
    await state.activateJourney(story.id);
    if (state.journeyCompleted) await state.restartJourney();
    if (!context.mounted) return;
    await Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => JourneyScreen(journeyId: story.id),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final stories = storiesForJourney(destinationJourney);

    return Scaffold(
      backgroundColor: const Color(0xFFF2E2BD),
      appBar: AppBar(
        toolbarHeight: 44,
        title: Text(
          state.displayText(
            '${destinationJourney.city} · ${destinationJourney.place}',
          ),
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w900),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(14, 12, 14, 14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                state.displayText('选择 Story'),
                key: const ValueKey('journey-story-selection-title'),
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: const Color(0xFF2A1D16),
                      fontSize: 19,
                      fontWeight: FontWeight.w900,
                    ),
              ),
              const SizedBox(height: 4),
              Text(
                state.displayText('同一个地点，可以保存不同的故事与学习进度。'),
                style: const TextStyle(
                  color: Colors.black54,
                  fontSize: 11,
                  height: 1.35,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 12),
              Expanded(
                child: ListView.separated(
                  key: const ValueKey('journey-story-selection-list'),
                  itemCount: stories.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 9),
                  itemBuilder: (context, index) {
                    final story = stories[index];
                    final completed = state.isJourneyStampEarned(story.id);
                    final selected = state.activeJourneyId == story.id;
                    return _StorySelectionCard(
                      story: story,
                      state: state,
                      completed: completed,
                      selected: selected,
                      onTap: () => unawaited(
                        _openStory(context, state, story),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StorySelectionCard extends StatelessWidget {
  const _StorySelectionCard({
    required this.story,
    required this.state,
    required this.completed,
    required this.selected,
    required this.onTap,
  });

  final DailyJourneyExperience story;
  final AppState state;
  final bool completed;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final borderColor = selected
        ? PhoenixTheme.red
        : completed
            ? PhoenixTheme.gold
            : PhoenixTheme.red.withValues(alpha: .22);

    return Semantics(
      button: true,
      selected: selected,
      label: state.displayText('${story.storyTitle} Story'),
      child: Material(
        color: const Color(0xEFFFF8E8),
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          key: ValueKey('journey-story-option-${story.storyId}'),
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Container(
            padding: const EdgeInsets.fromLTRB(14, 12, 12, 12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: borderColor, width: selected ? 1.4 : 1),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 34,
                  height: 34,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: selected
                        ? PhoenixTheme.red
                        : PhoenixTheme.gold.withValues(alpha: .14),
                    borderRadius: BorderRadius.circular(11),
                  ),
                  child: Icon(
                    completed ? Icons.check_rounded : Icons.auto_stories_rounded,
                    size: 19,
                    color: selected ? Colors.white : PhoenixTheme.red,
                  ),
                ),
                const SizedBox(width: 11),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        state.displayText(story.storyTitle),
                        style: const TextStyle(
                          color: Color(0xFF2A1D16),
                          fontSize: 15,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        state.displayText(story.headline),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Colors.black87,
                          fontSize: 11,
                          height: 1.3,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        state.displayText(story.description),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Colors.black54,
                          fontSize: 10,
                          height: 1.35,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 6),
                const Padding(
                  padding: EdgeInsets.only(top: 7),
                  child: Icon(
                    Icons.chevron_right_rounded,
                    color: PhoenixTheme.red,
                    size: 21,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
