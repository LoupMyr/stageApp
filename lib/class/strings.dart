class Strings {
  static const String logoutToolTip = "Deconnexion";
  static const String listButtonStr = "Consulter la liste complète";
  static const String searchTypeButtonStr = "Rechercher un type";
  static const String searchEtatButtonStr = "Rechercher un état";
  static const String searchYearButtonStr = "Rechercher une année";
  static const String searchPlaceButtonStr = "Rechercher un lieu";
  static const String addEltButtonStr = "Ajouter un élément";
  static const String registerToolTip = "Inscription";
  static const String emailLabel = "Email";
  static const String emptyInputStr = "Saisie vide";
  static const String passwordLabel = "Mot de passe";
  static const String rememberMeStr = "Se souvenir de moi";
  static const String connectButtonStr = "Se connecter";
  static const String welcomeStr = "Bienvenue !";
  static const String invalidCredentialsStr = "Identifiants incorrects";
  static const String errorStr = "Erreur";
  static const String emailInUsedStr = "Email déjà utilisé";
  static const String registerSuccessfullStr = "Vous êtes inscrit !";
  static const String backToolTip = "Retour";
  static const String confirmPasswordLabel = "Confimer votre mot de passe";
  static const String differentPasswords = "Mots de passe différents";
  static const String registerButtonStr = "S'inscrire";
  static const String roleLabel = "Rôle";
  static const String editEmailTitle = "Modifier email: ";
  static const String validButtonStr = "Valider";
  static const String editEmailSuccessful = "Email modifié";
  static const String displayInfos = "Voici vos infomatations:";
  static const String materialAdded = "Matériel ajouté";
  static const String materialEdited = "Matériel modifié";
  static const String errorHappened = "Une erreur est survenue";
  static const String emptyField = "Champ vide";
  static const String fieldEmpty1 = "Le champ ";
  static const String fieldEmpty2 = " est vide.";
  static const String keepSaving =
      "Etes vous sûr de vouloir enregistrer tout de même ?";
  static const String yesButtonStr = "Oui";
  static const String cancelButtonStr = "Annuler";
  static const String marqueLabel = "Marque";
  static const String modeleLabel = "Modèle";
  static const String numInventaireLabel = "Numéro d'inventaire";
  static const String detailsLieuAutresLabel =
      "Détails sur le lieu de stockage";
  static const String numSerieLabel = "Numéro de série";
  static const String dateAchatLabel = "Date d'achat: ";
  static const String dateGarantieLabel = "Date de fin de garantie: ";
  static const String remarquesLabel = "Remarques";
  static const String typeLabel = "Type:";
  static const String etatLabel = "Etat:";
  static const String lieuLabel = "Lieu:";
  static const String roleProfilLabel = "Rôle: ";
  static const String emailProfilLabel = "Email: ";
  static const String errorTypeLabel = "Veuillez choisir un type";
  static const String errorEtatLabel = "Veuillez choisir un état";
  static const String errorLieuLabel = "Veuillez choisir un lieu";
  static const String uploadImgStr =
      'L\'upload d\'images passe par URL, vous pouvez utiliser le site "postimages" pour téléverser une image en URL.';
  static const String uploadImgLabel = "URL Image: ";
  static const String deleteEltTitle = "Supprimer un élément";
  static const String deleteStr =
      "Êtes vous sûr de vouloir supprimer cet élément";
  static const String deleteEltSuccessful = "Matériel supprimé";
  static const String typeHeader = "Type";
  static const String modeleHeader = "Modele";
  static const String marqueHeader = "Marque";
  static const String optionHeader = "Option";
  static const String etatHeader = "Etat";
  static const String remarquesHeader = "Remarques";
  static const String dateAchatHeader = "Date d'achat";
  static const String dateGarantieHeader = "Date de fin de garantie";
  static const String lieuInstallationHeader = "Lieu d'installation";
  static const String numSerieHeader = "Numéro de série";
  static const String numInventaireHeader = "Numéro d'inventaire";
  static const String qrCodeHeader = "QR Code";
  static const String criticalErrorStr = "Erreur critique.";
  static const String downloadToolTip = "Télécharger";
  static const String qrDownloadSuccessfulStr =
      "QR Code enregistré avec succès";
  static const String yearEmptyStr = "Aucune année selectionné.";
  static const String selectYearTitle = "Selectionner une année";
  static const String emptyEltByYearStr = "Aucun matériel n'a été acquis en ";
  static const String yearSelectedStr = "Année selectionnée: ";
  static const String noSelectionStr = "Aucune selection";
  static const String emptyEltByEtat = "Aucun matériel du stock n'est ";
  static const String emptyEltByLieu =
      "Aucun matériel du stock n'est stocké dans: ";
  static const String etatTitle =
      "Recherchez un état parmi ceux présenté ici pour retrouver \ntous les matériels correspondant à celui-ci.";
  static const String emptyEltByType1 = "Il n'y a pas de ";
  static const String emptyEltByType2 = " dans le stock";
  static const String typeTitle =
      "Recherchez un type parmi ceux présenté ici pour retrouver \ntous les matériels correspondant à celui-ci.";
  static const String lieuTitle =
      "Recherchez un lieu parmi ceux présenté ici pour retrouver \ntous les matériels entreposé dans ce dernier.";
  static const String pdfDownloadSuccessful = "PDF récapitulatif téléchagé.";
  static const List<String> tabHeaders = ['Type', 'Marque', 'Modele', 'Année'];
  static const List<String> itemsType = [
    ' ',
    'Clavier',
    'Copieur',
    'Ecran',
    'ENI',
    'Imprimante',
    'NAS',
    'Point accès wifi',
    'Serveur',
    'Souris',
    'Switch',
    'Tablette',
    'TBI',
    'Téléphone fixe',
    'Téléphone mobile',
    'Unité centrale',
    'Autres',
  ];
  static const List<String> itemsEtat = [
    ' ',
    'Neuf',
    'Très bon état',
    'Bon état',
    'Hors-Service'
  ];
  static const List<String> itemsLieu = [
    ' ',
    'Animathèque',
    'Centre Socioculturel',
    'Centre Technique',
    'Ecole de Musique',
    'Ecole Jean Macé Elémentaire',
    'Ecole Jean Macé Maternelle',
    'Ecole Leopold Sedar Senghor',
    'Ecole Léopold Bernard',
    'Ecole Michel Darras',
    'Mairie',
    'Maison des Sociétés',
    'Médiathèque',
    'Relais Petite Enfance',
    'Salle Gustave Desailly',
    'Salle Leo Lagrange',
    'Salle Mitterrand',
    'Autres',
  ];
}
