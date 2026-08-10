# Story Truth + Place-Causality Governance Scope Record

This PR is governance/test infrastructure only.

Protected and intentionally unchanged:

- all eight approved Gold canonical Stories;
- approved Gold Narrative DNA and normalized fingerprints;
- Rule A and Rule B semantic thresholds;
- Suzhou candidate Story/work;
- production backgrounds and `PHOENIX_AI_BACKGROUND_PRODUCTION_STANDARD.md`;
- Passport UI;
- map and viewport behavior;
- Location Hierarchy;
- Journey navigation/progress/stamps/storage identity;
- narration engine.

The executable gate is `app/lib/data/journey_story_development_gate.dart`. It consumes the existing canonical semantic registry rather than creating a parallel anti-template registry.
