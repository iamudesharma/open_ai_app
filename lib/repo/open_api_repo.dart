abstract class OpenAiReop {
  Future<String?> completion({required String text});
  Future<String?> chatAi({required String text});
  Future<List<String>> imageAi({required String text});
}
