enum SyncStatus { local, synced, conflict }

enum AppRole { fondatrice, coordinateur, agent }

enum ClientStatus { actif, inactif, suspendu }

enum HousingCondition { bon, moyen, mauvais }

enum PaymentStatus { aJour, enRetard, impaye }

enum InspectionCategory {
  general,
  plomberie,
  electricite,
  climatisation,
  securite,
  autres,
}

enum UrgencyLevel { basse, normale, haute, critique }

enum InterventionStatus {
  nouveau,
  enAttenteDevis,
  valide,
  planifie,
  enCours,
  termine,
  paye,
  archive,
}

enum PrestataireStatus { actif, sousSurveillance, suspendu, inactif }

enum TransactionType { entree, sortie }

enum TransactionStatus { enAttente, valide, annule }

enum PhotoType {
  etatInitial,
  inspection,
  avantIntervention,
  apresIntervention,
  autre,
}

enum DocumentTemplateType {
  ficheClient,
  ficheLogement,
  ficheIntervention,
  devis,
  facture,
  recu,
  contratAbonnement,
  procedureCoordinateur,
}

enum CalendarEventType {
  inspection,
  intervention,
  rendezVous,
  renouvellement,
  visiteUrgente,
}

enum CalendarEventStatus { planifie, termine, annule }

enum SyncLogStatus { jamaisSync, succes, echec, enCours }
