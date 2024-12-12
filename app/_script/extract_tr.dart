import 'dart:io';
import 'package:args/args.dart';
import 'package:collection/collection.dart';
import 'package:path/path.dart' as filepath;

import 'package:maple_file/app/i18n/en_us.dart';
import 'package:maple_file/app/i18n/zh_cn.dart';

const languages = {
  "zh_cn": zhCN,
  "en_us": enUS,
};

class TranlationExtractor {
  static final RegExp _re1 = RegExp(r"'([^']+)'\s*\.tr");
  static final RegExp _re2 = RegExp(r'"([^"]+)"\s*\.tr');

  static final RegExp _re3 = RegExp(r"'''([^']+?)'''\s*\.tr");
  static final RegExp _re4 = RegExp(r'"""([^"]+?)"""\s*\.tr');
  static final List<RegExp> regexes = [_re1, _re2, _re3, _re4];

  final String input;
  final String output;

  const TranlationExtractor({
    required this.input,
    required this.output,
  });

  String _camelize(String key) {
    RegExp regex = RegExp(r'[_]+(.+)');

    return key.replaceAllMapped(regex, (m) {
      final match = m.group(1);
      if (match == null) {
        return "";
      }
      return match.toUpperCase();
    });
  }

  bool _includeFile(String path) {
    List<String> res = [".dart"];
    for (final re in res) {
      if (path.endsWith(re)) {
        return true;
      }
    }
    return false;
  }

  void _extractFile(String path, Map<String, String> map) {
    final content = File(path).readAsStringSync();
    for (final RegExp regex in regexes) {
      for (final RegExpMatch match in regex.allMatches(content)) {
        final extract = match.group(1);

        if (extract != null) {
          map.putIfAbsent(extract, () => extract);
        }
      }
    }
  }

  Map<String, String> extract() {
    Map<String, String> map = {};

    final entities = Directory(input).listSync(recursive: true);
    for (final FileSystemEntity entity in entities) {
      if (entity is File && _includeFile(entity.path)) {
        _extractFile(entity.path, map);
      }
    }
    return map;
  }

  void write(
    List<String> keys,
    String language, {
    Map<String, String>? translations,
  }) {
    final trans = keys.map((key) {
      return '''  "$key": "${translations?[key] ?? ''}"''';
    }).join(",\n");
    final template = '''
const ${_camelize(language)} = {
$trans,
};''';
    final file = filepath.join(output, "$language.dart");
    File(file).writeAsStringSync(template);
    print("write to $file");
  }

  void extractAndWrite() {
    final map = extract();

    final keys = map.keys.toList();
    keys.sort((a, b) {
      return compareAsciiUpperCaseNatural(a, b);
    });

    for (final entry in languages.entries) {
      write(keys, entry.key, translations: entry.value);
    }
  }
}

void main(List<String> arguments) {
  final argParser = ArgParser()
    ..addOption('input', abbr: 'i', defaultsTo: './lib')
    ..addOption('output', abbr: 'o', defaultsTo: './lib/app/i18n');

  final argResults = argParser.parse(arguments);

  final input = argResults['input'];
  final output = argResults['output'];

  final tr = TranlationExtractor(input: input, output: output);

  tr.extractAndWrite();
}
