import 'dart:io';
import 'package:code_block/src/service/actions_service.dart';
import 'package:code_block/src/utils/file_handling/file_picker_impl.dart';
import 'package:code_block/src/utils/languages/extensions.dart';
import 'package:file_picker/file_picker.dart';

class UploadDownloadService {
  UploadDownloadService({
    required this.programFilePicker,
    required this.actionsService,
  });

  final ProgramFilePicker programFilePicker;
  final ActionsService actionsService;

  Future<void> downloadProgram() async {
    final extension = supportedExtensions[actionsService.language] ?? 'txt';
    final path = await programFilePicker.getDirectoryPath();
    if (path == null) {
      return;
    }
    final file = File('$path/codeblock.$extension');
    final content =
        actionsService.node.delta?.toPlainText() ?? 'Some Problem Occured';
    await file.writeAsString(content);
  }

  Future<void> uploadProgram() async {
    final pickedFile = await programFilePicker.pickFiles(
      allowedExtensions: allExtensions,
      allowMultiple: false,
    );
    if (pickedFile == null) return;

    PlatformFile platformFile = pickedFile.files.first;
    final file = File('${platformFile.path}');
    // Read the file
    final contents = await file.readAsString();
    if (contents.isNotEmpty) {
      await actionsService.uploadCode(contents);
    }
  }
}
