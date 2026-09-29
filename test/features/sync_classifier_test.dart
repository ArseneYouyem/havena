import 'package:flutter_test/flutter_test.dart';
import 'package:havena/core/sync/field_merge_resolver.dart';
import 'package:havena/core/sync/sync_classifier.dart';

void main() {
  group('SyncClassifier', () {
    final lastSync = DateTime(2026, 9, 1, 12, 0);
    final before = DateTime(2026, 8, 15);
    final after = DateTime(2026, 9, 10);

    test('n\'existe pas côté distant -> pushLocal', () {
      final decision = SyncClassifier.classify(
        localUpdatedAt: after,
        remoteUpdatedAt: null,
        lastDeviceSyncAt: lastSync,
      );
      expect(decision, SyncDecision.pushLocal);
    });

    test('n\'existe pas localement -> pullRemote', () {
      final decision = SyncClassifier.classify(
        localUpdatedAt: null,
        remoteUpdatedAt: after,
        lastDeviceSyncAt: lastSync,
      );
      expect(decision, SyncDecision.pullRemote);
    });

    test('seul le distant a changé depuis la dernière synchro -> pullRemote',
        () {
      final decision = SyncClassifier.classify(
        localUpdatedAt: before,
        remoteUpdatedAt: after,
        lastDeviceSyncAt: lastSync,
      );
      expect(decision, SyncDecision.pullRemote);
    });

    test('seul le local a changé depuis la dernière synchro -> pushLocal',
        () {
      final decision = SyncClassifier.classify(
        localUpdatedAt: after,
        remoteUpdatedAt: before,
        lastDeviceSyncAt: lastSync,
      );
      expect(decision, SyncDecision.pushLocal);
    });

    test('les deux ont changé depuis la dernière synchro -> conflict', () {
      final decision = SyncClassifier.classify(
        localUpdatedAt: after,
        remoteUpdatedAt: after.add(const Duration(hours: 1)),
        lastDeviceSyncAt: lastSync,
      );
      expect(decision, SyncDecision.conflict);
    });

    test('rien n\'a changé depuis la dernière synchro -> noChange', () {
      final decision = SyncClassifier.classify(
        localUpdatedAt: before,
        remoteUpdatedAt: before,
        lastDeviceSyncAt: lastSync,
      );
      expect(decision, SyncDecision.noChange);
    });

    test('première synchro (lastDeviceSyncAt null), les deux existent déjà -> conflict par prudence',
        () {
      final decision = SyncClassifier.classify(
        localUpdatedAt: before,
        remoteUpdatedAt: after,
        lastDeviceSyncAt: null,
      );
      expect(decision, SyncDecision.conflict);
    });
  });

  group('FieldMergeResolver', () {
    test('differingFields ne retient que les clés dont la valeur diffère',
        () {
      final local = {'name': 'Alice', 'phone': '600', 'city': 'Douala'};
      final remote = {'name': 'Alice', 'phone': '601', 'email': 'a@x.com'};

      final diff = FieldMergeResolver.differingFields(local, remote);

      expect(diff, ['city', 'email', 'phone']);
    });

    test('autoMerge complète les champs vides depuis le distant', () {
      final local = {'name': 'Alice', 'email': ''};
      final remote = {'name': 'Alice', 'email': 'alice@example.com'};

      final merged = FieldMergeResolver.autoMerge(local, remote);

      expect(merged['email'], 'alice@example.com');
    });

    test('autoMerge garde la valeur locale quand les deux diffèrent', () {
      final local = {'phone': '600111'};
      final remote = {'phone': '600222'};

      final merged = FieldMergeResolver.autoMerge(local, remote);

      expect(merged['phone'], '600111');
    });

    test('autoMerge garde null si les deux côtés sont vides', () {
      final local = {'notes': null};
      final remote = {'notes': null};

      final merged = FieldMergeResolver.autoMerge(local, remote);

      expect(merged['notes'], isNull);
    });

    test('applyChoices respecte le choix explicite par champ', () {
      final local = {'phone': '600111', 'city': 'Douala'};
      final remote = {'phone': '600222', 'city': 'Yaoundé'};

      final merged = FieldMergeResolver.applyChoices(
        local: local,
        remote: remote,
        useLocalByField: {'phone': false, 'city': true},
      );

      expect(merged['phone'], '600222');
      expect(merged['city'], 'Douala');
    });

    test('applyChoices garde la valeur locale par défaut si non précisé', () {
      final local = {'phone': '600111'};
      final remote = {'phone': '600222'};

      final merged = FieldMergeResolver.applyChoices(
        local: local,
        remote: remote,
        useLocalByField: const {},
      );

      expect(merged['phone'], '600111');
    });
  });
}
