# Suivi d'avancement — HAVENA

Statuts possibles : `À faire` · `En cours` · `Fait` · `Bloqué`

## Modules métier

| Module | Statut | Priorité | Notes |
|---|---|---|---|
| Setup projet (structure, pubspec, config native) | En cours | Haute | Structure feature-first + shell desktop (sidebar/topbar) en place, GetX/GetStorage installés, build macOS validé (lancement réel OK). Windows non testé (pas de machine Windows disponible ici) mais config standard, aucune modif requise à ce stade |
| Authentification / rôles | À faire | Haute | Fondatrice / Coordinateur / Agent HAVENA |
| Shell desktop (sidebar, topbar, navigation) | À faire | Haute | |
| Tableau de bord | À faire | Haute | |
| Clients | À faire | Haute | Référence `HAV-CLI-000001` |
| Logements | À faire | Haute | Référence `HAV-DLA-000001` |
| Abonnements | À faire | Haute | |
| Inspections | À faire | Haute | Référence `HAV-INS-000001`, checklist + photos + signature |
| Interventions | À faire | Haute | Référence `HAV-INT-000001`, workflow multi-statuts |
| Prestataires | À faire | Moyenne | Référence `HAV-PRE-000001` |
| Finances | À faire | Haute | |
| Rapports mensuels (export PDF) | À faire | Moyenne | |
| Photos / documents | À faire | Moyenne | Classement automatique par logement |
| Calendrier | À faire | Moyenne | |
| Modèles de documents | À faire | Moyenne | Devis, facture, reçu, contrat, fiches |
| Références HAVENA (génération/recherche transversale) | À faire | Haute | |
| Synchronisation Google Drive | À faire | Haute | Bouton explicite, statuts de sync |
| Gestion des conflits de synchronisation | À faire | Haute | À prévoir dès la conception des modèles |
| Préparation responsive mobile | À faire | Basse | Après stabilisation desktop |

## Journal

- 2026-09-29 — Analyse du cahier des charges, choix de stack confirmés (GetX, GetStorage), 3 options de BDD locale proposées à l'utilisateur, structure de projet définie, CLAUDE.md/AGENT.md créés, configuration native macOS corrigée (entitlements réseau + accès fichiers), squelette GetX (routes, thème, shell desktop, dashboard placeholder) créé et validé par un build + lancement réel sur macOS.
