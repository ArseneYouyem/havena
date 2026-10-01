import 'package:havena/shared/widgets/layout/page_header.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:havena/app/theme/app_colors.dart';
import 'package:havena/core/database/app_database.dart';
import 'package:havena/core/database/enums.dart';
import 'package:havena/features/auth/controllers/session_controller.dart';
import 'package:havena/features/calendrier/controllers/calendrier_controller.dart';

class CalendrierContent extends GetView<CalendrierController> {
  const CalendrierContent({super.key});

  /// Types sélectionnables à la création MANUELLE d'un évènement (retour
  /// utilisateur) : Inspection et Intervention sont désormais créés
  /// automatiquement par leurs modules respectifs, jamais à la main ici.
  static const _manualEventTypes = [
    CalendarEventType.rendezVous,
    CalendarEventType.renouvellement,
    CalendarEventType.visiteUrgente,
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const PageHeader(
            title: 'Calendrier',
            subtitle: 'Organisez les rendez-vous et les interventions.',
            icon: Icons.calendar_month_outlined,
          ),
          const SizedBox(height: 16),
          Obx(() {
            final today = controller.todayEvents;
            if (today.isEmpty) return const SizedBox.shrink();
            return _buildTodayCard(today);
          }),
          Row(
            children: [
              Expanded(
                child: TextField(
                  onChanged: (value) => controller.searchQuery.value = value,
                  decoration: _inputDecoration(
                    'Rechercher un événement',
                    prefixIcon: const Icon(Icons.search),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              ElevatedButton.icon(
                onPressed: () => _showFormDialog(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                ),
                icon: const Icon(Icons.add),
                label: const Text('Nouvel événement'),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(width: 320, child: _buildCalendarCard(context)),
                const SizedBox(width: 16),
                Expanded(child: _buildEventsPanel(context)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // CALENDRIER (grille du mois)
  // ---------------------------------------------------------------------------
  static const _weekdayLabels = ['Lun', 'Mar', 'Mer', 'Jeu', 'Ven', 'Sam', 'Dim'];
  static const _monthLabels = [
    'Janvier',
    'Février',
    'Mars',
    'Avril',
    'Mai',
    'Juin',
    'Juillet',
    'Août',
    'Septembre',
    'Octobre',
    'Novembre',
    'Décembre',
  ];

  Widget _buildCalendarCard(BuildContext context) {
    return Card(
      color: AppColors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: AppColors.border),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Obx(() {
          final month = controller.visibleMonth.value ??
              DateTime(DateTime.now().year, DateTime.now().month);
          final selected = controller.selectedDay.value;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.chevron_left),
                    color: AppColors.textPrimary,
                    onPressed: controller.goToPreviousMonth,
                  ),
                  Expanded(
                    child: Text(
                      '${_monthLabels[month.month - 1]} ${month.year}',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.chevron_right),
                    color: AppColors.textPrimary,
                    onPressed: controller.goToNextMonth,
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Row(
                children: _weekdayLabels
                    .map(
                      (label) => Expanded(
                        child: Center(
                          child: Text(
                            label,
                            style: const TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    )
                    .toList(),
              ),
              const SizedBox(height: 4),
              ..._buildWeeks(month, selected),
              if (selected != null) ...[
                const SizedBox(height: 8),
                Center(
                  child: TextButton.icon(
                    onPressed: () => controller.selectDay(null),
                    icon: const Icon(Icons.clear, size: 16),
                    label: const Text('Afficher tous les événements'),
                    style: TextButton.styleFrom(
                      foregroundColor: AppColors.primary,
                    ),
                  ),
                ),
              ],
            ],
          );
        }),
      ),
    );
  }

  List<Widget> _buildWeeks(DateTime month, DateTime? selected) {
    final firstDay = DateTime(month.year, month.month, 1);
    final daysInMonth = DateTime(month.year, month.month + 1, 0).day;
    // `weekday` : lundi = 1 ... dimanche = 7 -> nombre de cases vides avant
    // le 1er du mois pour une grille commençant le lundi.
    final leadingBlanks = firstDay.weekday - 1;
    final totalCells = leadingBlanks + daysInMonth;
    final rows = (totalCells / 7).ceil();

    final weeks = <Widget>[];
    var dayCounter = 1;
    for (var row = 0; row < rows; row++) {
      final cells = <Widget>[];
      for (var col = 0; col < 7; col++) {
        final cellIndex = row * 7 + col;
        if (cellIndex < leadingBlanks || dayCounter > daysInMonth) {
          cells.add(const Expanded(child: SizedBox(height: 36)));
        } else {
          final day = DateTime(month.year, month.month, dayCounter);
          cells.add(_buildDayCell(day, selected));
          dayCounter++;
        }
      }
      weeks.add(Row(children: cells));
    }
    return weeks;
  }

  Widget _buildDayCell(DateTime day, DateTime? selected) {
    final now = DateTime.now();
    final isToday = _isSameDay(day, now);
    final isSelected = selected != null && _isSameDay(day, selected);
    final hasEvent = controller.hasEventOn(day);
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(2),
        child: InkWell(
          borderRadius: BorderRadius.circular(8),
          onTap: () => controller.selectDay(isSelected ? null : day),
          child: Container(
            height: 36,
            decoration: BoxDecoration(
              color: isSelected
                  ? AppColors.primary
                  : isToday
                      ? AppColors.primary.withValues(alpha: 0.1)
                      : Colors.transparent,
              borderRadius: BorderRadius.circular(8),
              border: isToday && !isSelected
                  ? Border.all(color: AppColors.primary)
                  : null,
            ),
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '${day.day}',
                  style: TextStyle(
                    color:
                        isSelected ? Colors.white : AppColors.textPrimary,
                    fontWeight:
                        isToday ? FontWeight.bold : FontWeight.normal,
                    fontSize: 13,
                  ),
                ),
                if (hasEvent)
                  Container(
                    margin: const EdgeInsets.only(top: 2),
                    width: 4,
                    height: 4,
                    decoration: BoxDecoration(
                      color: isSelected ? Colors.white : AppColors.secondary,
                      shape: BoxShape.circle,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  // ---------------------------------------------------------------------------
  // PANNEAU DES ÉVÉNEMENTS (droite)
  // ---------------------------------------------------------------------------
  Widget _buildEventsPanel(BuildContext context) {
    return Obx(() {
      final list = controller.displayedEvents();
      final selected = controller.selectedDay.value;
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            selected == null
                ? 'Tous les événements'
                : 'Événements du ${_formatDateOnly(selected)}',
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontSize: 15,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: list.isEmpty
                ? Center(
                    child: Text(
                      controller.events.isEmpty
                          ? 'Aucun événement'
                          : selected == null
                              ? 'Aucun résultat'
                              : 'Aucun événement ce jour-là',
                      style: const TextStyle(color: AppColors.textSecondary),
                    ),
                  )
                : ListView.builder(
                    itemCount: list.length,
                    itemBuilder: (context, index) =>
                        _buildEventCard(context, list[index]),
                  ),
          ),
        ],
      );
    });
  }

  Widget _buildEventCard(BuildContext context, CalendrierEvenement event) {
    return Card(
      color: AppColors.surface,
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: ListTile(
        leading: Icon(
          _eventIcon(event.eventType),
          color: AppColors.primary,
        ),
        title: Text(
          event.title,
          style: const TextStyle(color: AppColors.textPrimary),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _formatDateTime(event.eventDate),
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 12,
              ),
            ),
            if (event.relatedReference != null &&
                event.relatedReference!.isNotEmpty)
              Text(
                event.relatedReference!,
                style: const TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 12,
                ),
              ),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildStatusBadge(event.status),
            const SizedBox(width: 8),
            IconButton(
              icon: const Icon(Icons.edit_outlined),
              color: AppColors.textSecondary,
              onPressed: () => _showFormDialog(context, event: event),
            ),
            if (Get.find<SessionController>().isFondatrice)
              IconButton(
                icon: const Icon(Icons.delete_outline),
                color: AppColors.error,
                onPressed: () => _confirmDelete(context, event),
              ),
          ],
        ),
      ),
    );
  }

  String _formatDateOnly(DateTime date) {
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    return '$day/$month/${date.year}';
  }

  Widget _buildTodayCard(List<CalendrierEvenement> todayEvents) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: AppColors.primary.withValues(alpha: 0.08),
          border: Border.all(color: AppColors.primary),
          borderRadius: BorderRadius.circular(8),
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Tâches du jour',
              style: TextStyle(
                color: AppColors.primary,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 8),
            ...todayEvents.map((event) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  children: [
                    Icon(
                      _eventIcon(event.eventType),
                      size: 20,
                      color: AppColors.primary,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        event.title,
                        style: const TextStyle(
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    Text(
                      _formatTime(event.eventDate),
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(width: 8),
                    _buildStatusBadge(event.status),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  void _showFormDialog(BuildContext context, {CalendrierEvenement? event}) {
    if (event != null) {
      controller.openEditForm(event);
    } else {
      controller.openCreateForm();
    }

    Get.dialog(
      AlertDialog(
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: const BorderSide(color: AppColors.border),
        ),
        title: Text(
          event == null ? 'Nouvel événement' : 'Modifier l\'événement',
          style: const TextStyle(color: AppColors.textPrimary),
        ),
        content: SizedBox(
          width: 500,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Obx(() {
                  // Un évènement Inspection/Intervention existant (créé
                  // automatiquement) garde son type affiché même s'il n'est
                  // plus sélectionnable pour une NOUVELLE création — sinon
                  // `DropdownButtonFormField` lève une erreur (valeur
                  // courante absente de `items`).
                  final selectableTypes = {
                    ..._manualEventTypes,
                    if (controller.eventType.value != null)
                      controller.eventType.value!,
                  }.toList();
                  return DropdownButtonFormField<CalendarEventType>(
                    initialValue: controller.eventType.value,
                    decoration: _inputDecoration('Type d\'événement *'),
                    items: selectableTypes.map((type) {
                      return DropdownMenuItem(
                        value: type,
                        child: Text(_eventTypeLabel(type)),
                      );
                    }).toList(),
                    onChanged: (value) {
                      controller.eventType.value = value;
                    },
                  );
                }),
                const SizedBox(height: 16),
                TextField(
                  controller: TextEditingController(
                    text: controller.title.value,
                  ),
                  onChanged: (value) => controller.title.value = value,
                  decoration: _inputDecoration('Titre *'),
                ),
                const SizedBox(height: 16),
                Obx(() {
                  final date = controller.eventDate.value;
                  return InkWell(
                    onTap: () => _pickDateTime(context),
                    child: InputDecorator(
                      decoration: _inputDecoration('Date et heure *'),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            date == null
                                ? 'Sélectionner'
                                : _formatDateTime(date),
                            style: const TextStyle(
                              color: AppColors.textPrimary,
                            ),
                          ),
                          const Icon(
                            Icons.calendar_today_outlined,
                            size: 20,
                            color: AppColors.textSecondary,
                          ),
                        ],
                      ),
                    ),
                  );
                }),
                const SizedBox(height: 16),
                TextField(
                  controller: TextEditingController(
                    text: controller.relatedReference.value,
                  ),
                  onChanged: (value) =>
                      controller.relatedReference.value = value,
                  decoration: _inputDecoration(
                    'Référence associée (optionnel)',
                  ),
                ),
                const SizedBox(height: 16),
                Obx(() {
                  return DropdownButtonFormField<CalendarEventStatus>(
                    initialValue: controller.status.value,
                    decoration: _inputDecoration('Statut *'),
                    items: CalendarEventStatus.values.map((status) {
                      return DropdownMenuItem(
                        value: status,
                        child: Text(_statusLabel(status)),
                      );
                    }).toList(),
                    onChanged: (value) {
                      controller.status.value = value;
                    },
                  );
                }),
                Obx(() {
                  final error = controller.formError.value;
                  if (error == null) return const SizedBox(height: 16);
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Text(
                      error,
                      style: const TextStyle(color: AppColors.error),
                      textAlign: TextAlign.center,
                    ),
                  );
                }),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text(
              'Annuler',
              style: TextStyle(color: AppColors.textSecondary),
            ),
          ),
          Obx(() {
            final saving = controller.isSaving.value;
            return ElevatedButton(
              onPressed: saving ? null : controller.submitForm,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
              ),
              child: saving
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                  : const Text('Enregistrer'),
            );
          }),
        ],
      ),
    );
  }

  Future<void> _pickDateTime(BuildContext context) async {
    final now = controller.eventDate.value ?? DateTime.now();
    final date = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (date == null) return;
    if (!context.mounted) return;
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(now),
    );
    if (time == null) return;
    controller.eventDate.value = DateTime(
      date.year,
      date.month,
      date.day,
      time.hour,
      time.minute,
    );
  }

  IconData _eventIcon(CalendarEventType type) {
    switch (type) {
      case CalendarEventType.inspection:
        return Icons.fact_check_outlined;
      case CalendarEventType.intervention:
        return Icons.build_outlined;
      case CalendarEventType.rendezVous:
        return Icons.event_outlined;
      case CalendarEventType.renouvellement:
        return Icons.autorenew;
      case CalendarEventType.visiteUrgente:
        return Icons.priority_high;
    }
  }

  String _eventTypeLabel(CalendarEventType type) {
    switch (type) {
      case CalendarEventType.inspection:
        return 'Inspection';
      case CalendarEventType.intervention:
        return 'Intervention';
      case CalendarEventType.rendezVous:
        return 'Rendez-vous';
      case CalendarEventType.renouvellement:
        return 'Renouvellement';
      case CalendarEventType.visiteUrgente:
        return 'Visite urgente';
    }
  }

  String _statusLabel(CalendarEventStatus status) {
    switch (status) {
      case CalendarEventStatus.planifie:
        return 'Planifié';
      case CalendarEventStatus.termine:
        return 'Terminé';
      case CalendarEventStatus.annule:
        return 'Annulé';
    }
  }

  Widget _buildStatusBadge(CalendarEventStatus status) {
    Color color;
    switch (status) {
      case CalendarEventStatus.planifie:
        color = AppColors.primary;
        break;
      case CalendarEventStatus.termine:
        color = AppColors.success;
        break;
      case CalendarEventStatus.annule:
        color = AppColors.textSecondary;
        break;
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        _statusLabel(status),
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  String _formatDateTime(DateTime date) {
    final day = date.day.toString().padLeft(2, '0');
    final month = date.month.toString().padLeft(2, '0');
    final year = date.year.toString();
    final hour = date.hour.toString().padLeft(2, '0');
    final minute = date.minute.toString().padLeft(2, '0');
    return '$day/$month/$year $hour:$minute';
  }

  String _formatTime(DateTime date) {
    final hour = date.hour.toString().padLeft(2, '0');
    final minute = date.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  InputDecoration _inputDecoration(String label, {Widget? prefixIcon}) {
    return InputDecoration(
      labelText: label,
      prefixIcon: prefixIcon,
      border: const OutlineInputBorder(
        borderSide: BorderSide(color: AppColors.border),
      ),
      enabledBorder: const OutlineInputBorder(
        borderSide: BorderSide(color: AppColors.border),
      ),
      focusedBorder: const OutlineInputBorder(
        borderSide: BorderSide(color: AppColors.primary),
      ),
    );
  }

  void _confirmDelete(BuildContext context, CalendrierEvenement event) {
    Get.dialog(
      AlertDialog(
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: const BorderSide(color: AppColors.border),
        ),
        title: const Text(
          'Confirmer la suppression',
          style: TextStyle(color: AppColors.textPrimary),
        ),
        content: Text(
          'Supprimer l\'événement ${event.title} ?',
          style: const TextStyle(color: AppColors.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text(
              'Annuler',
              style: TextStyle(color: AppColors.textSecondary),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Get.back();
              controller.deleteEvent(event.id);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
              foregroundColor: Colors.white,
            ),
            child: const Text('Supprimer'),
          ),
        ],
      ),
    );
  }
}
