# Journey Content Quality Gate

The quality gate runs against every published regular and special journey for every HSK and TOCFL profile.

It blocks releases when adaptive content:

- breaks the approved one- or two-paragraph reading shape;
- loses the original opening scene or closing meaning;
- begins paragraph two with an unresolved pronoun or connector;
- loses pinyin, Vietnamese, or English reading support;
- duplicates a discovery or repeats the story as a discovery;
- produces empty prompts or invalid vocabulary entries.

Each journey/profile combination receives a score from 0 to 100. CI requires no critical issues and a score of at least 90.
