# Distribuer HAVENA aux testeurs Windows

Le workflow `.github/workflows/windows-testers.yml` compile sur Windows 2022
avec Flutter 3.38.9 (version du poste de développement lors de sa création).
Il analyse le projet, exécute les tests, puis publie tout le dossier Release
sous forme d'un artifact ZIP conservé 14 jours. Le déclenchement est manuel.

## Première configuration

1. Envoyer le workflow, les deux guides et le code de l'application dans le
   dépôt GitHub. Le workflow doit être présent sur la branche par défaut
   (souvent `main`) pour que le bouton de lancement manuel apparaisse.
   Conserver `pubspec.lock` dans Git pour reproduire les dépendances.
2. Dans GitHub : **Settings → Secrets and variables → Actions → New repository secret**.
3. Nom : `GOOGLE_DRIVE_CREDENTIALS_JSON`. Valeur : le contenu complet du fichier
   local `google_drive_credentials.json`, avec ses accolades, sans encodage Base64.
   Enregistrer le secret. Ne pas ajouter ce fichier à Git.
4. Ouvrir **Actions → Windows - Testeurs → Run workflow**, sélectionner la
   branche contenant le code à tester puis confirmer **Run workflow**.
5. Attendre que toutes les étapes soient vertes. En cas d'échec, ouvrir l'étape
   rouge pour consulter le journal ; aucun ZIP n'est publié si les contrôles échouent.
6. En bas de la page de l'exécution, dans **Artifacts**, télécharger
   `HAVENA-Windows-x64-N`. Envoyer ce ZIP aux testeurs via le canal de votre choix.
   Les testeurs n'ont pas besoin d'un compte GitHub si vous leur transmettez le ZIP.
   Le téléchargement direct sur GitHub nécessite une connexion et les droits
   de lecture sur le dépôt.
7. Les testeurs extraient toute l'archive et lancent `havena.exe`.
   Le ZIP contient `LIRE-MOI.txt` et `BUILD.txt`.

## Versions suivantes

Envoyer les modifications sur GitHub puis relancer le workflow. Le numéro de
build vient de `github.run_number` ; le nom de version reste celui de
`pubspec.yaml`. Incrémenter ce dernier pour une nouvelle version fonctionnelle.
Si Flutter est mis à jour localement, mettre également à jour sa version dans
le workflow. Aucun installateur ni publication GitHub Release n'est créé.

## Configuration embarquée

Le secret évite de stocker le JSON dans Git, mais le fichier est embarqué comme
asset dans l'application, conformément au fonctionnement actuel du projet.
Un secret GitHub ne rend donc pas ce fichier inaccessible aux destinataires
du ZIP. Utiliser uniquement le JSON OAuth « Desktop app » prévu par le projet,
pas une clé de compte de service ni un fichier contenant des jetons utilisateur.

## Références

- https://docs.github.com/en/actions/how-tos/manage-workflow-runs/manually-run-a-workflow
- https://docs.github.com/en/actions/how-tos/write-workflows/choose-what-workflows-do/use-secrets
- https://docs.flutter.dev/platform-integration/windows/building
