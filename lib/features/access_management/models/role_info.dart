import 'package:havena/core/database/enums.dart';

class RoleInfo {
  final AppRole role;
  final String label;
  final String description;

  const RoleInfo({
    required this.role,
    required this.label,
    required this.description,
  });

  static const List<RoleInfo> all = [
    RoleInfo(
      role: AppRole.fondatrice,
      label: 'Fondatrice',
      description:
          'Accès complet à toutes les fonctionnalités, y compris la gestion des accès.',
    ),
    RoleInfo(
      role: AppRole.coordinateur,
      label: 'Coordinateur',
      description:
          'Accès clients, logements, abonnements, inspections, interventions, prestataires, finances, rapports, calendrier — pas de gestion des accès.',
    ),
    RoleInfo(
      role: AppRole.agent,
      label: 'Agent',
      description: 'Uniquement les inspections.',
    ),
  ];
}
