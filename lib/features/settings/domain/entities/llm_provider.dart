/// LLM backend used for chat expense processing (`provider` field in API).
enum LlmProvider {
  openai;

  /// Value for the JSON `provider` field (matches enum name).
  String get apiValue => name;

  String get displayLabel => switch (this) {
        LlmProvider.openai => 'OpenAI',
      };

  static LlmProvider fromStored(String? raw) {
    if (raw == null || raw.isEmpty) return LlmProvider.openai;
    try {
      return LlmProvider.values.byName(raw);
    } catch (_) {
      return LlmProvider.openai;
    }
  }
}
