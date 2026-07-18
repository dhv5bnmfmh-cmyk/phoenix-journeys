# Phoenix one-screen interface rule

All primary Phoenix Journeys screens must show their main information and main action within one phone viewport.

- Keep the top identity/progress area fixed and compact.
- Keep the main action area fixed and visible.
- Use horizontal paging, tabs, grouped cards, or modal sheets for additional content.
- Do not add a top-level vertically scrolling feature stack.
- Secondary reference details may scroll only inside a modal sheet or a single focused card.
- New features must join an existing group or page instead of increasing the screen height.
- This rule applies to Explore, Passport, Me, every Journey step, and all future primary screens.
- CI must reject future primary-screen changes that restore top-level vertical feature stacking.
