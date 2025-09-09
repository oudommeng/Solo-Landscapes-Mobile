import 'package:flutter/material.dart';

Color ColorsHex(String hex) {
  final buffer = StringBuffer();
  if (hex.length == 6 || hex.length == 7) buffer.write('ff');
  buffer.write(hex.replaceFirst('#', ''));
  return Color(int.parse(buffer.toString(), radix: 16));
}

// Primary Colors
Color primary50 = ColorsHex('#F0F6EE');
Color primary100 = ColorsHex('#D6E7D0');
Color primary200 = ColorsHex('#BBD7B2');
Color primary300 = ColorsHex('#A0CB93');
Color primary400 = ColorsHex('#86B875');
Color primary500 = ColorsHex('#74AE60');
Color primary600 = ColorsHex('#588A47');
Color primary700 = ColorsHex('#456C37');
Color primary800 = ColorsHex('#314D28');
Color primary900 = ColorsHex('#1E2F18');
Color primary950 = ColorsHex('#0B1109');

// Secondary Colors
Color secondary50 = ColorsHex('#FDFAE8');
Color secondary100 = ColorsHex('#F8F1BE');
Color secondary200 = ColorsHex('#F4E795');
Color secondary300 = ColorsHex('#EFDE6B');
Color secondary400 = ColorsHex('#ECD546');
Color secondary500 = ColorsHex('#E7CB18');
Color secondary600 = ColorsHex('#BDA714');
Color secondary700 = ColorsHex('#948210');
Color secondary800 = ColorsHex('#6A5D0B');
Color secondary900 = ColorsHex('#413907');
Color secondary950 = ColorsHex('#171402');
