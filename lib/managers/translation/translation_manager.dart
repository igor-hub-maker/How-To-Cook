abstract class TranslationManager {
  Future<String> translate(String text, String targetLanguage);
  Future<List<String>> translateMany(List<String> text, String targetLanguage);
}
