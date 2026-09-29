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
- Synchronisation distante : Google Drive, en opération explicite (pas de sync automatique silencieuse imposée)

## Règles d'architecture impératives

- Structure **feature-first** sous `lib/` : `app/`, `core/`, `features/<feature>/`, `shared/`.
- Séparation stricte **vue / controller**. Aucune logique métier dans les vues.
- Les vues sont des `GetView<XController>` et n'appellent que des méthodes du controller.
- Les controllers ne touchent jamais directement la base de données ou l'API Drive : ils passent par des `services`/`repositories`.
- Navigation **centralisée** via `app/routes/` (`AppRoutes`, `AppPages`) — jamais de `Navigator` direct ni de route en dur dans une vue.
- Composants UI réutilisables dans `shared/widgets/` (pas de duplication de composants entre features).
- Chaque entité métier possède une référence unique au format `HAV-XXX-000001` (voir cahier des charges).
- La gestion des conflits de synchronisation doit être prévue dès la conception des modèles (champs `updated_at`, `updated_by`, statut de sync).

## Conventions de nommage

- Fichiers : `snake_case.dart`
- Controller : `XxxController` — Binding : `XxxBinding` — View : `XxxView`
- Repository : `XxxRepository` — Service : `XxxService` — DAO : `XxxDao`
- Modèle : `Xxx`

## Choix base de données locale

**Drift (SQLite)** a été retenu parmi 3 options (Drift, Isar, sqflite/sqlite3 direct).

Justification : HAVENA est un système fortement relationnel (clients → logements → abonnements → inspections → interventions → prestataires → finances), avec des besoins d'agrégation (tableau de bord, rapports mensuels, CA/marges) qui demandent des jointures SQL. Drift apporte en plus des requêtes réactives (`Stream`) qui s'intègrent naturellement avec les `Rx`/`Obx` de GetX, des migrations gérées et un typage strict. Le schéma vit dans `core/database/` (tables, DAOs, migrations), jamais accédé directement par les controllers — toujours via `repositories`.

## Suivi d'avancement

Après chaque fonctionnalité ou phase livrée, mettre à jour [docs/PROGRESS.md](docs/PROGRESS.md) (statuts : À faire / En cours / Fait / Bloqué). Ne jamais marquer un module « Fait » sans implémentation testée localement.
