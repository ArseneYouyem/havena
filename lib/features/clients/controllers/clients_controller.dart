import 'dart:async';
import 'package:get/get.dart';
import 'package:havena/core/database/app_database.dart';
import 'package:havena/core/database/enums.dart';
import 'package:havena/features/auth/controllers/session_controller.dart';
import 'package:havena/features/clients/repositories/clients_repository.dart';

class ClientsController extends GetxController {
  ClientsController(this._repository, this._sessionController);

  final ClientsRepository _repository;
  final SessionController _sessionController;

  final clients = <Client>[].obs;
  final searchQuery = ''.obs;

  final editingId = Rxn<int>();

  final fullName = Rxn<String>();
  final phone = Rxn<String>();
  final whatsapp = Rxn<String>();
  final email = Rxn<String>();
  final country = Rxn<String>();
  final city = Rxn<String>();
  final clientType = Rxn<String>();
  final logementReference = Rxn<String>();
  final subscriptionFormula = Rxn<String>();
  final startDate = Rxn<DateTime>();
  final renewalDate = Rxn<DateTime>();
  final status = Rxn<ClientStatus>();
  final lastContactDate = Rxn<DateTime>();
  final notes = Rxn<String>();

  final isSaving = false.obs;
  final formError = Rxn<String>();

  StreamSubscription<List<Client>>? _clientsSub;

  @override
  void onInit() {
    super.onInit();
    _clientsSub = _repository.watchAll().listen((data) {
      clients.value = data;
    });
  }

  @override
  void onClose() {
    _clientsSub?.cancel();
    super.onClose();
  }

  List<Client> visibleClients() {
    final query = searchQuery.value.toLowerCase().trim();
    if (query.isEmpty) return clients;
    return clients.where((client) {
      return client.fullName.toLowerCase().contains(query) ||
          client.reference.toLowerCase().contains(query) ||
          client.phone.toLowerCase().contains(query);
    }).toList();
  }

  void openCreateForm() {
    editingId.value = null;
    fullName.value = null;
    phone.value = null;
    whatsapp.value = null;
    email.value = null;
    country.value = null;
    city.value = null;
    clientType.value = null;
    logementReference.value = null;
    subscriptionFormula.value = null;
    startDate.value = null;
    renewalDate.value = null;
    status.value = ClientStatus.actif;
    lastContactDate.value = null;
    notes.value = null;
    isSaving.value = false;
    formError.value = null;
  }

  void openEditForm(Client client) {
    editingId.value = client.id;
    fullName.value = client.fullName;
    phone.value = client.phone;
    whatsapp.value = client.whatsapp;
    email.value = client.email;
    country.value = client.country;
    city.value = client.city;
    clientType.value = client.clientType;
    logementReference.value = client.logementReference;
    subscriptionFormula.value = client.subscriptionFormula;
    startDate.value = client.startDate;
    renewalDate.value = client.renewalDate;
    status.value = client.status;
    lastContactDate.value = client.lastContactDate;
    notes.value = client.notes;
    isSaving.value = false;
    formError.value = null;
  }

  Future<void> submitForm() async {
    if (fullName.value == null ||
        fullName.value!.trim().isEmpty ||
        phone.value == null ||
        phone.value!.trim().isEmpty ||
        country.value == null ||
        country.value!.trim().isEmpty ||
        city.value == null ||
        city.value!.trim().isEmpty ||
        clientType.value == null ||
        clientType.value!.trim().isEmpty ||
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
          fullName: fullName.value!.trim(),
          phone: phone.value!.trim(),
          whatsapp: whatsapp.value,
          email: email.value,
          country: country.value!.trim(),
          city: city.value!.trim(),
          clientType: clientType.value!.trim(),
          logementReference: logementReference.value,
          subscriptionFormula: subscriptionFormula.value,
          startDate: startDate.value,
          renewalDate: renewalDate.value,
          status: status.value!,
          lastContactDate: lastContactDate.value,
          notes: notes.value,
          updatedBy: currentUid,
        );
      } else {
        await _repository.update(
          id: id,
          fullName: fullName.value!.trim(),
          phone: phone.value!.trim(),
          whatsapp: whatsapp.value,
          email: email.value,
          country: country.value!.trim(),
          city: city.value!.trim(),
          clientType: clientType.value!.trim(),
          logementReference: logementReference.value,
          subscriptionFormula: subscriptionFormula.value,
          startDate: startDate.value,
          renewalDate: renewalDate.value,
          status: status.value!,
          lastContactDate: lastContactDate.value,
          notes: notes.value,
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

  Future<void> deleteClient(int id) async {
    await _repository.delete(id);
  }
}
