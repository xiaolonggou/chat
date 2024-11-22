import 'dart:io';

void main() async {
  // Specify the source directory (project root)
  final directory = Directory('./lib');

  // Specify the output file path
  final outputFile = File('./prompt.gpt');

  // Check if the directory exists
  if (!await directory.exists()) {
    print('Directory ${directory.path} does not exist.');
    return;
  }

  // Prepare the output file
  if (await outputFile.exists()) {
    await outputFile.delete(); // Remove existing output file
  }
  await outputFile.create();

  // Traverse the directory and combine source code
  await combineSourceCode(directory, outputFile);

  print('All source code combined into ${outputFile.path}');
}

Future<void> combineSourceCode(Directory directory, File outputFile) async {
  // List all files and subdirectories in the directory
  final entities = directory.listSync(recursive: true);
  for (final entity in entities) {
    // Process only Dart files
    if (entity is File && entity.path.endsWith('.gpt')) {
      // Read the content of the Dart file
      final content = await entity.readAsString();

      // Append the file path and content to the output file
      await outputFile.writeAsString(
        '// File: ${entity.path}\n$content\n\n',
        mode: FileMode.append,
      );
    }
  }
  for (final entity in entities) {
    // Process only Dart files
    if (entity is File && entity.path.endsWith('.dart')) {
      // Read the content of the Dart file
      final content = await entity.readAsString();

      // Append the file path and content to the output file
      await outputFile.writeAsString(
        '// File: ${entity.path}\n$content\n\n',
        mode: FileMode.append,
      );
    }
  }
}
