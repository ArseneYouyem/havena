import 'package:havena/core/database/enums.dart';

/// Checklist officielle d'inspection HAVENA (cahier des charges §12).
/// Sert à générer automatiquement les `InspectionItem` à la création
/// d'une inspection.
class InspectionChecklist {
  InspectionChecklist._();

  static const Map<InspectionCategory, List<String>> items = {
    InspectionCategory.general: [
      'Portes',
      'Serrures',
      'Fenêtres',
      'Murs',
      'Plafonds',
      'Sols',
      'Humidité',
    ],
    InspectionCategory.plomberie: [
      'Robinets',
      'Évacuations',
      'WC',
      'Fuites',
      'Pression',
    ],
    InspectionCategory.electricite: [
      'Éclairage',
      'Prises',
      'Tableau visible',
      'Câbles apparents',
      'Traces de brûlure',
    ],
    InspectionCategory.climatisation: [
      'Démarrage',
      'Refroidissement',
      'Télécommande',
      'Bruit',
      'Fuite visible',
    ],
    InspectionCategory.securite: [
      'Portes',
      'Fenêtres',
      'Portail',
      'Alarme',
      'Détecteur de fumée',
    ],
    InspectionCategory.autres: [
      'Cuisine',
      'Chambres / salon',
      'Extérieur',
      'Propreté',
    ],
  };

  static const Map<InspectionCategory, String> categoryLabels = {
    InspectionCategory.general: 'Général',
    InspectionCategory.plomberie: 'Plomberie',
    InspectionCategory.electricite: 'Électricité',
    InspectionCategory.climatisation: 'Climatisation',
    InspectionCategory.securite: 'Sécurité',
    InspectionCategory.autres: 'Autres',
  };
}
