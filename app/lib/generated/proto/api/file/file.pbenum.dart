//
//  Generated code. Do not modify.
//  source: api/file/file.proto
//
// @dart = 2.12

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

class File_UploadPolicy extends $pb.ProtobufEnum {
  static const File_UploadPolicy UPLOAD_POLICY_INHERIT = File_UploadPolicy._(0, _omitEnumNames ? '' : 'UPLOAD_POLICY_INHERIT');
  static const File_UploadPolicy UPLOAD_POLICY_PRESERVE = File_UploadPolicy._(1, _omitEnumNames ? '' : 'UPLOAD_POLICY_PRESERVE');
  static const File_UploadPolicy UPLOAD_POLICY_RENAME = File_UploadPolicy._(2, _omitEnumNames ? '' : 'UPLOAD_POLICY_RENAME');

  static const $core.List<File_UploadPolicy> values = <File_UploadPolicy> [
    UPLOAD_POLICY_INHERIT,
    UPLOAD_POLICY_PRESERVE,
    UPLOAD_POLICY_RENAME,
  ];

  static final $core.Map<$core.int, File_UploadPolicy> _byValue = $pb.ProtobufEnum.initByValue(values);
  static File_UploadPolicy? valueOf($core.int value) => _byValue[value];

  const File_UploadPolicy._($core.int v, $core.String n) : super(v, n);
}


const _omitEnumNames = $core.bool.fromEnvironment('protobuf.omit_enum_names');
