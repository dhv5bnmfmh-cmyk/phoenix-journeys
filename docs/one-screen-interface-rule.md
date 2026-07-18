# Phoenix one-screen interface rule

All primary Phoenix Journeys screens must show their main information and main action within one phone viewport.

- Keep the top identity/progress area fixed and compact.
- Keep the main action area fixed and visible.
- Show related short content together in the same viewport whenever it can fit.
- Use explicit tap tabs, grouped cards, collapsible areas, or modal sheets for additional content.
- Do not use horizontal paging, swipe-to-change pages, `PageView`, `TabBarView`, or `CompactPager` in Phoenix interfaces.
- Do not add a top-level vertically scrolling feature stack.
- Secondary reference details may scroll only inside a modal sheet or a single focused card.
- New features must join an existing group, tab, or modal instead of increasing screen height.
- This rule applies to Explore, Passport, Me, every Journey step, and all future primary screens.
- CI must reject future primary-screen changes that restore horizontal paging or top-level vertical feature stacking.
