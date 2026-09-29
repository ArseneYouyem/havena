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
  int get schemaVersion => 1;
}
