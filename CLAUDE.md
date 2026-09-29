# CLAUDE.md

Ce fichier est le point d'entrée pour tout agent IA (Claude Code) travaillant sur ce dépôt. Il doit être lu avant toute modification. Son contenu est identique à [AGENT.md](AGENT.md).

## Documentation de référence (ne pas dupliquer, toujours consulter la source)

- Cahier des charges client (exhaustif) : [docs/HAVENA_Cahier_des_charges.pdf](docs/HAVENA_Cahier_des_charges.pdf)
- Notes d'architecture du développeur : [docs/archtechture.txt](docs/archtechture.txt)
- Notes temporaires / idées en vrac : [docs/temp.md](docs/temp.md)
- Suivi d'avancement par fonctionnalité (à tenir à jour à chaque étape) : [docs/PROGRESS.md](docs/PROGRESS.md)

Ne jamais recopier le contenu de ces documents ailleurs : les citer et y renvoyer.

## Contexte projet

HAVENA est un logiciel de gestion pour un service de type HomeCare / Inspection & Property Care (clients, logements, abonnements, inspections, interventions, prestataires, finances, rapports). Il doit fonctionner sur Windows, macOS, iOS et Android, en priorité **hors connexion** (offline-first), avec une synchronisation explicite vers Google Drive.

Le développement se fait **desktop d'abord** (Windows/macOS). L'UI desktop est dense, multi-panneaux, avec sidebar. L'UI mobile viendra ensuite et peut être différente (plus simple, linéaire) — le responsive n'impose pas un design identique entre plateformes.

## Stack technique imposée

- Flutter SDK `^3.10.8`
- State management + navigation : **GetX** (`get`)
- Stockage local léger (préférences, cache, objets simples) : **GetStorage**
- Base de données locale principale (métier, relationnelle) : **Drift (SQLite)** — `drift`, `drift_flutter`, `path_provider` (deps), `drift_dev` + `build_runner` (dev deps). Depuis Drift 2.32+/sqlite3 3.x, SQLite est bundlé automatiquement sur toutes les plateformes natives (via native assets) : ne pas ajouter `sqlite3_flutter_libs`, il est obsolète (marqué `+eol`) et inutile.
- Synchronisation distante : Google Drive, Google Sheets et Google Calendar via les **API Google Cloud Platform** (projet Firebase `havena-9edff`), en opération explicite (pas de sync automatique silencieuse imposée)
- Authentification et gestion des rôles : **Firebase Auth** (email/mot de passe) + **Cloud Firestore** (liaison compte↔rôle uniquement — voir section « Authentification et rôles »)

## Règles d'architecture impératives

- Structure **feature-first** sous `lib/` : `app/`, `core/`, `features/<feature>/`, `shared/`.
- Séparation stricte **vue / controller**. Aucune logique métier dans les vues.
- Les vues sont des `GetView<XController>` et n'appellent que des méthodes du controller.
- Les controllers ne touchent jamais directement la base de données, Firestore ou l'API Drive : ils passent par des `services`/`repositories`.
- Navigation **centralisée** via `app/routes/` (`AppRoutes`, `AppPages`). Sur desktop, un seul `AppShellView` (route unique, montée une fois) héberge en permanence `DesktopShell` (sidebar + topbar fixes) ; le changement d'onglet ne fait PAS un `Get.toNamed` (qui rejouerait toute la page avec une transition) mais met à jour `NavigationController.currentRoute` (Rx), écouté par un `Obx` qui ne change que le contenu central. Ne jamais recréer le shell à chaque navigation. `AppRoutes` reste la source de vérité des identifiants de section même si toutes ne sont pas des `GetPage` séparées.
- Composants UI réutilisables dans `shared/widgets/` (pas de duplication de composants entre features).
- Chaque entité métier possède une référence unique au format `HAV-XXX-000001` (voir cahier des charges), générée par `ReferenceGeneratorService` (`core/references/`) — jamais saisie manuellement dans un formulaire.
- La gestion des conflits de synchronisation doit être prévue dès la conception des modèles (champs `updated_at`, `updated_by`, statut de sync).
- Couleurs : utiliser exclusivement la charte définie dans `AppColors` (voir section « Charte graphique »), jamais de couleur en dur dans une vue.

## Conventions de nommage

- Fichiers : `snake_case.dart`
- Controller : `XxxController` — Binding : `XxxBinding` — View : `XxxView`
- Repository : `XxxRepository` — Service : `XxxService` — DAO : `XxxDao`
- Modèle : `Xxx`

## Choix base de données locale

**Drift (SQLite)** a été retenu parmi 3 options (Drift, Isar, sqflite/sqlite3 direct).

Justification : HAVENA est un système fortement relationnel (clients → logements → abonnements → inspections → interventions → prestataires → finances), avec des besoins d'agrégation (tableau de bord, rapports mensuels, CA/marges) qui demandent des jointures SQL. Drift apporte en plus des requêtes réactives (`Stream`) qui s'intègrent naturellement avec les `Rx`/`Obx` de GetX, des migrations gérées et un typage strict. Le schéma vit dans `core/database/` (tables, DAOs, migrations), jamais accédé directement par les controllers — toujours via `repositories`.

## Charte graphique

Charte officielle HAVENA (cahier des charges, annexe « Éléments fournis par HAVENA ») : **Vert `#1E7A4B`**, **Orange `#E8792E`**, **Blanc**. Définie dans `lib/app/theme/app_colors.dart` (`AppColors.primary` = vert, `AppColors.secondary` = orange). Les alertes du tableau de bord (Rouge/Orange/Jaune/Vert, cahier des charges §5) sont dans `AppColors.alertRed/alertOrange/alertYellow/alertGreen`.

## Authentification et rôles

**Implémenté** (`lib/features/auth/`, `lib/features/access_management/`, `lib/core/auth/role_permissions.dart`).

- Rôles fixes définis par le cahier des charges : `AppRole.fondatrice` (accès complet), `AppRole.coordinateur`, `AppRole.agent` (uniquement inspections). La matrice rôle→routes est codée en dur dans `RolePermissions` (jamais éditable à distance).
- Firestore (collection `users`, doc id = uid Firebase Auth) ne stocke que la liaison compte↔rôle : `email` (string), `fullName` (string), `role` (string, une des valeurs de `AppRole` : `fondatrice`/`coordinateur`/`agent`), `active` (bool), `createdAt` (timestamp), `createdBy` (string, uid du créateur) — jamais les permissions elles-mêmes. Règles de sécurité dans [firestore.rules](firestore.rules) (lecture de son propre doc ou, pour la Fondatrice, de tous ; écriture réservée à la Fondatrice). À déployer avec `firebase deploy --only firestore:rules` (pas fait automatiquement, nécessite `firebase login`).
- Seule la Fondatrice voit l'onglet « Gestion des accès » (`AccessManagementContent`) : rôles/permissions en lecture seule + liste des comptes + formulaire d'ajout d'administrateur. La création de compte passe par une instance Firebase secondaire (`FirebaseAuthService.createUserWithSecondaryApp`) pour ne jamais déconnecter la session de la Fondatrice.
- `AuthRepository.login()` (Firebase Auth + fetch Firestore ponctuel) met le résultat en cache local via `AuthSessionCacheService` (GetStorage, clé `auth_session`). Au démarrage, `AuthRepository.tryResumeSession()` relit ce cache **sans appel réseau** (résolu de façon synchrone dans `main()`, avant même `GetMaterialApp`, pour choisir la route de départ : `AppRoutes.login` ou `AppRoutes.dashboard`). Le rôle n'est jamais re-fetché automatiquement : uniquement via `AuthRepository.refreshSessionFromRemote()`, à appeler lors d'une synchronisation explicite. Toujours utiliser des lectures Firestore ponctuelles (`.get()`), jamais `.snapshots()`.
- Filtrage : `SidebarMenu` n'affiche que les sections accessibles au rôle courant (`SessionController.canAccess`) ; `AppShellView` a un garde-fou qui redirige vers la première route autorisée si `NavigationController.currentRoute` pointe vers une section non permise.

## Modules métier — pattern de référence

`lib/features/clients/` et `lib/features/logements/` sont le pattern canonique à reproduire pour chaque futur module métier (abonnements, inspections, interventions, prestataires, finances...) : `repository` (seul point d'accès au DAO Drift + au `ReferenceGeneratorService`), `controller` (état de liste via `StreamSubscription` sur `repository.watchAll()`, état de formulaire en champs `Rx`/`Rxn` séparés, `openCreateForm()`/`openEditForm()`/`submitForm()`), `binding` (enregistre repository puis controller en `lazyPut`), `view` exportant un widget `XxxContent` SANS `DesktopShell` (liste + recherche live + dialog de formulaire, à la manière de `access_management_view.dart`). Les vues `XxxContent` sont branchées dans `AppShellView._buildContent()` selon la route, jamais dans une `GetPage` séparée. Un module qui référence un autre (ex. Logements → Clients pour le dropdown) injecte le repository de l'autre feature dans son controller.

## Suivi d'avancement

Après chaque fonctionnalité ou phase livrée, mettre à jour [docs/PROGRESS.md](docs/PROGRESS.md) (statuts : À faire / En cours / Fait / Bloqué). Ne jamais marquer un module « Fait » sans implémentation testée localement.
