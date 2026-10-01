import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

import 'package:havena/core/database/enums.dart';
import 'package:havena/core/database/tables/abonnements_table.dart';
import 'package:havena/core/database/tables/calendrier_evenements_table.dart';
import 'package:havena/core/database/tables/clients_table.dart';
import 'package:havena/core/database/tables/finances_table.dart';
import 'package:havena/core/database/tables/inspection_items_table.dart';
import 'package:havena/core/database/tables/inspections_table.dart';
import 'package:havena/core/database/tables/interventions_table.dart';
import 'package:havena/core/database/tables/logements_table.dart';
import 'package:havena/core/database/tables/modeles_documents_table.dart';
import 'package:havena/core/database/tables/photos_table.dart';
import 'package:havena/core/database/tables/prestataires_table.dart';
import 'package:havena/core/database/tables/rapports_table.dart';
import 'package:havena/core/database/tables/sync_log_table.dart';
import 'package:havena/core/database/tables/users_table.dart';

import 'package:havena/core/database/daos/abonnements_dao.dart';
import 'package:havena/core/database/daos/calendrier_evenements_dao.dart';
import 'package:havena/core/database/daos/clients_dao.dart';
import 'package:havena/core/database/daos/finances_dao.dart';
import 'package:havena/core/database/daos/inspection_items_dao.dart';
import 'package:havena/core/database/daos/inspections_dao.dart';
import 'package:havena/core/database/daos/interventions_dao.dart';
import 'package:havena/core/database/daos/logements_dao.dart';
import 'package:havena/core/database/daos/modeles_documents_dao.dart';
import 'package:havena/core/database/daos/photos_dao.dart';
import 'package:havena/core/database/daos/prestataires_dao.dart';
import 'package:havena/core/database/daos/rapports_dao.dart';
import 'package:havena/core/database/daos/sync_log_dao.dart';
import 'package:havena/core/database/daos/users_dao.dart';

part 'app_database.g.dart';

@DriftDatabase(
  tables: [
    Users,
    Clients,
    Logements,
    Abonnements,
    Inspections,
    InspectionItems,
    Interventions,
    Prestataires,
    Finances,
    Photos,
    Rapports,
    ModelesDocuments,
    CalendrierEvenements,
    SyncLog,
  ],
  daos: [
    UsersDao,
    ClientsDao,
    LogementsDao,
    AbonnementsDao,
    InspectionsDao,
    InspectionItemsDao,
    InterventionsDao,
    PrestatairesDao,
    FinancesDao,
    PhotosDao,
    RapportsDao,
    ModelesDocumentsDao,
    CalendrierEvenementsDao,
    SyncLogDao,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? executor])
      : super(executor ?? driftDatabase(name: 'havena'));

  @override
  int get schemaVersion => 4;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onUpgrade: (m, from, to) async {
          // v1 -> v2 : ajout de `syncId` (UUID) sur les tables métier, pour
          // la synchronisation Firestore multi-appareils (les `id` locaux
          // auto-incrémentés et les références HAV-XXX peuvent entrer en
          // collision entre appareils, `syncId` non).
          if (from < 2) {
            await m.addColumn(clients, clients.syncId);
            await m.addColumn(logements, logements.syncId);
            await m.addColumn(abonnements, abonnements.syncId);
            await m.addColumn(interventions, interventions.syncId);
            await m.addColumn(prestataires, prestataires.syncId);
            await m.addColumn(finances, finances.syncId);
            await m.addColumn(rapports, rapports.syncId);
            await m.addColumn(inspections, inspections.syncId);
            await m.addColumn(
                calendrierEvenements, calendrierEvenements.syncId);

            // Comble `sync_id` pour les lignes déjà existantes (créées
            // avant l'introduction de la colonne). `randomblob(16)` suffit
            // largement en unicité, pas besoin du format UUID exact ici :
            // le champ n'est jamais affiché, seulement comparé.
            for (final tableName in [
              'clients',
              'logements',
              'abonnements',
              'interventions',
              'prestataires',
              'finances',
              'rapports',
              'inspections',
              'calendrier_evenements',
            ]) {
              await customStatement(
                'UPDATE $tableName SET sync_id = lower(hex(randomblob(16))) WHERE sync_id IS NULL',
              );
            }
          }

          // v2 -> v3 : ajout de `googleEventId` sur Calendrier, pour la
          // synchronisation vers un calendrier secondaire Google « HAVENA »
          // (compte Drive partagé de l'entreprise, voir
          // `GoogleCalendarSyncService`).
          if (from < 3) {
            await m.addColumn(
                calendrierEvenements, calendrierEvenements.googleEventId);
          }

          // v3 -> v4 : lien Interventions -> Inspections (retour
          // utilisateur : « on ne fait pas d'intervention sans
          // inspection »). Nullable pour ne pas casser les interventions
          // déjà existantes (jamais comblé rétroactivement : rien ne
          // permet de savoir fiablement à quelle inspection une ancienne
          // intervention se rapportait).
          if (from < 4) {
            await m.addColumn(interventions, interventions.inspectionId);
          }
        },
      );
}
