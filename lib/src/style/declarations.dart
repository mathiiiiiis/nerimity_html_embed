final _comment = RegExp(r'/\*.*?\*/', dotAll: true);
final _property = RegExp(r'^-?[a-z][a-z0-9-]*$');
final _important = RegExp(r'!\s*important\s*$', caseSensitive: false);

Map<String, String> parseDeclarations(String source) {
  final declarations = <String, String>{};
  for (final part in _splitTopLevel(source.replaceAll(_comment, ''), ';')) {
    final colon = part.indexOf(':');
    if (colon == -1) continue;

    final property = part.substring(0, colon).trim().toLowerCase();
    final value = part.substring(colon + 1).replaceFirst(_important, '').trim();
    if (!_property.hasMatch(property) || value.isEmpty) continue;

    //move to end so later shorthands still override
    declarations
      ..remove(property)
      ..[property] = value;
  }
  return declarations;
}

Iterable<String> _splitTopLevel(String source, String separator) sync* {
  var depth = 0;
  var start = 0;
  String? quote;
  for (var i = 0; i < source.length; i++) {
    final char = source[i];
    if (quote != null) {
      if (char == '\\') {
        i++;
      } else if (char == quote) {
        quote = null;
      }
    } else if (char == '"' || char == "'") {
      quote = char;
    } else if (char == '(') {
      depth++;
    } else if (char == ')' && depth > 0) {
      depth--;
    } else if (char == separator && depth == 0) {
      yield source.substring(start, i);
      start = i + 1;
    }
  }
  yield source.substring(start);
}
