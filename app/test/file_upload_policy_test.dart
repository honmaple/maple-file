import 'package:flutter_test/flutter_test.dart';
import 'package:maple_file/api/file/providers/file_setting.dart';

void main() {
  group('FileSetting upload policy', () {
    test('defaults to preserving filenames', () {
      final setting = FileSetting.fromJson(const {});

      expect(setting.uploadPolicy, FileUploadPolicy.preserve);
    });

    test('reads and writes auto rename policy', () {
      final setting = FileSetting.fromJson(const {
        'upload.policy': 'rename',
      });

      expect(setting.uploadPolicy, FileUploadPolicy.rename);
      expect(setting.toJson()['upload.policy'], 'rename');
    });

    test('falls back to preserve for an unknown policy', () {
      final setting = FileSetting.fromJson(const {
        'upload.policy': 'unknown',
      });

      expect(setting.uploadPolicy, FileUploadPolicy.preserve);
    });
  });
}
