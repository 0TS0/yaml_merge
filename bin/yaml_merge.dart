import 'package:yaml_merge/yaml_merge.dart';

void main(List<String> args) {
  final parsedArgs = Arguments.parse(args);

  final files = parsedArgs.inputFilsePath.map((e) => loadFile(e));

  final merged = mergeMap<String, dynamic>(files);
  saveFile(merged, parsedArgs.outputFilesPath);
}
