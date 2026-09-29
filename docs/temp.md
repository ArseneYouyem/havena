### Page 1 ###
HAVENA
Votre maison, notre responsabilité.

CAHIER DES CHARGES
Mise en place du système de gestion numérique

Service HomeCare — Inspection & Property Care
HAVENA by Royal L&T — Douala, Cameroun

### Page 2 ###
HAVENA — Cahier des charges

1. Objectif
Créer un système numérique simple et professionnel permettant à HAVENA de gérer :
• les clients ;
• les logements ;
• les abonnements ;
• les inspections ;
• les interventions ;
• les prestataires ;
• les paiements ;
• les rapports mensuels ;
• les documents et photos.
Le système doit être utilisable par une personne qui n'est pas informaticienne.

2. Outils à utiliser
Le système doit être construit principalement avec :
• Google Drive → stockage des dossiers et documents ;
• Google Sheets → bases de données et suivi ;
• Google Forms → formulaires d'inspection / intervention si nécessaire ;
• WhatsApp Business → communication avec les clients et prestataires ;
• Gmail professionnel → communication officielle ;
• Google Calendar → inspections, interventions et rendez-vous.
Il ne faut pas créer d'application mobile au lancement.

3. Organisation du Google Drive
Créer un dossier principal HAVENA contenant :
N° Dossier
01 CLIENTS
02 LOGEMENTS
03 INTERVENTIONS
04 PRESTATAIRES
05 ABONNEMENTS
06 FINANCES
07 RAPPORTS MENSUELS
08 PROCÉDURES INTERNES
09 MODÈLES
10 ARCHIVES

HAVENA by Royal L&T — Votre maison, notre responsabilité. | Page 2

### Page 3 ###
HAVENA — Cahier des charges

4. Système de références
Chaque élément doit avoir une référence unique. Ces références doivent permettre de retrouver rapidement toutes les informations liées à un logement.
Élément Format Exemples
Clients HAV-CLI-000001 HAV-CLI-000001, HAV-CLI-000002
Logements HAV-DLA-000001 HAV-DLA-000001, HAV-DLA-000002
Interventions HAV-INT-000001 HAV-INT-000001, HAV-INT-000002
Prestataires HAV-PRE-000001 HAV-PRE-000001, HAV-PRE-000002
Inspections HAV-INS-000001 HAV-INS-000001, HAV-INS-000002

Note : le numéro imprimé sur la fiche papier d'inspection correspond à la référence d'inspection (HAV-INS). Le logement concerné est indiqué dans le champ « Logement » de la fiche avec sa référence HAV-DLA.

5. Google Sheet principal — Tableau de bord
Créer un fichier « HAVENA — GESTION CENTRALE » avec plusieurs onglets.

Onglet 1 — Tableau de bord
Afficher automatiquement :
• nombre de clients actifs ;
• nombre de logements suivis ;
• nombre d'abonnements actifs ;
• abonnements à renouveler ;
• inspections à effectuer ;
• interventions ouvertes ;
• interventions terminées ;
• paiements en attente ;
• chiffre d'affaires du mois ;
• dépenses du mois ;
• montant payé aux prestataires.
Prévoir des alertes visuelles :
Rouge Retard / urgent
Orange Action nécessaire
Jaune À surveiller
Vert Terminé

6. Onglet CLIENTS
Colonnes :
• Référence client

HAVENA by Royal L&T — Votre maison, notre responsabilité. | Page 3

### Page 4 ###
HAVENA — Cahier des charges
• Nom
• Téléphone
• WhatsApp
• E-mail
• Pays
• Ville
• Type de client
• Référence logement
• Formule d'abonnement
• Date de début
• Date de renouvellement
• Statut
• Dernier contact
• Notes

7. Onglet LOGEMENTS
Colonnes :
• Référence logement
• Référence client
• Adresse
• Quartier
• Type de logement
• Nombre de chambres
• Occupation
• Contact local
• Gardien
• Nombre de clés
• Équipements principaux
• Dernière inspection
• Prochaine inspection
• État général
• Notes

8. Onglet ABONNEMENTS
Colonnes :
• Référence client
• Référence logement
• Formule
• Prix mensuel
• Date de début
• Date de renouvellement

HAVENA by Royal L&T — Votre maison, notre responsabilité. | Page 4

### Page 5 ###
HAVENA — Cahier des charges
• Dernier paiement
• Prochain paiement
• Statut paiement
• Dernière inspection
• Prochaine inspection
• Observations
Créer une alerte automatique lorsque le renouvellement ou le paiement approche.

9. Onglet INTERVENTIONS
Colonnes :
• Référence intervention
• Date
• Référence logement
• Client
• Problème
• Catégorie
• Niveau d'urgence
• Prestataire
• Devis
• Validation client
• Date d'intervention
• Montant client
• Montant prestataire
• Marge HAVENA
• Statut
• Satisfaction client
• Rapport / photos
Statuts
Nouveau → En attente de devis → Validé → Planifié → En cours → Terminé → Payé → Archivé

10. Onglet PRESTATAIRES
Colonnes :
• Référence prestataire
• Nom
• Téléphone
• Spécialité
• Zone
• Expérience
• Pièce vérifiée
• Références vérifiées
• Tarif indicatif

HAVENA by Royal L&T — Votre maison, notre responsabilité. | Page 5

### Page 6 ###
HAVENA — Cahier des charges
• Note qualité
• Note ponctualité
• Note communication
• Statut
• Nombre d'interventions
• Dernière intervention
• Observations
Statuts
Actif — Sous surveillance — Suspendu — Inactif

11. Onglet FINANCES
Colonnes :
• Date
• Référence
• Type
• Client / prestataire
• Description
• Entrée
• Sortie
• Mode de paiement
• Statut
• Mois
• Observations
Le fichier doit calculer automatiquement : total entrées, total sorties, paiements prestataires, chiffre d'affaires et marge sur interventions.

12. Inspections
Créer un formulaire numérique permettant à l'agent HAVENA de remplir une inspection, sur le modèle de la fiche papier d'inspection (recto / verso).
Section Points à contrôler
Général portes ; serrures ; fenêtres ; murs ; plafonds ; sols ; humidité
Plomberie robinets ; évacuations ; WC ; fuites ; pression
Électricité éclairage ; prises ; tableau visible ; câbles apparents ; traces de brûlure
Climatisation démarrage ; refroidissement ; télécommande ; bruit ; fuite visible
Sécurité portes ; fenêtres ; portail ; alarme ; détecteur de fumée
Autres cuisine ; chambres / salon ; extérieur ; propreté
Prévoir : observations, photos, état général, recommandations, signature / validation.

HAVENA by Royal L&T — Votre maison, notre responsabilité. | Page 6

### Page 7 ###
HAVENA — Cahier des charges

13. Rapport mensuel
Créer un modèle professionnel permettant de générer un rapport pour chaque propriétaire. Le rapport doit contenir :
• référence du logement ;
• période ;
• état général ;
• inspection réalisée ;
• anomalies ;
• interventions réalisées ;
• dépenses ;
• recommandations ;
• photos ;
• prochaines actions.
Le rapport doit pouvoir être exporté en PDF.

14. Google Calendar
Créer des événements pour : inspections, interventions, rendez-vous, renouvellements et visites urgentes. Le calendrier doit permettre au coordinateur de voir rapidement les tâches du jour.

15. Procédure du coordinateur
Créer un document interne expliquant exactement les étapes à suivre lorsqu'un client contacte HAVENA :
1. Identifier le client.
2. Identifier le logement.
3. Enregistrer la demande.
4. Attribuer une référence d'intervention.
5. Évaluer l'urgence.
6. Sélectionner le prestataire.
7. Obtenir le devis.
8. Faire valider le client.
9. Planifier l'intervention.
10. Suivre l'intervention.
11. Vérifier le résultat.
12. Enregistrer le paiement.
13. Mettre à jour le dossier.
14. Demander la satisfaction du client.
15. Archiver les photos et documents.

HAVENA by Royal L&T — Votre maison, notre responsabilité. | Page 7

### Page 8 ###
HAVENA — Cahier des charges

16. Gestion des photos
Créer automatiquement dans chaque logement un dossier PHOTOS contenant :
• 01 — État initial
• 02 — Inspections
• 03 — Interventions
• 04 — Avant
• 05 — Après
Les photos doivent être liées à la référence du logement ou de l'intervention. Exemple de nom de fichier :
HAV-DLA-000001_INT-000023_AVANT_01.jpg

17. Modèles à créer
Créer dans le dossier 09 — MODÈLES :
• Fiche client
• Fiche logement
• Fiche intervention
• Fiche prestataire
• Checklist inspection
• Rapport mensuel
• Devis
• Facture
• Reçu de paiement
• Contrat d'abonnement
• Procédure coordinateur
Le reçu de paiement, le facturier et la fiche d'inspection existent déjà à la charte HAVENA et doivent servir de base.

18. Gestion des accès
Profil Accès
Fondatrice Accès complet.
Coordinateur Clients, logements, interventions, prestataires, inspections, calendrier. Accès financier limité selon les besoins.
Agent HAVENA Uniquement les inspections, les logements qui lui sont attribués, les formulaires et les photos nécessaires.
Prestataire Aucun accès à la base de données HAVENA. Il reçoit uniquement les informations nécessaires à son intervention.

19. Résultat attendu
Le système doit être : simple ; professionnel ; facile à utiliser sur téléphone ; utilisable sur ordinateur ; sécurisé ; évolutif ; sans application spécifique au départ.

HAVENA by Royal L&T — Votre maison, notre responsabilité. | Page 8

### Page 9 ###
HAVENA — Cahier des charges
Il doit être possible d'ajouter facilement :
Client → logement → abonnement → inspection → intervention → prestataire → paiement → rapport mensuel.
Toutes ces informations doivent être reliées grâce aux références HAVENA. Par exemple, lorsque le coordinateur sélectionne HAV-DLA-000001, il doit retrouver le client, l'abonnement, les inspections et l'historique des interventions sans rechercher manuellement dans plusieurs fichiers.
« Je ne veux pas seulement des fichiers Google Sheets. Je veux un système de gestion où les informations sont liées entre elles. »

20. Important
Ne pas construire un système compliqué uniquement pour faire professionnel. Le système doit être conçu pour fonctionner réellement avec 10 clients, puis 50, puis 100+ clients.
Avant toute automatisation avancée, créer une première version fonctionnelle et la tester avec quelques logements.

21. Livrables attendus
1. Google Drive structuré
2. Google Sheets de gestion
3. Tableau de bord
4. Google Forms
5. Google Calendar
6. Modèles de documents
7. Procédure du coordinateur
8. Système de références
9. Système de classement des photos
10. Guide rapide d'utilisation pour le coordinateur

HAVENA by Royal L&T — Votre maison, notre responsabilité. | Page 9

### Page 10 ###
HAVENA — Cahier des charges
Annexe — Éléments fournis par HAVENA
Ces éléments sont à remettre au prestataire en complément du présent cahier des charges.
Élément Contenu
