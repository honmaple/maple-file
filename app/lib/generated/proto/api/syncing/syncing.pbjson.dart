//
//  Generated code. Do not modify.
//  source: api/syncing/syncing.proto
//
// @dart = 2.12

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:convert' as $convert;
import 'dart:core' as $core;
import 'dart:typed_data' as $typed_data;

@$core.Deprecated('Use syncProfileDescriptor instead')
const SyncProfile$json = {
  '1': 'SyncProfile',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 5, '10': 'id'},
    {'1': 'created_at', '3': 2, '4': 1, '5': 11, '6': '.google.protobuf.Timestamp', '10': 'createdAt'},
    {'1': 'updated_at', '3': 3, '4': 1, '5': 11, '6': '.google.protobuf.Timestamp', '10': 'updatedAt'},
    {'1': 'name', '3': 4, '4': 1, '5': 9, '10': 'name'},
    {'1': 'enabled', '3': 5, '4': 1, '5': 8, '10': 'enabled'},
    {'1': 'mode', '3': 6, '4': 1, '5': 14, '6': '.api.syncing.SyncProfile.Mode', '10': 'mode'},
    {'1': 'source_type', '3': 7, '4': 1, '5': 9, '10': 'sourceType'},
    {'1': 'source_config', '3': 8, '4': 1, '5': 9, '10': 'sourceConfig'},
    {'1': 'target_type', '3': 9, '4': 1, '5': 9, '10': 'targetType'},
    {'1': 'target_config', '3': 10, '4': 1, '5': 9, '10': 'targetConfig'},
    {'1': 'policy_config', '3': 11, '4': 1, '5': 9, '10': 'policyConfig'},
    {'1': 'config_version', '3': 12, '4': 1, '5': 3, '10': 'configVersion'},
  ],
  '3': [SyncProfile_ListRequest$json, SyncProfile_ListResponse$json, SyncProfile_CreateRequest$json, SyncProfile_CreateResponse$json, SyncProfile_UpdateRequest$json, SyncProfile_UpdateResponse$json, SyncProfile_DeleteRequest$json, SyncProfile_DeleteResponse$json],
  '4': [SyncProfile_Mode$json],
};

@$core.Deprecated('Use syncProfileDescriptor instead')
const SyncProfile_ListRequest$json = {
  '1': 'ListRequest',
};

@$core.Deprecated('Use syncProfileDescriptor instead')
const SyncProfile_ListResponse$json = {
  '1': 'ListResponse',
  '2': [
    {'1': 'results', '3': 1, '4': 3, '5': 11, '6': '.api.syncing.SyncProfile', '10': 'results'},
  ],
};

@$core.Deprecated('Use syncProfileDescriptor instead')
const SyncProfile_CreateRequest$json = {
  '1': 'CreateRequest',
  '2': [
    {'1': 'payload', '3': 1, '4': 1, '5': 11, '6': '.api.syncing.SyncProfile', '10': 'payload'},
  ],
};

@$core.Deprecated('Use syncProfileDescriptor instead')
const SyncProfile_CreateResponse$json = {
  '1': 'CreateResponse',
  '2': [
    {'1': 'result', '3': 1, '4': 1, '5': 11, '6': '.api.syncing.SyncProfile', '10': 'result'},
  ],
};

@$core.Deprecated('Use syncProfileDescriptor instead')
const SyncProfile_UpdateRequest$json = {
  '1': 'UpdateRequest',
  '2': [
    {'1': 'payload', '3': 1, '4': 1, '5': 11, '6': '.api.syncing.SyncProfile', '10': 'payload'},
  ],
};

@$core.Deprecated('Use syncProfileDescriptor instead')
const SyncProfile_UpdateResponse$json = {
  '1': 'UpdateResponse',
  '2': [
    {'1': 'result', '3': 1, '4': 1, '5': 11, '6': '.api.syncing.SyncProfile', '10': 'result'},
  ],
};

@$core.Deprecated('Use syncProfileDescriptor instead')
const SyncProfile_DeleteRequest$json = {
  '1': 'DeleteRequest',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 5, '10': 'id'},
  ],
};

@$core.Deprecated('Use syncProfileDescriptor instead')
const SyncProfile_DeleteResponse$json = {
  '1': 'DeleteResponse',
};

@$core.Deprecated('Use syncProfileDescriptor instead')
const SyncProfile_Mode$json = {
  '1': 'Mode',
  '2': [
    {'1': 'MODE_UNSPECIFIED', '2': 0},
    {'1': 'MODE_BACKUP', '2': 1},
    {'1': 'MODE_ONE_WAY', '2': 2},
    {'1': 'MODE_TWO_WAY', '2': 3},
  ],
};

/// Descriptor for `SyncProfile`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List syncProfileDescriptor = $convert.base64Decode(
    'CgtTeW5jUHJvZmlsZRIOCgJpZBgBIAEoBVICaWQSOQoKY3JlYXRlZF9hdBgCIAEoCzIaLmdvb2'
    'dsZS5wcm90b2J1Zi5UaW1lc3RhbXBSCWNyZWF0ZWRBdBI5Cgp1cGRhdGVkX2F0GAMgASgLMhou'
    'Z29vZ2xlLnByb3RvYnVmLlRpbWVzdGFtcFIJdXBkYXRlZEF0EhIKBG5hbWUYBCABKAlSBG5hbW'
    'USGAoHZW5hYmxlZBgFIAEoCFIHZW5hYmxlZBIxCgRtb2RlGAYgASgOMh0uYXBpLnN5bmNpbmcu'
    'U3luY1Byb2ZpbGUuTW9kZVIEbW9kZRIfCgtzb3VyY2VfdHlwZRgHIAEoCVIKc291cmNlVHlwZR'
    'IjCg1zb3VyY2VfY29uZmlnGAggASgJUgxzb3VyY2VDb25maWcSHwoLdGFyZ2V0X3R5cGUYCSAB'
    'KAlSCnRhcmdldFR5cGUSIwoNdGFyZ2V0X2NvbmZpZxgKIAEoCVIMdGFyZ2V0Q29uZmlnEiMKDX'
    'BvbGljeV9jb25maWcYCyABKAlSDHBvbGljeUNvbmZpZxIlCg5jb25maWdfdmVyc2lvbhgMIAEo'
    'A1INY29uZmlnVmVyc2lvbhoNCgtMaXN0UmVxdWVzdBpCCgxMaXN0UmVzcG9uc2USMgoHcmVzdW'
    'x0cxgBIAMoCzIYLmFwaS5zeW5jaW5nLlN5bmNQcm9maWxlUgdyZXN1bHRzGkMKDUNyZWF0ZVJl'
    'cXVlc3QSMgoHcGF5bG9hZBgBIAEoCzIYLmFwaS5zeW5jaW5nLlN5bmNQcm9maWxlUgdwYXlsb2'
    'FkGkIKDkNyZWF0ZVJlc3BvbnNlEjAKBnJlc3VsdBgBIAEoCzIYLmFwaS5zeW5jaW5nLlN5bmNQ'
    'cm9maWxlUgZyZXN1bHQaQwoNVXBkYXRlUmVxdWVzdBIyCgdwYXlsb2FkGAEgASgLMhguYXBpLn'
    'N5bmNpbmcuU3luY1Byb2ZpbGVSB3BheWxvYWQaQgoOVXBkYXRlUmVzcG9uc2USMAoGcmVzdWx0'
    'GAEgASgLMhguYXBpLnN5bmNpbmcuU3luY1Byb2ZpbGVSBnJlc3VsdBofCg1EZWxldGVSZXF1ZX'
    'N0Eg4KAmlkGAEgASgFUgJpZBoQCg5EZWxldGVSZXNwb25zZSJRCgRNb2RlEhQKEE1PREVfVU5T'
    'UEVDSUZJRUQQABIPCgtNT0RFX0JBQ0tVUBABEhAKDE1PREVfT05FX1dBWRACEhAKDE1PREVfVF'
    'dPX1dBWRAD');

@$core.Deprecated('Use syncRecordDescriptor instead')
const SyncRecord$json = {
  '1': 'SyncRecord',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 3, '10': 'id'},
    {'1': 'profile_id', '3': 2, '4': 1, '5': 5, '10': 'profileId'},
    {'1': 'state', '3': 3, '4': 1, '5': 14, '6': '.api.syncing.SyncRecord.State', '10': 'state'},
    {'1': 'config_version', '3': 4, '4': 1, '5': 3, '10': 'configVersion'},
    {'1': 'source_path', '3': 5, '4': 1, '5': 9, '10': 'sourcePath'},
    {'1': 'source_key', '3': 6, '4': 1, '5': 9, '10': 'sourceKey'},
    {'1': 'source_size', '3': 7, '4': 1, '5': 3, '9': 0, '10': 'sourceSize', '17': true},
    {'1': 'source_hash', '3': 8, '4': 1, '5': 9, '10': 'sourceHash'},
    {'1': 'source_hash_algorithm', '3': 9, '4': 1, '5': 9, '10': 'sourceHashAlgorithm'},
    {'1': 'source_revision', '3': 10, '4': 1, '5': 9, '10': 'sourceRevision'},
    {'1': 'source_modified_at', '3': 11, '4': 1, '5': 11, '6': '.google.protobuf.Timestamp', '10': 'sourceModifiedAt'},
    {'1': 'target_path', '3': 12, '4': 1, '5': 9, '10': 'targetPath'},
    {'1': 'target_size', '3': 13, '4': 1, '5': 3, '9': 1, '10': 'targetSize', '17': true},
    {'1': 'target_hash', '3': 14, '4': 1, '5': 9, '10': 'targetHash'},
    {'1': 'target_hash_algorithm', '3': 15, '4': 1, '5': 9, '10': 'targetHashAlgorithm'},
    {'1': 'target_revision', '3': 16, '4': 1, '5': 9, '10': 'targetRevision'},
    {'1': 'target_modified_at', '3': 17, '4': 1, '5': 11, '6': '.google.protobuf.Timestamp', '10': 'targetModifiedAt'},
    {'1': 'synced_at', '3': 18, '4': 1, '5': 11, '6': '.google.protobuf.Timestamp', '10': 'syncedAt'},
    {'1': 'tombstone_at', '3': 19, '4': 1, '5': 11, '6': '.google.protobuf.Timestamp', '10': 'tombstoneAt'},
  ],
  '3': [SyncRecord_ListRequest$json, SyncRecord_ListResponse$json, SyncRecord_UpsertRequest$json, SyncRecord_UpsertResponse$json],
  '4': [SyncRecord_State$json],
  '8': [
    {'1': '_source_size'},
    {'1': '_target_size'},
  ],
};

@$core.Deprecated('Use syncRecordDescriptor instead')
const SyncRecord_ListRequest$json = {
  '1': 'ListRequest',
  '2': [
    {'1': 'source_keys', '3': 1, '4': 3, '5': 9, '10': 'sourceKeys'},
    {'1': 'profile_id', '3': 2, '4': 1, '5': 5, '10': 'profileId'},
    {'1': 'source_path', '3': 3, '4': 1, '5': 9, '10': 'sourcePath'},
  ],
};

@$core.Deprecated('Use syncRecordDescriptor instead')
const SyncRecord_ListResponse$json = {
  '1': 'ListResponse',
  '2': [
    {'1': 'results', '3': 1, '4': 3, '5': 11, '6': '.api.syncing.SyncRecord', '10': 'results'},
  ],
};

@$core.Deprecated('Use syncRecordDescriptor instead')
const SyncRecord_UpsertRequest$json = {
  '1': 'UpsertRequest',
  '2': [
    {'1': 'results', '3': 1, '4': 3, '5': 11, '6': '.api.syncing.SyncRecord', '10': 'results'},
  ],
};

@$core.Deprecated('Use syncRecordDescriptor instead')
const SyncRecord_UpsertResponse$json = {
  '1': 'UpsertResponse',
};

@$core.Deprecated('Use syncRecordDescriptor instead')
const SyncRecord_State$json = {
  '1': 'State',
  '2': [
    {'1': 'STATE_UNSPECIFIED', '2': 0},
    {'1': 'STATE_ACTIVE', '2': 1},
    {'1': 'STATE_TOMBSTONE', '2': 2},
  ],
};

/// Descriptor for `SyncRecord`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List syncRecordDescriptor = $convert.base64Decode(
    'CgpTeW5jUmVjb3JkEg4KAmlkGAEgASgDUgJpZBIdCgpwcm9maWxlX2lkGAIgASgFUglwcm9maW'
    'xlSWQSMwoFc3RhdGUYAyABKA4yHS5hcGkuc3luY2luZy5TeW5jUmVjb3JkLlN0YXRlUgVzdGF0'
    'ZRIlCg5jb25maWdfdmVyc2lvbhgEIAEoA1INY29uZmlnVmVyc2lvbhIfCgtzb3VyY2VfcGF0aB'
    'gFIAEoCVIKc291cmNlUGF0aBIdCgpzb3VyY2Vfa2V5GAYgASgJUglzb3VyY2VLZXkSJAoLc291'
    'cmNlX3NpemUYByABKANIAFIKc291cmNlU2l6ZYgBARIfCgtzb3VyY2VfaGFzaBgIIAEoCVIKc2'
    '91cmNlSGFzaBIyChVzb3VyY2VfaGFzaF9hbGdvcml0aG0YCSABKAlSE3NvdXJjZUhhc2hBbGdv'
    'cml0aG0SJwoPc291cmNlX3JldmlzaW9uGAogASgJUg5zb3VyY2VSZXZpc2lvbhJIChJzb3VyY2'
    'VfbW9kaWZpZWRfYXQYCyABKAsyGi5nb29nbGUucHJvdG9idWYuVGltZXN0YW1wUhBzb3VyY2VN'
    'b2RpZmllZEF0Eh8KC3RhcmdldF9wYXRoGAwgASgJUgp0YXJnZXRQYXRoEiQKC3RhcmdldF9zaX'
    'plGA0gASgDSAFSCnRhcmdldFNpemWIAQESHwoLdGFyZ2V0X2hhc2gYDiABKAlSCnRhcmdldEhh'
    'c2gSMgoVdGFyZ2V0X2hhc2hfYWxnb3JpdGhtGA8gASgJUhN0YXJnZXRIYXNoQWxnb3JpdGhtEi'
    'cKD3RhcmdldF9yZXZpc2lvbhgQIAEoCVIOdGFyZ2V0UmV2aXNpb24SSAoSdGFyZ2V0X21vZGlm'
    'aWVkX2F0GBEgASgLMhouZ29vZ2xlLnByb3RvYnVmLlRpbWVzdGFtcFIQdGFyZ2V0TW9kaWZpZW'
    'RBdBI3CglzeW5jZWRfYXQYEiABKAsyGi5nb29nbGUucHJvdG9idWYuVGltZXN0YW1wUghzeW5j'
    'ZWRBdBI9Cgx0b21ic3RvbmVfYXQYEyABKAsyGi5nb29nbGUucHJvdG9idWYuVGltZXN0YW1wUg'
    't0b21ic3RvbmVBdBpuCgtMaXN0UmVxdWVzdBIfCgtzb3VyY2Vfa2V5cxgBIAMoCVIKc291cmNl'
    'S2V5cxIdCgpwcm9maWxlX2lkGAIgASgFUglwcm9maWxlSWQSHwoLc291cmNlX3BhdGgYAyABKA'
    'lSCnNvdXJjZVBhdGgaQQoMTGlzdFJlc3BvbnNlEjEKB3Jlc3VsdHMYASADKAsyFy5hcGkuc3lu'
    'Y2luZy5TeW5jUmVjb3JkUgdyZXN1bHRzGkIKDVVwc2VydFJlcXVlc3QSMQoHcmVzdWx0cxgBIA'
    'MoCzIXLmFwaS5zeW5jaW5nLlN5bmNSZWNvcmRSB3Jlc3VsdHMaEAoOVXBzZXJ0UmVzcG9uc2Ui'
    'RQoFU3RhdGUSFQoRU1RBVEVfVU5TUEVDSUZJRUQQABIQCgxTVEFURV9BQ1RJVkUQARITCg9TVE'
    'FURV9UT01CU1RPTkUQAkIOCgxfc291cmNlX3NpemVCDgoMX3RhcmdldF9zaXpl');

@$core.Deprecated('Use syncHistoryDescriptor instead')
const SyncHistory$json = {
  '1': 'SyncHistory',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 3, '10': 'id'},
    {'1': 'profile_id', '3': 2, '4': 1, '5': 5, '10': 'profileId'},
    {'1': 'run_id', '3': 3, '4': 1, '5': 9, '10': 'runId'},
    {'1': 'status', '3': 4, '4': 1, '5': 14, '6': '.api.syncing.SyncHistory.Status', '10': 'status'},
    {'1': 'trigger', '3': 5, '4': 1, '5': 14, '6': '.api.syncing.SyncHistory.Trigger', '10': 'trigger'},
    {'1': 'config_version', '3': 6, '4': 1, '5': 3, '10': 'configVersion'},
    {'1': 'started_at', '3': 7, '4': 1, '5': 11, '6': '.google.protobuf.Timestamp', '10': 'startedAt'},
    {'1': 'finished_at', '3': 8, '4': 1, '5': 11, '6': '.google.protobuf.Timestamp', '10': 'finishedAt'},
    {'1': 'synced', '3': 9, '4': 1, '5': 5, '10': 'synced'},
    {'1': 'skipped', '3': 10, '4': 1, '5': 5, '10': 'skipped'},
    {'1': 'scanned', '3': 11, '4': 1, '5': 5, '10': 'scanned'},
    {'1': 'failed', '3': 12, '4': 1, '5': 5, '10': 'failed'},
    {'1': 'conflicted', '3': 13, '4': 1, '5': 5, '10': 'conflicted'},
    {'1': 'error_summary', '3': 14, '4': 1, '5': 9, '10': 'errorSummary'},
    {'1': 'issues', '3': 15, '4': 3, '5': 11, '6': '.api.syncing.SyncHistoryIssue', '10': 'issues'},
  ],
  '3': [SyncHistory_ListRequest$json, SyncHistory_ListResponse$json, SyncHistory_CreateRequest$json, SyncHistory_CreateResponse$json, SyncHistory_StartRequest$json, SyncHistory_StartResponse$json, SyncHistory_FinishRequest$json, SyncHistory_FinishResponse$json],
  '4': [SyncHistory_Status$json, SyncHistory_Trigger$json],
};

@$core.Deprecated('Use syncHistoryDescriptor instead')
const SyncHistory_ListRequest$json = {
  '1': 'ListRequest',
  '2': [
    {'1': 'profile_id', '3': 1, '4': 1, '5': 5, '10': 'profileId'},
    {'1': 'before_id', '3': 2, '4': 1, '5': 3, '10': 'beforeId'},
    {'1': 'limit', '3': 3, '4': 1, '5': 5, '10': 'limit'},
  ],
};

@$core.Deprecated('Use syncHistoryDescriptor instead')
const SyncHistory_ListResponse$json = {
  '1': 'ListResponse',
  '2': [
    {'1': 'results', '3': 1, '4': 3, '5': 11, '6': '.api.syncing.SyncHistory', '10': 'results'},
  ],
};

@$core.Deprecated('Use syncHistoryDescriptor instead')
const SyncHistory_CreateRequest$json = {
  '1': 'CreateRequest',
  '2': [
    {'1': 'payload', '3': 1, '4': 1, '5': 11, '6': '.api.syncing.SyncHistory', '10': 'payload'},
  ],
};

@$core.Deprecated('Use syncHistoryDescriptor instead')
const SyncHistory_CreateResponse$json = {
  '1': 'CreateResponse',
  '2': [
    {'1': 'result', '3': 1, '4': 1, '5': 11, '6': '.api.syncing.SyncHistory', '10': 'result'},
  ],
};

@$core.Deprecated('Use syncHistoryDescriptor instead')
const SyncHistory_StartRequest$json = {
  '1': 'StartRequest',
  '2': [
    {'1': 'payload', '3': 1, '4': 1, '5': 11, '6': '.api.syncing.SyncHistory', '10': 'payload'},
  ],
};

@$core.Deprecated('Use syncHistoryDescriptor instead')
const SyncHistory_StartResponse$json = {
  '1': 'StartResponse',
  '2': [
    {'1': 'result', '3': 1, '4': 1, '5': 11, '6': '.api.syncing.SyncHistory', '10': 'result'},
  ],
};

@$core.Deprecated('Use syncHistoryDescriptor instead')
const SyncHistory_FinishRequest$json = {
  '1': 'FinishRequest',
  '2': [
    {'1': 'payload', '3': 1, '4': 1, '5': 11, '6': '.api.syncing.SyncHistory', '10': 'payload'},
  ],
};

@$core.Deprecated('Use syncHistoryDescriptor instead')
const SyncHistory_FinishResponse$json = {
  '1': 'FinishResponse',
  '2': [
    {'1': 'result', '3': 1, '4': 1, '5': 11, '6': '.api.syncing.SyncHistory', '10': 'result'},
  ],
};

@$core.Deprecated('Use syncHistoryDescriptor instead')
const SyncHistory_Status$json = {
  '1': 'Status',
  '2': [
    {'1': 'STATUS_UNSPECIFIED', '2': 0},
    {'1': 'STATUS_RUNNING', '2': 1},
    {'1': 'STATUS_SUCCEEDED', '2': 2},
    {'1': 'STATUS_PARTIAL', '2': 3},
    {'1': 'STATUS_FAILED', '2': 4},
    {'1': 'STATUS_INTERRUPTED', '2': 5},
    {'1': 'STATUS_CANCELED', '2': 6},
  ],
};

@$core.Deprecated('Use syncHistoryDescriptor instead')
const SyncHistory_Trigger$json = {
  '1': 'Trigger',
  '2': [
    {'1': 'TRIGGER_UNSPECIFIED', '2': 0},
    {'1': 'TRIGGER_MANUAL', '2': 1},
    {'1': 'TRIGGER_SCHEDULED', '2': 2},
    {'1': 'TRIGGER_RETRY', '2': 3},
  ],
};

/// Descriptor for `SyncHistory`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List syncHistoryDescriptor = $convert.base64Decode(
    'CgtTeW5jSGlzdG9yeRIOCgJpZBgBIAEoA1ICaWQSHQoKcHJvZmlsZV9pZBgCIAEoBVIJcHJvZm'
    'lsZUlkEhUKBnJ1bl9pZBgDIAEoCVIFcnVuSWQSNwoGc3RhdHVzGAQgASgOMh8uYXBpLnN5bmNp'
    'bmcuU3luY0hpc3RvcnkuU3RhdHVzUgZzdGF0dXMSOgoHdHJpZ2dlchgFIAEoDjIgLmFwaS5zeW'
    '5jaW5nLlN5bmNIaXN0b3J5LlRyaWdnZXJSB3RyaWdnZXISJQoOY29uZmlnX3ZlcnNpb24YBiAB'
    'KANSDWNvbmZpZ1ZlcnNpb24SOQoKc3RhcnRlZF9hdBgHIAEoCzIaLmdvb2dsZS5wcm90b2J1Zi'
    '5UaW1lc3RhbXBSCXN0YXJ0ZWRBdBI7CgtmaW5pc2hlZF9hdBgIIAEoCzIaLmdvb2dsZS5wcm90'
    'b2J1Zi5UaW1lc3RhbXBSCmZpbmlzaGVkQXQSFgoGc3luY2VkGAkgASgFUgZzeW5jZWQSGAoHc2'
    'tpcHBlZBgKIAEoBVIHc2tpcHBlZBIYCgdzY2FubmVkGAsgASgFUgdzY2FubmVkEhYKBmZhaWxl'
    'ZBgMIAEoBVIGZmFpbGVkEh4KCmNvbmZsaWN0ZWQYDSABKAVSCmNvbmZsaWN0ZWQSIwoNZXJyb3'
    'Jfc3VtbWFyeRgOIAEoCVIMZXJyb3JTdW1tYXJ5EjUKBmlzc3VlcxgPIAMoCzIdLmFwaS5zeW5j'
    'aW5nLlN5bmNIaXN0b3J5SXNzdWVSBmlzc3VlcxpfCgtMaXN0UmVxdWVzdBIdCgpwcm9maWxlX2'
    'lkGAEgASgFUglwcm9maWxlSWQSGwoJYmVmb3JlX2lkGAIgASgDUghiZWZvcmVJZBIUCgVsaW1p'
    'dBgDIAEoBVIFbGltaXQaQgoMTGlzdFJlc3BvbnNlEjIKB3Jlc3VsdHMYASADKAsyGC5hcGkuc3'
    'luY2luZy5TeW5jSGlzdG9yeVIHcmVzdWx0cxpDCg1DcmVhdGVSZXF1ZXN0EjIKB3BheWxvYWQY'
    'ASABKAsyGC5hcGkuc3luY2luZy5TeW5jSGlzdG9yeVIHcGF5bG9hZBpCCg5DcmVhdGVSZXNwb2'
    '5zZRIwCgZyZXN1bHQYASABKAsyGC5hcGkuc3luY2luZy5TeW5jSGlzdG9yeVIGcmVzdWx0GkIK'
    'DFN0YXJ0UmVxdWVzdBIyCgdwYXlsb2FkGAEgASgLMhguYXBpLnN5bmNpbmcuU3luY0hpc3Rvcn'
    'lSB3BheWxvYWQaQQoNU3RhcnRSZXNwb25zZRIwCgZyZXN1bHQYASABKAsyGC5hcGkuc3luY2lu'
    'Zy5TeW5jSGlzdG9yeVIGcmVzdWx0GkMKDUZpbmlzaFJlcXVlc3QSMgoHcGF5bG9hZBgBIAEoCz'
    'IYLmFwaS5zeW5jaW5nLlN5bmNIaXN0b3J5UgdwYXlsb2FkGkIKDkZpbmlzaFJlc3BvbnNlEjAK'
    'BnJlc3VsdBgBIAEoCzIYLmFwaS5zeW5jaW5nLlN5bmNIaXN0b3J5UgZyZXN1bHQingEKBlN0YX'
    'R1cxIWChJTVEFUVVNfVU5TUEVDSUZJRUQQABISCg5TVEFUVVNfUlVOTklORxABEhQKEFNUQVRV'
    'U19TVUNDRUVERUQQAhISCg5TVEFUVVNfUEFSVElBTBADEhEKDVNUQVRVU19GQUlMRUQQBBIWCh'
    'JTVEFUVVNfSU5URVJSVVBURUQQBRITCg9TVEFUVVNfQ0FOQ0VMRUQQBiJgCgdUcmlnZ2VyEhcK'
    'E1RSSUdHRVJfVU5TUEVDSUZJRUQQABISCg5UUklHR0VSX01BTlVBTBABEhUKEVRSSUdHRVJfU0'
    'NIRURVTEVEEAISEQoNVFJJR0dFUl9SRVRSWRAD');

@$core.Deprecated('Use syncHistoryIssueDescriptor instead')
const SyncHistoryIssue$json = {
  '1': 'SyncHistoryIssue',
  '2': [
    {'1': 'id', '3': 1, '4': 1, '5': 3, '10': 'id'},
    {'1': 'created_at', '3': 2, '4': 1, '5': 11, '6': '.google.protobuf.Timestamp', '10': 'createdAt'},
    {'1': 'updated_at', '3': 3, '4': 1, '5': 11, '6': '.google.protobuf.Timestamp', '10': 'updatedAt'},
    {'1': 'history_id', '3': 4, '4': 1, '5': 3, '10': 'historyId'},
    {'1': 'error_code', '3': 5, '4': 1, '5': 9, '10': 'errorCode'},
    {'1': 'error_message', '3': 6, '4': 1, '5': 9, '10': 'errorMessage'},
    {'1': 'error_operation', '3': 7, '4': 1, '5': 14, '6': '.api.syncing.SyncHistoryIssue.Operation', '10': 'errorOperation'},
    {'1': 'kind', '3': 8, '4': 1, '5': 14, '6': '.api.syncing.SyncHistoryIssue.Kind', '10': 'kind'},
    {'1': 'context', '3': 9, '4': 1, '5': 9, '10': 'context'},
    {'1': 'source_key', '3': 10, '4': 1, '5': 9, '10': 'sourceKey'},
    {'1': 'source_path', '3': 11, '4': 1, '5': 9, '10': 'sourcePath'},
    {'1': 'source_label', '3': 12, '4': 1, '5': 9, '10': 'sourceLabel'},
    {'1': 'target_path', '3': 13, '4': 1, '5': 9, '10': 'targetPath'},
  ],
  '3': [SyncHistoryIssue_ListRequest$json, SyncHistoryIssue_ListResponse$json],
  '4': [SyncHistoryIssue_Kind$json, SyncHistoryIssue_Operation$json],
};

@$core.Deprecated('Use syncHistoryIssueDescriptor instead')
const SyncHistoryIssue_ListRequest$json = {
  '1': 'ListRequest',
  '2': [
    {'1': 'error_code', '3': 1, '4': 1, '5': 9, '10': 'errorCode'},
    {'1': 'error_operation', '3': 2, '4': 1, '5': 14, '6': '.api.syncing.SyncHistoryIssue.Operation', '10': 'errorOperation'},
    {'1': 'source_key', '3': 3, '4': 1, '5': 9, '10': 'sourceKey'},
    {'1': 'before_id', '3': 4, '4': 1, '5': 3, '10': 'beforeId'},
    {'1': 'history_id', '3': 5, '4': 1, '5': 3, '10': 'historyId'},
    {'1': 'kind', '3': 6, '4': 1, '5': 14, '6': '.api.syncing.SyncHistoryIssue.Kind', '10': 'kind'},
    {'1': 'limit', '3': 7, '4': 1, '5': 5, '10': 'limit'},
  ],
};

@$core.Deprecated('Use syncHistoryIssueDescriptor instead')
const SyncHistoryIssue_ListResponse$json = {
  '1': 'ListResponse',
  '2': [
    {'1': 'results', '3': 1, '4': 3, '5': 11, '6': '.api.syncing.SyncHistoryIssue', '10': 'results'},
  ],
};

@$core.Deprecated('Use syncHistoryIssueDescriptor instead')
const SyncHistoryIssue_Kind$json = {
  '1': 'Kind',
  '2': [
    {'1': 'KIND_UNSPECIFIED', '2': 0},
    {'1': 'KIND_ERROR', '2': 1},
    {'1': 'KIND_CONFLICT', '2': 2},
  ],
};

@$core.Deprecated('Use syncHistoryIssueDescriptor instead')
const SyncHistoryIssue_Operation$json = {
  '1': 'Operation',
  '2': [
    {'1': 'OPERATION_UNSPECIFIED', '2': 0},
    {'1': 'OPERATION_SCAN', '2': 1},
    {'1': 'OPERATION_UPLOAD', '2': 2},
    {'1': 'OPERATION_DOWNLOAD', '2': 3},
    {'1': 'OPERATION_DELETE', '2': 4},
    {'1': 'OPERATION_VERIFY', '2': 5},
  ],
};

/// Descriptor for `SyncHistoryIssue`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List syncHistoryIssueDescriptor = $convert.base64Decode(
    'ChBTeW5jSGlzdG9yeUlzc3VlEg4KAmlkGAEgASgDUgJpZBI5CgpjcmVhdGVkX2F0GAIgASgLMh'
    'ouZ29vZ2xlLnByb3RvYnVmLlRpbWVzdGFtcFIJY3JlYXRlZEF0EjkKCnVwZGF0ZWRfYXQYAyAB'
    'KAsyGi5nb29nbGUucHJvdG9idWYuVGltZXN0YW1wUgl1cGRhdGVkQXQSHQoKaGlzdG9yeV9pZB'
    'gEIAEoA1IJaGlzdG9yeUlkEh0KCmVycm9yX2NvZGUYBSABKAlSCWVycm9yQ29kZRIjCg1lcnJv'
    'cl9tZXNzYWdlGAYgASgJUgxlcnJvck1lc3NhZ2USUAoPZXJyb3Jfb3BlcmF0aW9uGAcgASgOMi'
    'cuYXBpLnN5bmNpbmcuU3luY0hpc3RvcnlJc3N1ZS5PcGVyYXRpb25SDmVycm9yT3BlcmF0aW9u'
    'EjYKBGtpbmQYCCABKA4yIi5hcGkuc3luY2luZy5TeW5jSGlzdG9yeUlzc3VlLktpbmRSBGtpbm'
    'QSGAoHY29udGV4dBgJIAEoCVIHY29udGV4dBIdCgpzb3VyY2Vfa2V5GAogASgJUglzb3VyY2VL'
    'ZXkSHwoLc291cmNlX3BhdGgYCyABKAlSCnNvdXJjZVBhdGgSIQoMc291cmNlX2xhYmVsGAwgAS'
    'gJUgtzb3VyY2VMYWJlbBIfCgt0YXJnZXRfcGF0aBgNIAEoCVIKdGFyZ2V0UGF0aBqnAgoLTGlz'
    'dFJlcXVlc3QSHQoKZXJyb3JfY29kZRgBIAEoCVIJZXJyb3JDb2RlElAKD2Vycm9yX29wZXJhdG'
    'lvbhgCIAEoDjInLmFwaS5zeW5jaW5nLlN5bmNIaXN0b3J5SXNzdWUuT3BlcmF0aW9uUg5lcnJv'
    'ck9wZXJhdGlvbhIdCgpzb3VyY2Vfa2V5GAMgASgJUglzb3VyY2VLZXkSGwoJYmVmb3JlX2lkGA'
    'QgASgDUghiZWZvcmVJZBIdCgpoaXN0b3J5X2lkGAUgASgDUgloaXN0b3J5SWQSNgoEa2luZBgG'
    'IAEoDjIiLmFwaS5zeW5jaW5nLlN5bmNIaXN0b3J5SXNzdWUuS2luZFIEa2luZBIUCgVsaW1pdB'
    'gHIAEoBVIFbGltaXQaRwoMTGlzdFJlc3BvbnNlEjcKB3Jlc3VsdHMYASADKAsyHS5hcGkuc3lu'
    'Y2luZy5TeW5jSGlzdG9yeUlzc3VlUgdyZXN1bHRzIj8KBEtpbmQSFAoQS0lORF9VTlNQRUNJRk'
    'lFRBAAEg4KCktJTkRfRVJST1IQARIRCg1LSU5EX0NPTkZMSUNUEAIilAEKCU9wZXJhdGlvbhIZ'
    'ChVPUEVSQVRJT05fVU5TUEVDSUZJRUQQABISCg5PUEVSQVRJT05fU0NBThABEhQKEE9QRVJBVE'
    'lPTl9VUExPQUQQAhIWChJPUEVSQVRJT05fRE9XTkxPQUQQAxIUChBPUEVSQVRJT05fREVMRVRF'
    'EAQSFAoQT1BFUkFUSU9OX1ZFUklGWRAF');
