import 'dart:convert';
import 'dart:io';

import 'package:yaml/yaml.dart';
import 'package:yaml_writer/yaml_writer.dart';

class Arguments {
  final String outputFilesPath;
  final List<String> inputFilsePath;

  Arguments({
    required this.outputFilesPath,
    required this.inputFilsePath,
  });

  factory Arguments.parse(List<String> args) {
    final argsMap = {};

    for (var arg in args) {
      final argParts = arg.split('=');
      argsMap[argParts[0]] = argParts[1];
    }

    return Arguments(
      outputFilesPath: argsMap['--output'],
      inputFilsePath: argsMap['--files'].split(','),
    );
  }
}

Map<String, dynamic> loadFile(String filePath) {
  final file = File(filePath);

  final string = file.readAsStringSync();

  YamlMap parsedYaml = loadYaml(string);

  return json.decode(json.encode(parsedYaml));
}

void saveFile(Map<String, dynamic> map, String path) {
  var yamlWriter = YAMLWriter();

  var yamlDoc = yamlWriter.write(map);

  final mergedFile = File(path);
  mergedFile.writeAsStringSync(yamlDoc);
}

Map<K, V> mergeMap<K, V>(Iterable<Map<K, V>> maps) {
  Map<K, V> result = <K, V>{};
  for (var map in maps) {
    _copyValues(map, result);
  }

  return result;
}

void _copyValues<K, V>(
  Map<K, V> from,
  Map<K, V> to,
) {
  for (var key in from.keys) {
    if (from[key] is Map) {
      if (to[key] == null) {
        to[key] = <String, dynamic>{} as V;
      }

      _copyValues(from[key] as Map, to[key] as Map);
    } else if (from[key] is List) {
      if (to[key] is List) {
        (to[key] as List).addAll(from[key] as List);
      } else if (to[key] == null) {
        to[key] = from[key]!;
      }
    } else {
      to[key] = from[key]!;
    }
  }
}
