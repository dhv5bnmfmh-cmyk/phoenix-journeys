import 'editorial_story_revision_model.dart';
import 'ordinary_editorial_revisions_a.dart';
import 'ordinary_editorial_revisions_b.dart';
import 'ordinary_editorial_revisions_c.dart';
import 'ordinary_editorial_revisions_d.dart';
import 'special_editorial_revisions.dart';

const editorialStoryRevisions = <String, EditorialStoryRevision>{
  ...ordinaryEditorialRevisionsA,
  ...ordinaryEditorialRevisionsB,
  ...ordinaryEditorialRevisionsC,
  ...ordinaryEditorialRevisionsD,
  ...specialEditorialRevisions,
};
