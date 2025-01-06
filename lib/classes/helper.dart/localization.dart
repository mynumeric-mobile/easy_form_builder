enum LocalisationCode { fr, en, es, de }

///Location settings
LocalizationOptions? _localizationOptions;

/// Get currently used localization options
LocalizationOptions get localizationOptions => _localizationOptions ?? LocalizationOptions(LocalisationCode.en);

/// Set localization options (translations) to this report mode
LocalizationOptions setLocalizationOptions(LocalisationCode? code) {
  _localizationOptions = LocalizationOptions._localizationMessages[code ?? LocalisationCode.en];
  return _localizationOptions ?? LocalizationOptions(LocalisationCode.en);
}

class LocalizationOptions {
  final LocalisationCode languageCode;
  final String ok;
  final String cancel;
  final String remainingTime;
  final String help;
  final String emptyField;
  final String invalidEmail;
  final String invalidPassword;
  final String invalidCharacterNumber;
  final String invalidPhone;
  final String invalidFormat;

  LocalizationOptions(this.languageCode,
      {this.ok = "Ok",
      this.cancel = "Cancel",
      this.help = "Aide",
      this.remainingTime = "Temps restant",
      this.emptyField = "Se champ est obligatoire",
      this.invalidEmail = "Email invalide",
      this.invalidPassword = "Mot de passe invalide",
      this.invalidCharacterNumber = "Nombre de caractères invalide",
      this.invalidPhone = "Numéro invalide",
      this.invalidFormat = "Format invalide"});

  static final Map<LocalisationCode, LocalizationOptions> _localizationMessages = {
    LocalisationCode.en: LocalizationOptions(LocalisationCode.en),
    LocalisationCode.fr: LocalizationOptions(LocalisationCode.fr,
        ok: "Ok",
        cancel: "Annuler",
        help: "Aide",
        remainingTime: "Temps restant",
        emptyField: "Se champ est obligatoire",
        invalidEmail: "Email invalide",
        invalidPassword:
            "Le mot de passe doit contenir :\n 8 caractères, 1 majuscule, 1 minuscule, 1 chiffre, 1 caractère spécial.",
        invalidCharacterNumber: "Nombre de caractères invalide",
        invalidPhone: "Numéro invalide",
        invalidFormat: "Format invalide"),
    LocalisationCode.es: LocalizationOptions(LocalisationCode.es,
        ok: "Ok",
        cancel: "Cancelar",
        help: "Ayuda",
        remainingTime: "Tiempo restante",
        emptyField: "Este campo es obligatorio",
        invalidEmail: "Email inválida",
        invalidPassword: "La contraseña debe contener: n 8 caracteres, 1 mayúsculas, 1 minúscula, 1 dígito, 1 carácter especial.",
        invalidCharacterNumber: "Número de caracteres no válido",
        invalidPhone: "Número no válido",
        invalidFormat: "Formato no válido"),
    LocalisationCode.de: LocalizationOptions(LocalisationCode.de,
        ok: "Ok",
        cancel: "Abbrechen",
        help: "Hilfe",
        remainingTime: "Restzeit",
        emptyField: "Dieses Feld ist obligatorisch",
        invalidEmail: "ungültige E-mail",
        invalidPassword:
            "Das Kennwort muss folgende Zeichen enthalten: n 8 Zeichen, 1 Großbuchstabe, 1 Kleinbuchstaben, 1 Ziffer, 1 Sonderzeichen.",
        invalidCharacterNumber: "Ungültige Anzahl der Zeichen",
        invalidPhone: "Ungültige Nummer",
        invalidFormat: "Format ungültig")
  };
}
