/// Construit les lignes d'une feuille Google Sheets à partir des documents
/// génériques déjà produits par `EntitySyncAdapter.toFirestoreMap` — réutilise
/// donc exactement les mêmes champs que la synchronisation Firestore, sans
/// dupliquer de logique de sérialisation par module.
///
/// Limite assumée (vue de convenance en lecture seule, pas une relation) :
/// les clés étrangères apparaissent sous leur forme `xxxSyncId` (UUID), pas
/// sous un nom lisible — un utilisateur qui veut le détail croise via la
/// référence HAVENA affichée sur la ligne elle-même.
List<List<Object?>> buildSheetRows(
  List<Map<String, dynamic>> documents,
  List<String> headers,
) {
  return documents.map((doc) {
    return headers.map((header) => _cellValue(doc[header])).toList();
  }).toList();
}

/// Google Sheets accepte uniquement `bool`, `String`, `num` (et les
/// `Map`/`List` imbriqués) comme valeurs de cellule — jamais `null` (les
/// valeurs `null` sont ignorées côté API, on les remplace donc par une
/// chaîne vide pour que la cellule existe bien, vide, plutôt que d'être
/// simplement absente).
Object? _cellValue(Object? value) {
  if (value == null) return '';
  return value;
}
