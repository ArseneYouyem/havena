import 'dart:async';
import 'package:get/get.dart';
import 'package:havena/core/database/app_database.dart';
import 'package:havena/core/database/enums.dart';
import 'package:havena/features/auth/controllers/session_controller.dart';
import 'package:havena/features/calendrier/repositories/calendrier_repository.dart';

class CalendrierController extends GetxController {
  CalendrierController(this._repository, this._sessionController);

  final CalendrierRepository _repository;
  final SessionController _sessionController;

  final events = <CalendrierEvenement>[].obs;
  final searchQuery = ''.obs;

  final editingId = Rxn<int>();

  final eventType = Rxn<CalendarEventType>();
  final title = Rxn<String>();
  final eventDate = Rxn<DateTime>();
  final relatedReference = Rxn<String>();
  final status = Rxn<CalendarEventStatus>();

  final isSaving = false.obs;
  final formError = Rxn<String>();

  StreamSubscription<List<CalendrierEvenement>>? _eventsSub;

  @override
  void onInit() {
    super.onInit();
    _eventsSub = _repository.watchAll().listen((data) {
      events.value = data;
    });
  }

  @override
  void onClose() {
    _eventsSub?.cancel();
    super.onClose();
  }

  List<CalendrierEvenement> visibleEvents() {
    final query = searchQuery.value.toLowerCase().trim();
    if (query.isEmpty) return events;
    return events.where((event) {
      final related = event.relatedReference ?? '';
      return event.title.toLowerCase().contains(query) ||
          related.toLowerCase().contains(query);
    }).toList();
  }

  List<CalendrierEvenement> sortedEvents() {
    final visible = visibleEvents();
    visible.sort((a, b) => a.eventDate.compareTo(b.eventDate));
    return visible;
  }

  List<CalendrierEvenement> get todayEvents {
    final now = DateTime.now();
    return events.where((event) {
      return event.eventDate.year == now.year &&
          event.eventDate.month == now.month &&
          event.eventDate.day == now.day;
    }).toList();
  }

  void openCreateForm() {
    editingId.value = null;
    eventType.value = CalendarEventType.rendezVous;
    title.value = null;
    eventDate.value = DateTime.now();
    relatedReference.value = null;
    status.value = CalendarEventStatus.planifie;
    isSaving.value = false;
    formError.value = null;
  }

  void openEditForm(CalendrierEvenement event) {
    editingId.value = event.id;
    eventType.value = event.eventType;
    title.value = event.title;
    eventDate.value = event.eventDate;
    relatedReference.value = event.relatedReference;
    status.value = event.status;
    isSaving.value = false;
    formError.value = null;
  }

  Future<void> submitForm() async {
    if (title.value == null ||
        title.value!.trim().isEmpty ||
        eventDate.value == null ||
        eventType.value == null ||
        status.value == null) {
      formError.value = 'Veuillez remplir tous les champs obligatoires.';
      return;
    }

    isSaving.value = true;
    formError.value = null;
    try {
      final currentUid = _sessionController.session.value?.uid ?? 'system';
      final id = editingId.value;
      if (id == null) {
        await _repository.create(
          eventType: eventType.value!,
          title: title.value!.trim(),
          eventDate: eventDate.value!,
          relatedReference: relatedReference.value,
          status: status.value!,
          updatedBy: currentUid,
        );
      } else {
        await _repository.update(
          id: id,
          eventType: eventType.value!,
          title: title.value!.trim(),
          eventDate: eventDate.value!,
          relatedReference: relatedReference.value,
          status: status.value!,
          updatedBy: currentUid,
        );
      }
      Get.back();
    } catch (e) {
      formError.value = 'Erreur lors de l\'enregistrement : $e';
    } finally {
      isSaving.value = false;
    }
  }

  Future<void> deleteEvent(int id) async {
    await _repository.delete(id);
  }
}
