# Suivi d'avancement — HAVENA

Statuts possibles : `À faire` · `En cours` · `Fait` · `Bloqué`

## Modules métier

| Module | Statut | Priorité | Notes |
|---|---|---|---|
| Setup projet (structure, pubspec, config native) | En cours | Haute | Structure feature-first en place, GetX/GetStorage/Firebase installés, build macOS validé (lancement réel OK). Windows non testé (pas de machine Windows disponible ici) mais config standard, aucune modif requise à ce stade |
| Schéma base de données (Drift) | Fait | Haute | 14 tables + DAOs générées (`core/database/`), colonnes de sync (`updatedAt/updatedBy/syncStatus/isDeleted`) sur chaque table métier, soft delete. Validé par build_runner + tests d'intégration (insert/lecture/soft-delete réels sur SQLite natif, `flutter test` OK) |
| Authentification / rôles (Firebase Auth + Firestore) | Fait | Haute | Login, session locale offline (GetStorage), écran « Gestion des accès » (Fondatrice uniquement) avec ajout d'administrateur, filtrage du menu par rôle, garde-fou de navigation. `firestore.rules` écrites mais **non déployées** (nécessite `firebase login` + `firebase deploy --only firestore:rules`, à faire manuellement) |
| Shell desktop (sidebar, topbar, navigation) | Fait | Haute | `AppShellView` unique + `NavigationController` (Rx) : sidebar/topbar restent fixes, seul le contenu central change au clic (plus de transition de page complète) |
| Charte graphique | Fait | Haute | Couleurs officielles du cahier des charges appliquées (`AppColors` : vert `#1E7A4B`, orange `#E8792E`) |
| Icône app / splash | Fait | Moyenne | `flutter_launcher_icons` (assets/icon.png, toutes plateformes) + `flutter_native_splash` (assets/splash.png, Android/iOS/Web uniquement — non supporté sur macOS/Windows/Linux par ce package). Splash affiché aussi dans la topbar à côté du nom de l'app |
| Tableau de bord | En cours | Haute | Compteurs Clients/Logements connectés en direct (Stream Drift). Interventions/Abonnements toujours statiques (modules pas encore créés) |
| Clients | Fait | Haute | CRUD complet (liste, recherche, création/édition/suppression douce), référence `HAV-CLI-000001` auto-générée et séquentielle. Validé par test d'intégration réel |
| Logements | Fait | Haute | CRUD complet avec sélection du client lié (dropdown), référence `HAV-DLA-000001` auto-générée. `lastInspectionDate`/`nextInspectionDate` volontairement absents du formulaire (gérés plus tard par le module Inspections). Validé par test d'intégration réel |
| Abonnements | À faire | Haute | |
| Inspections | À faire | Haute | Référence `HAV-INS-000001`, checklist + photos + signature |
| Interventions | À faire | Haute | Référence `HAV-INT-000001`, workflow multi-statuts |
| Prestataires | À faire | Moyenne | Référence `HAV-PRE-000001` |
| Finances | À faire | Haute | |
| Rapports mensuels (export PDF) | À faire | Moyenne | |
| Photos / documents | À faire | Moyenne | Classement automatique par logement |
| Calendrier | À faire | Moyenne | |
| Modèles de documents | À faire | Moyenne | Devis, facture, reçu, contrat, fiches |
| Références HAVENA (génération/recherche transversale) | En cours | Haute | Génération séquentielle en place (`ReferenceGeneratorService`, Clients/Logements). Recherche transversale multi-entités pas encore faite |
| Synchronisation Google Drive | À faire | Haute | Bouton explicite, statuts de sync |
| Gestion des conflits de synchronisation | À faire | Haute | À prévoir dès la conception des modèles |
| Préparation responsive mobile | À faire | Basse | Après stabilisation desktop |

## Journal

- 2026-09-29 — Analyse du cahier des charges, choix de stack confirmés (GetX, GetStorage), 3 options de BDD locale proposées à l'utilisateur, structure de projet définie, CLAUDE.md/AGENT.md créés, configuration native macOS corrigée (entitlements réseau + accès fichiers), squelette GetX (routes, thème, shell desktop, dashboard placeholder) créé et validé par un build + lancement réel sur macOS.
- 2026-09-29 — Choix de Drift (SQLite) confirmé par l'utilisateur ; schéma complet (14 tables + DAOs) créé et validé (build_runner + tests d'intégration réels). Décision d'auth Firebase Auth + Firestore actée (implémentation à venir, Phase 2). Correction de deux bugs : navigation qui rejouait toute la page au changement d'onglet (shell désormais fixe via `NavigationController`), et charte de couleurs générique utilisée par erreur au lieu de la charte officielle du cahier des charges (vert `#1E7A4B` / orange `#E8792E`) — corrigé dans `AppColors`.
- 2026-09-29 — Icône d'application et splash HAVENA ajoutés (`flutter_launcher_icons`/`flutter_native_splash`) à partir des assets fournis, avec le splash affiché dans la topbar. Module authentification/rôles complet (Phase 2) : Firebase Auth + Firestore (collection `users`, un seul champ `role`), session locale offline via GetStorage, écran « Gestion des accès » (Fondatrice uniquement) pour créer des administrateurs, menu filtré par rôle, garde-fou de navigation, `firestore.rules` écrites (non déployées). Bootstrap manuel documenté pour le tout premier compte Fondatrice (console Firebase, aucun utilisateur ne pouvant créer le premier compte depuis l'app). Test widget Firebase-dépendant remplacé par un test unitaire pur sur `RolePermissions` (le pump complet de `HavenApp` timeoutait en environnement de test sans `Firebase.initializeApp()`).
- 2026-09-29 — Début Phase 3 : `ReferenceGeneratorService` (références HAVENA séquentielles basées sur un comptage Drift), puis modules **Clients** et **Logements** complets (repository, controller, binding, vue liste + formulaire en dialog, recherche live, suppression avec confirmation). Le tableau de bord affiche désormais les vrais compteurs clients/logements en direct. Deux bugs corrigés après génération : import manquant (`Client`/`ClientsCompanion` viennent de `app_database.dart`, pas de `clients_table.dart`) et champs de formulaire d'édition qui ne préremplissaient pas leur valeur initiale (ajout de `TextEditingController` explicites). Validé par un test d'intégration dédié (création séquentielle de références, modification, suppression douce) en plus du build macOS.
