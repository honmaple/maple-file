//
//  Generated code. Do not modify.
//  source: api/file/repo.proto
//
// @dart = 2.12

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

class Driver extends $pb.ProtobufEnum {
  static const Driver DRIVER_UNSPECIFIED = Driver._(0, _omitEnumNames ? '' : 'DRIVER_UNSPECIFIED');
  static const Driver DRIVER_LOCAL = Driver._(1, _omitEnumNames ? '' : 'DRIVER_LOCAL');
  static const Driver DRIVER_WEBDAV = Driver._(2, _omitEnumNames ? '' : 'DRIVER_WEBDAV');

  static const $core.List<Driver> values = <Driver> [
    DRIVER_UNSPECIFIED,
    DRIVER_LOCAL,
    DRIVER_WEBDAV,
  ];

  static final $core.Map<$core.int, Driver> _byValue = $pb.ProtobufEnum.initByValue(values);
  static Driver? valueOf($core.int value) => _byValue[value];

  const Driver._($core.int v, $core.String n) : super(v, n);
}


const _omitEnumNames = $core.bool.fromEnvironment('protobuf.omit_enum_names');
