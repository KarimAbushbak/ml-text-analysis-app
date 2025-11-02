/// Language constants for translation feature
class LanguageConstants {
  LanguageConstants._(); // Private constructor to prevent instantiation

  /// Map of language codes to display names
  static const Map<String, String> languageNames = {
    'en': 'English',
    'es': 'Spanish',
    'fr': 'French',
    'de': 'German',
    'it': 'Italian',
    'pt': 'Portuguese',
    'ar': 'Arabic',
    'zh': 'Chinese',
    'ja': 'Japanese',
    'ru': 'Russian',
    'nl': 'Dutch',
    'sv': 'Swedish',
  };

  /// Get language display name from code
  static String getLanguageName(String code) {
    return languageNames[code] ?? code.toUpperCase();
  }

  /// Check if language code is supported
  static bool isSupported(String code) {
    return languageNames.containsKey(code);
  }

  /// Get list of all supported language codes
  static List<String> get supportedCodes => languageNames.keys.toList();

  /// Get list of all language names
  static List<String> get supportedNames => languageNames.values.toList();
}

