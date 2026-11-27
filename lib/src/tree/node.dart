sealed class HtmlEmbedNode {
  const HtmlEmbedNode();

  static List<HtmlEmbedNode> parse(Object? json) => switch (json) {
    List() => [for (final item in json) ...parse(item)],
    String() => [HtmlEmbedText(_unescape(json))],
    final Map<Object?, Object?> map && {'tag': final String tag} => [
      HtmlEmbedElement(
        tag: tag.toLowerCase(),
        attributes: _attributes(map['attributes']),
        children: parse(map['content']),
      ),
    ],
    _ => const [],
  };

  static Map<String, String> _attributes(Object? json) => switch (json) {
    final Map<Object?, Object?> map => {
      for (final MapEntry(:key, :value) in map.entries)
        if (key is String && value != null) key: value.toString(),
    },
    _ => const {},
  };
}

final class HtmlEmbedElement extends HtmlEmbedNode {
  const HtmlEmbedElement({
    required this.tag,
    this.attributes = const {},
    this.children = const [],
  });

  final String tag;
  final Map<String, String> attributes;
  final List<HtmlEmbedNode> children;
}

final class HtmlEmbedText extends HtmlEmbedNode {
  const HtmlEmbedText(this.text);

  final String text;
}

const _entities = {
  '&amp;': '&',
  '&lt': '<',
  '&gt': '>',
  '&quot': '"',
  '&#039': "'",
};
final _entityPattern = RegExp('&(?:amp|lt|gt|quot|#039);');

String _unescape(String text) =>
    text.replaceAllMapped(_entityPattern, (match) => _entities[match[0]]!);
