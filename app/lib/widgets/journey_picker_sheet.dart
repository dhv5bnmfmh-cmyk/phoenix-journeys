import 'package:flutter/material.dart';

import '../data/journey_city_catalog.dart';
import '../state/access_controlled_app_state.dart';
import '../state/app_state.dart';
import '../theme/phoenix_theme.dart';

Future<String?> showJourneyPickerSheet({
  required BuildContext context,
  required AppState state,
  String? initialCityId,
  bool lockToInitialCity = false,
}) async {
  var selectedCityId = initialCityId ?? state.activeJourney.cityId;

  return showModalBottomSheet<String>(
    context: context,
    useSafeArea: true,
    showDragHandle: true,
    isScrollControlled: true,
    builder: (sheetContext) {
      return StatefulBuilder(
        builder: (context, setSheetState) {
          final selectedCity = requireJourneyCity(selectedCityId);

          return FractionallySizedBox(
            heightFactor: .82,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(14, 0, 14, 18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    state.displayText(
                      lockToInitialCity
                          ? '选择${selectedCity.name}景点'
                          : '选择城市与地点',
                    ),
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontSize: 19,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    state.displayText(
                      lockToInitialCity
                          ? '你已抵达${selectedCity.name}，请选择本城景点。'
                          : '先选择城市，再进入这座城市的具体旅程。',
                    ),
                    style: const TextStyle(color: Colors.black54, fontSize: 11),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 58,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: lockToInitialCity ? 1 : journeyCityCatalog.length,
                      separatorBuilder: (_, __) => const SizedBox(width: 7),
                      itemBuilder: (context, index) {
                        final city = lockToInitialCity
                            ? selectedCity
                            : journeyCityCatalog[index];
                        final selected = city.id == selectedCityId;
                        final earnedCount = city.destinations
                            .where(
                              (journey) =>
                                  state.isJourneyStampEarned(journey.id),
                            )
                            .length;

                        return Material(
                          color: selected
                              ? PhoenixTheme.red
                              : PhoenixTheme.gold.withValues(alpha: .10),
                          borderRadius: BorderRadius.circular(15),
                          child: InkWell(
                            key: ValueKey('journey-city-${city.id}'),
                            onTap: lockToInitialCity
                                ? null
                                : () => setSheetState(
                                      () => selectedCityId = city.id,
                                    ),
                            borderRadius: BorderRadius.circular(15),
                            child: Container(
                              width: 92,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 7,
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                border: Border.all(
                                  color: selected
                                      ? PhoenixTheme.red
                                      : PhoenixTheme.gold.withValues(
                                          alpha: .32,
                                        ),
                                ),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    state.displayText(city.name),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      color: selected
                                          ? Colors.white
                                          : Colors.black87,
                                      fontSize: 13,
                                      fontWeight: FontWeight.w900,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    state.displayText(
                                      '${city.destinationCount} 个地点 · $earnedCount 枚印章',
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      color: selected
                                          ? Colors.white70
                                          : Colors.black54,
                                      fontSize: 8.5,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      Container(
                        width: 34,
                        height: 34,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: PhoenixTheme.red.withValues(alpha: .10),
                          borderRadius: BorderRadius.circular(11),
                        ),
                        child: Text(
                          selectedCity.cityCode,
                          style: const TextStyle(
                            color: PhoenixTheme.red,
                            fontSize: 9,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              state.displayText('${selectedCity.name}的地点'),
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                            Text(
                              state.displayText('每个地点拥有独立故事、背景、进度和印章。'),
                              style: const TextStyle(
                                color: Colors.black54,
                                fontSize: 9.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Expanded(
                    child: ListView.separated(
                      itemCount: selectedCity.destinations.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 7),
                      itemBuilder: (context, index) {
                        final journey = selectedCity.destinations[index];
                        final active = journey.id == state.activeJourneyId;
                        final earned = state.isJourneyStampEarned(journey.id);
                        final canOpen = state.canOpenJourney(journey.id);
                        final slotLabel =
                            state.dailySlotLabelForJourney(journey.id);
                        final slotReleased =
                            state.isDailyJourneyReleased(journey.id);

                        final status = active && state.hasJourneyInProgress
                            ? '继续上次进度'
                            : slotLabel != null
                                ? state.isDevelopmentExperience || slotReleased
                                    ? '$slotLabel · 已开放'
                                    : '$slotLabel · 12:00 开放'
                                : earned && canOpen
                                    ? '印章已获得 · 可再次体验'
                                    : canOpen
                                        ? '可随时开始'
                                        : '今日未开放';

                        return Material(
                          color: active
                              ? PhoenixTheme.gold.withValues(alpha: .14)
                              : canOpen
                                  ? Colors.white
                                  : const Color(0xFFF1EEE8),
                          borderRadius: BorderRadius.circular(16),
                          child: InkWell(
                            key: ValueKey('journey-destination-${journey.id}'),
                            onTap: canOpen
                                ? () => Navigator.of(sheetContext).pop(journey.id)
                                : null,
                            borderRadius: BorderRadius.circular(16),
                            child: Container(
                              padding: const EdgeInsets.all(11),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: active
                                      ? PhoenixTheme.red.withValues(alpha: .45)
                                      : canOpen
                                          ? PhoenixTheme.gold.withValues(
                                              alpha: .28,
                                            )
                                          : Colors.black12,
                                ),
                              ),
                              child: Row(
                                children: [
                                  CircleAvatar(
                                    radius: 20,
                                    backgroundColor: canOpen
                                        ? PhoenixTheme.red.withValues(alpha: .10)
                                        : Colors.black.withValues(alpha: .06),
                                    child: Text(
                                      state.displayText(journey.stampSymbol),
                                      style: TextStyle(
                                        color: canOpen
                                            ? PhoenixTheme.red
                                            : Colors.black38,
                                        fontSize: 17,
                                        fontWeight: FontWeight.w900,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Expanded(
                                              child: Text(
                                                state.displayText(
                                                  journey.place,
                                                ),
                                                style: TextStyle(
                                                  color: canOpen
                                                      ? Colors.black87
                                                      : Colors.black45,
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w900,
                                                ),
                                              ),
                                            ),
                                            if (slotLabel != null)
                                              Icon(
                                                slotReleased ||
                                                        state
                                                            .isDevelopmentExperience
                                                    ? Icons.auto_awesome
                                                    : Icons.schedule_rounded,
                                                color: slotReleased ||
                                                        state
                                                            .isDevelopmentExperience
                                                    ? PhoenixTheme.gold
                                                    : Colors.black38,
                                                size: 16,
                                              ),
                                          ],
                                        ),
                                        const SizedBox(height: 2),
                                        Text(
                                          state.displayText(journey.headline),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            color: canOpen
                                                ? Colors.black54
                                                : Colors.black38,
                                            fontSize: 10.5,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          state.displayText(status),
                                          style: TextStyle(
                                            color: canOpen
                                                ? PhoenixTheme.red
                                                : Colors.black45,
                                            fontSize: 9.5,
                                            fontWeight: FontWeight.w800,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 6),
                                  Icon(
                                    canOpen
                                        ? Icons.arrow_forward_ios_rounded
                                        : Icons.lock_outline_rounded,
                                    color: canOpen
                                        ? Colors.black87
                                        : Colors.black38,
                                    size: 15,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      );
    },
  );
}
