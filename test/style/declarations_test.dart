import 'package:flutter_test/flutter_test.dart';
import 'package:nerimity_html_embed/src/style/declarations.dart';

void main() {
  test('parses properties and values', () {
    expect(parseDeclarations('Color: Red ; padding:4px 8px;'), {
      'color': 'Red',
      'padding': '4px 8px',
    });
  });

  test('keeps semicolons and colons inside parentheses and quotes', () {
    expect(
      parseDeclarations(
        'background-image: url("https://a.b/c;d.png"); font-family: \'a;b\'',
      ),
      {
        'background-image': 'url("https://a.b/c;d.png")',
        'font-family': "'a;b'",
      },
    );
  });

  test('last duplicate wins and moves to the end', () {
    final declarations = parseDeclarations(
      'padding-left: 1px; padding: 4px; padding-left: 2px',
    );

    expect(declarations.keys, ['padding', 'padding-left']);
    expect(declarations['padding-left'], '2px');
  });

  test('strips important flags and comments', () {
    expect(
      parseDeclarations('color: red !IMPORTANT; /* x */ margin: 0 ! important'),
      {'color': 'red', 'margin': '0'},
    );
  });

  test('skips malformed declarations', () {
    expect(parseDeclarations('color; : red; 1px: 2; width: ; ;height:1px'), {
      'height': '1px',
    });
  });
}
