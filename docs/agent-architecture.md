# Phoenix Journeys Agent Architecture

Phoenix uses capability-domain Agents only when a feature owns persistent state, rules, decisions, or cross-screen coordination.

## Current Agents

- PhoenixGuideAgent — cultural dialogue and journey follow-up questions
- PhoenixWritingAgent — writing correction and natural rewriting
- PhoenixNarrationAgent — narration queue, playback state, vocabulary interruption, and resume
- PhoenixStampAgent — city stamp generation and completion behavior

## Planned capability Agents

- PhoenixJourneyAgent — route progress, unlock rules, completion, and rewards
- PhoenixVocabularyAgent — saved words, review scheduling, mastery, and pronunciation history
- PhoenixDiscoveryAgent — daily discovery selection and learning sequence
- PhoenixMapAgent — city routes, airplane animation, visited places, and travel footprint
- PhoenixAssessmentAgent — quizzes, scoring, anti-cheating rules, and reward eligibility
- PhoenixSharingAgent — journey cards, privacy controls, and platform-ready sharing output
- PhoenixProfileAgent — preferences, language support, learning goals, and synchronization

## Rule

Do not create one Agent per button or screen. Use a Service for a single technical call and a Widget for presentation. Create an Agent only when the capability has independent state, policy, orchestration, or long-term expansion needs.
