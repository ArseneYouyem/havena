import 'package:havena/shared/widgets/layout/page_header.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:havena/app/theme/app_colors.dart';
import 'package:havena/features/auth/controllers/session_controller.dart';
import 'package:havena/features/dashboard/controllers/dashboard_controller.dart';
import 'package:havena/features/dashboard/views/procedure_coordinateur_view.dart';

/// Sépare les milliers d'un montant sans dépendre du package `intl`
/// (non installé) — ex. 1234567 -> "1 234 567".
String _formatAmount(double amount) {
  final rounded = amount.round().abs();
  final digits = rounded.toString();
  final buffer = StringBuffer();
  for (var i = 0; i < digits.length; i++) {
    if (i > 0 && (digits.length - i) % 3 == 0) buffer.write(' ');
    buffer.write(digits[i]);
  }
  final sign = amount < 0 ? '-' : '';
  return '$sign${buffer.toString()} FCFA';
}

class DashboardContent extends GetView<DashboardController> {
  const DashboardContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.showProcedure.value) {
        return const ProcedureCoordinateurView();
      }
      return _buildDashboard(context);
    });
  }

  Widget _buildDashboard(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const PageHeader(
            title: 'Tableau de bord',
            subtitle: 'Une vue d’ensemble de votre activité.',
            icon: Icons.dashboard_outlined,
          ),
          const SizedBox(height: 24),
          Obx(() => _AlertsSection(alerts: controller.alerts.toList())),
          const SizedBox(height: 8),
          LayoutBuilder(builder: (context, constraints) {
            // Cartes de largeur responsive : au lieu d'une largeur fixe qui
            // laisse un grand espace vide à droite sur un écran large,
            // calcule le nombre de colonnes qui tiennent (au moins 220px
            // chacune) et étire les cartes pour remplir toute la largeur
            // disponible (retour utilisateur).
            const minCardWidth = 220.0;
            const spacing = 16.0;
            final columns =
                ((constraints.maxWidth + spacing) / (minCardWidth + spacing))
                    .floor()
                    .clamp(1, 8);
            final cardWidth =
                (constraints.maxWidth - spacing * (columns - 1)) / columns;

            // Les lectures `.value` doivent se faire À L'INTÉRIEUR du
            // callback Obx pour être suivies par GetX — les faire ici,
            // avant le retour de l'Obx, ne déclencherait jamais de mise à
            // jour réactive (piège déjà rencontré sur `_AlertsSection`).
            // Rôle stable pendant la session : lu une seule fois, pas
            // besoin d'un Obx dédié (retour utilisateur §7 — le
            // coordinateur ne voit aucune card liée aux finances).
            final isFondatrice = Get.find<SessionController>().isFondatrice;

            return Obx(() {
              final cards = <Widget>[
              if (isFondatrice) ...[
                _IndicatorCard(
                  label: 'Chiffre d\'affaires (mois)',
                  value:
                      _formatAmount(controller.chiffreAffairesMensuel.value),
                  icon: Icons.payments_outlined,
                ),
                _IndicatorCard(
                  label: 'Dépenses (mois)',
                  value: _formatAmount(controller.depensesMensuelles.value),
                  icon: Icons.trending_down,
                  accentColor: AppColors.secondary,
                ),
                _IndicatorCard(
                  label: 'Payé aux prestataires (mois)',
                  value: _formatAmount(
                      controller.montantPayePrestataires.value),
                  icon: Icons.handshake_outlined,
                  accentColor: AppColors.secondary,
                ),
                _IndicatorCard(
                  label: 'Marge HAVENA (mois)',
                  value: _formatAmount(controller.margeMensuelle.value),
                  icon: Icons.trending_up,
                ),
              ],
              _IndicatorCard(
                label: 'Clients actifs',
                value: controller.clientsActifs.value.toString(),
                icon: Icons.people_outline,
              ),
              _IndicatorCard(
                label: 'Logements suivis',
                value: controller.logementsCount.value.toString(),
                icon: Icons.home_work_outlined,
                accentColor: AppColors.secondary,
              ),
              _IndicatorCard(
                label: 'Abonnements actifs',
                value: controller.abonnementsActifs.value.toString(),
                icon: Icons.card_membership_outlined,
              ),
              _IndicatorCard(
                label: 'Abonnements à renouveler',
                value: controller.abonnementsARenouveler.value.toString(),
                icon: Icons.event_repeat_outlined,
                accentColor: controller.abonnementsARenouveler.value > 0
                    ? AppColors.alertYellow
                    : AppColors.secondary,
              ),
              _IndicatorCard(
                label: 'Paiements en attente',
                value: controller.paiementsEnAttente.value.toString(),
                icon: Icons.hourglass_empty,
                accentColor: controller.paiementsEnAttente.value > 0
                    ? AppColors.alertOrange
                    : AppColors.primary,
              ),
              _IndicatorCard(
                label: 'Interventions ouvertes',
                value: controller.interventionsOuvertes.value.toString(),
                icon: Icons.build_outlined,
                accentColor: AppColors.secondary,
              ),
              _IndicatorCard(
                label: 'Interventions terminées',
                value: controller.interventionsTerminees.value.toString(),
                icon: Icons.task_alt_outlined,
              ),
              _IndicatorCard(
                label: 'Incidents ouverts',
                value: controller.incidentsOuverts.value.toString(),
                icon: Icons.report_problem_outlined,
                accentColor: controller.incidentsOuverts.value > 0
                    ? AppColors.alertRed
                    : AppColors.primary,
              ),
              _IndicatorCard(
                label: 'Inspections à effectuer',
                value: controller.inspectionsAEffectuer.value.toString(),
                icon: Icons.pending_actions_outlined,
                accentColor: controller.inspectionsAEffectuer.value > 0
                    ? AppColors.alertYellow
                    : AppColors.secondary,
              ),
              _IndicatorCard(
                label: 'Inspections réalisées',
                value: controller.inspectionsRealisees.value.toString(),
                icon: Icons.fact_check_outlined,
                accentColor: AppColors.secondary,
              ),
              _IndicatorCard(
                label: 'Prestataires actifs',
                value: controller.prestatairesActifs.value.toString(),
                icon: Icons.engineering_outlined,
              ),
              _IndicatorCard(
                label: 'Satisfaction clients',
                value: controller.satisfactionMoyenne.value == null
                    ? 'N/A'
                    : '${controller.satisfactionMoyenne.value!.toStringAsFixed(1)} / 5',
                icon: Icons.star_outline,
                accentColor: AppColors.secondary,
              ),
            ];

              return Wrap(
                spacing: spacing,
                runSpacing: spacing,
                children: cards
                    .map((card) => SizedBox(width: cardWidth, child: card))
                    .toList(),
              );
            });
          }),
          const SizedBox(height: 24),
          _ProcedureCard(onTap: controller.openProcedure),
        ],
      ),
    );
  }
}

/// Carte d'appel à l'action vers la procédure interne du coordinateur
/// (cahier des charges §15) — mise en avant distinctement des indicateurs
/// numériques (retour utilisateur : « un card bien designé »), avec le
/// dégradé de la charte HAVENA.
class _ProcedureCard extends StatelessWidget {
  const _ProcedureCard({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [AppColors.primary, Color(0xFF14532D)],
            ),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withValues(alpha: 0.25),
                blurRadius: 16,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(Icons.route_outlined,
                    color: Colors.white, size: 26),
              ),
              const SizedBox(width: 16),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Procédures internes',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Ce qu\'il faut faire, étape par étape, dès qu\'un client contacte HAVENA.',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: AppColors.secondary,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Consulter',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(width: 4),
                    Icon(Icons.arrow_forward, color: Colors.white, size: 14),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AlertsSection extends StatelessWidget {
  const _AlertsSection({required this.alerts});

  final List<DashboardAlert> alerts;

  Color _colorFor(DashboardAlertLevel level) {
    switch (level) {
      case DashboardAlertLevel.rouge:
        return AppColors.alertRed;
      case DashboardAlertLevel.orange:
        return AppColors.alertOrange;
      case DashboardAlertLevel.jaune:
        return AppColors.alertYellow;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (alerts.isEmpty) {
      return Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: AppColors.alertGreen.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: AppColors.alertGreen),
        ),
        child: const Row(
          children: [
            Icon(Icons.check_circle_outline,
                color: AppColors.alertGreen, size: 18),
            SizedBox(width: 8),
            Text(
              'Aucune alerte — tout est sous contrôle',
              style: TextStyle(
                color: AppColors.alertGreen,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: alerts
          .map((alert) => Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: _colorFor(alert.level).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: _colorFor(alert.level)),
                ),
                child: Row(
                  children: [
                    Icon(Icons.warning_amber_outlined,
                        color: _colorFor(alert.level), size: 18),
                    const SizedBox(width: 8),
                    Text(
                      alert.message,
                      style: TextStyle(
                        color: _colorFor(alert.level),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ))
          .toList(),
    );
  }
}

class _IndicatorCard extends StatelessWidget {
  const _IndicatorCard({
    required this.label,
    required this.value,
    required this.icon,
    this.accentColor = AppColors.primary,
  });

  final String label;
  final String value;
  final IconData icon;
  final Color accentColor;

  @override
  Widget build(BuildContext context) {
    // Pas de hauteur fixe : avec des montants qui peuvent être longs
    // (« 1 234 567 FCFA »), une hauteur figée provoquait un débordement
    // visuel (retour utilisateur) — la carte s'adapte désormais à son
    // contenu, sur 1 ou 2 lignes selon la longueur de la valeur.
    return Card(
      elevation: 0,
      color: AppColors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: accentColor.withValues(alpha: 0.18)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: accentColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: accentColor, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    label,
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    value,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
