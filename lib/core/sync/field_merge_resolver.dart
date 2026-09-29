/// Résolution de conflit champ par champ (cahier des charges, décidée avec
/// l'utilisateur) : indépendante du type d'entité, travaille sur des
/// `Map<String, dynamic>` génériques (clé = nom de champ Firestore).
class FieldMergeResolver {
  FieldMergeResolver._();

  /// Liste triée des clés dont la valeur diffère entre [local] et [remote].
  static List<String> differingFields(
    Map<String, dynamic> local,
    Map<String, dynamic> remote,
  ) {
    final keys = {...local.keys, ...remote.keys};
    return keys.where((key) => local[key] != remote[key]).toList()..sort();
  }

  /// Fusion automatique : priorité à la valeur remplie ; si les deux
  /// valeurs sont renseignées et différentes, priorité à la valeur locale
  /// (celle que l'utilisateur voit et peut corriger lui-même juste après).
  static Map<String, dynamic> autoMerge(
    Map<String, dynamic> local,
    Map<String, dynamic> remote,
  ) {
    final merged = <String, dynamic>{};
    final keys = {...local.keys, ...remote.keys};
    for (final key in keys) {
      final localValue = local[key];
      final remoteValue = remote[key];
      merged[key] =
          _isEmpty(localValue) && !_isEmpty(remoteValue) ? remoteValue : localValue;
    }
    return merged;
  }

  /// Applique un ensemble de choix par champ (`fieldKey -> useLocal`) pour
  /// construire le document final, en repartant de [local] ou [remote]
  /// selon le choix explicite de l'utilisateur.
  static Map<String, dynamic> applyChoices({
    required Map<String, dynamic> local,
    required Map<String, dynamic> remote,
    required Map<String, bool> useLocalByField,
  }) {
    final merged = <String, dynamic>{};
    final keys = {...local.keys, ...remote.keys};
    for (final key in keys) {
      final useLocal = useLocalByField[key] ?? true;
      merged[key] = useLocal ? local[key] : remote[key];
    }
    return merged;
  }

  static bool _isEmpty(dynamic value) {
    if (value == null) return true;
    if (value is String) return value.isEmpty;
    return false;
  }
}
