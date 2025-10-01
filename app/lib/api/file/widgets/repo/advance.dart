import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:maple_file/app/i18n.dart';
import 'package:maple_file/common/widgets/form.dart';
import 'package:maple_file/generated/proto/api/file/repo.pb.dart';

enum CompressLevel {
  normal,
  best,
  fast,
}

extension CompressLevelExtension on CompressLevel {
  String label() {
    final Map<CompressLevel, String> labels = {
      CompressLevel.normal: "默认".tr(),
      CompressLevel.best: "压缩率最高".tr(),
      CompressLevel.fast: "压缩速度最快".tr(),
    };
    return labels[this] ?? "unknown";
  }

  int value() {
    final Map<CompressLevel, int> values = {
      CompressLevel.normal: -1,
      CompressLevel.best: 9,
      CompressLevel.fast: 1,
    };
    return values[this] ?? -1;
  }
}

class DriverAdvanceForm extends StatefulWidget {
  const DriverAdvanceForm({super.key, required this.form});

  final Repo form;

  @override
  State<DriverAdvanceForm> createState() => _DriverAdvanceFormState();
}

class _DriverAdvanceFormState extends State<DriverAdvanceForm> {
  late Map<String, dynamic> _option;
  late Map<String, dynamic> _cacheOption;
  late Map<String, dynamic> _recycleOption;
  late Map<String, dynamic> _encryptOption;
  late Map<String, dynamic> _compressOption;
  late Map<String, dynamic> _rateLimitOption;

  @override
  void initState() {
    super.initState();

    _option = widget.form.option == "" ? {} : jsonDecode(widget.form.option);
    _cacheOption = _option["cache_option"] ?? {};
    _recycleOption = _option["recycle_option"] ?? {};
    _encryptOption = _option["encrypt_option"] ?? {};
    _compressOption = _option["compress_option"] ?? {};
    _rateLimitOption = _option["rate_limit_option"] ?? {};
  }

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('更多设置'.tr()),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(true);
            },
            child: Text("确定".tr()),
          ),
        ],
      ),
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: 16),
        children: [
          Card(
            child: Column(
              children: [
                CustomFormField(
                  label: "根目录".tr(),
                  value: _option["root_path"],
                  onTap: (result) {
                    setState(() {
                      _option["root_path"] = result;
                    });

                    widget.form.option = jsonEncode(_option);
                  },
                ),
                FileTypeFormField(
                  label: '隐藏文件'.tr(),
                  value:
                      List<String>.from(_option["hidden_files"] ?? <String>[]),
                  onTap: (result) {
                    setState(() {
                      _option["hidden_files"] = result;
                    });

                    widget.form.option = jsonEncode(_option);
                  },
                ),
              ],
            ),
          ),
          Card(
            child: Column(
              children: [
                ListTile(
                  title: Text('回收站'.tr()),
                  subtitle: Text(
                    "是否激活回收站".tr(),
                    style: themeData.textTheme.bodySmall,
                  ),
                  trailing: Switch(
                    value: _option["recycle"] ?? false,
                    onChanged: (result) {
                      setState(() {
                        _option["recycle"] = result;
                        if (!result) {
                          _recycleOption = {};
                          _option.remove("recycle");
                          _option.remove("recycle_option");
                        }
                      });

                      widget.form.option = jsonEncode(_option);
                    },
                  ),
                ),
                if (_option["recycle"] ?? false)
                  CustomFormField(
                    label: "回收站路径".tr(),
                    value: _recycleOption["path"],
                    subtitle: Text(
                      "未设置时将在根目录创建.maplerecycle".tr(),
                      style: themeData.textTheme.bodySmall,
                    ),
                    onTap: (result) {
                      setState(() {
                        _recycleOption["path"] = result;
                        _option["recycle_option"] = _recycleOption;
                      });

                      widget.form.option = jsonEncode(_option);
                    },
                  ),
              ],
            ),
          ),
          Card(
            child: Column(
              children: [
                ListTile(
                  title: Text('访问频率'.tr()),
                  subtitle: Text(
                    "访问次数/单位时间".tr(),
                    style: themeData.textTheme.bodySmall,
                  ),
                  trailing: Switch(
                    value: _option["rate_limit"] ?? false,
                    onChanged: (result) {
                      setState(() {
                        _option["rate_limit"] = result;
                        if (!result) {
                          _rateLimitOption = {};
                          _option.remove("rate_limit");
                          _option.remove("rate_limit_option");
                        }
                      });

                      widget.form.option = jsonEncode(_option);
                    },
                  ),
                ),
                if (_option["rate_limit"] ?? false)
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CustomFormField(
                        type: CustomFormFieldType.number,
                        label: "次数限制".tr(),
                        value: "${_rateLimitOption['burst'] ?? 100}",
                        onTap: (result) {
                          setState(() {
                            _rateLimitOption["burst"] = int.parse(result);
                            _option["rate_limit_option"] = _rateLimitOption;
                          });

                          widget.form.option = jsonEncode(_option);
                        },
                      ),
                      CustomFormField(
                        type: CustomFormFieldType.number,
                        label: "时间限制".tr(),
                        subtitle: Text(
                          "单位：秒".tr(),
                          style: themeData.textTheme.bodySmall,
                        ),
                        value: "${_rateLimitOption['limit'] ?? 1}",
                        onTap: (result) {
                          setState(() {
                            _rateLimitOption["limit"] = int.parse(result);
                            _option["rate_limit_option"] = _rateLimitOption;
                          });

                          widget.form.option = jsonEncode(_option);
                        },
                      ),
                      ListTile(
                        title: Text('是否等待'.tr()),
                        subtitle: Text(
                          "为否时将立即返回错误".tr(),
                          style: themeData.textTheme.bodySmall,
                        ),
                        trailing: Switch(
                          value: _rateLimitOption["wait"] ?? false,
                          onChanged: (result) {
                            setState(() {
                              _rateLimitOption["wait"] = result;
                              _option["rate_limit_option"] = _rateLimitOption;
                            });

                            widget.form.option = jsonEncode(_option);
                          },
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ),
          Card(
            child: Column(
              children: [
                ListTile(
                  title: Text('文件缓存'.tr()),
                  subtitle: Text(
                    "缓存文件列表信息".tr(),
                    style: themeData.textTheme.bodySmall,
                  ),
                  trailing: Switch(
                    value: _option["cache"] ?? false,
                    onChanged: (result) {
                      setState(() {
                        _option["cache"] = result;
                        if (!result) {
                          _cacheOption = {};
                          _option.remove("cache");
                          _option.remove("cache_option");
                        }
                      });

                      widget.form.option = jsonEncode(_option);
                    },
                  ),
                ),
                if (_option["cache"] ?? false)
                  CustomFormField(
                    type: CustomFormFieldType.number,
                    label: "缓存时间".tr(),
                    value: "${_cacheOption['expire_time'] ?? 60}",
                    subtitle: Text(
                      "默认60秒后自动清除缓存(单位：秒)".tr(),
                      style: themeData.textTheme.bodySmall,
                    ),
                    onTap: (result) {
                      setState(() {
                        _cacheOption["expire_time"] = int.parse(result);
                        _option["cache_option"] = _cacheOption;
                      });

                      widget.form.option = jsonEncode(_option);
                    },
                  ),
              ],
            ),
          ),
          Card(
            child: Column(
              children: [
                ListTile(
                  title: Text('文件加密'.tr()),
                  subtitle: Text(
                    "文件加密创建后不可更改加密配置".tr(),
                    style: themeData.textTheme.bodySmall,
                  ),
                  trailing: Switch(
                    value: _option["encrypt"] ?? false,
                    onChanged: (result) {
                      setState(() {
                        _option["encrypt"] = result;
                        if (!result) {
                          _encryptOption = {};
                          _option.remove("encrypt");
                          _option.remove("encrypt_option");
                        }
                      });

                      widget.form.option = jsonEncode(_option);
                    },
                  ),
                ),
                if (_option["encrypt"] ?? false)
                  Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      CustomFormField(
                        type: CustomFormFieldType.password,
                        label: "文件密码".tr(),
                        value: _encryptOption["password"],
                        isRequired: true,
                        onTap: (result) {
                          setState(() {
                            _encryptOption["password"] = result;
                            _option["encrypt_option"] = _encryptOption;
                          });

                          widget.form.option = jsonEncode(_option);
                        },
                      ),
                      CustomFormField(
                        type: CustomFormFieldType.password,
                        label: "文件密码加密".tr(),
                        value: _encryptOption["password_salt"],
                        subtitle: Text(
                          "类似二次密码".tr(),
                          style: themeData.textTheme.bodySmall,
                        ),
                        onTap: (result) {
                          setState(() {
                            _encryptOption["password_salt"] = result;
                            _option["encrypt_option"] = _encryptOption;
                          });

                          widget.form.option = jsonEncode(_option);
                        },
                      ),
                      CustomFormField(
                        label: "文件后缀".tr(),
                        value: _encryptOption["suffix"],
                        onTap: (result) {
                          setState(() {
                            _encryptOption["suffix"] = result;
                            _option["encrypt_option"] = _encryptOption;
                          });

                          widget.form.option = jsonEncode(_option);
                        },
                      ),
                      ListTile(
                        title: Text('目录名称加密'.tr()),
                        trailing: Switch(
                          value: _encryptOption["dir_name"] ?? false,
                          onChanged: (result) {
                            setState(() {
                              _encryptOption["dir_name"] = result;
                              _option["encrypt_option"] = _encryptOption;
                            });

                            widget.form.option = jsonEncode(_option);
                          },
                        ),
                      ),
                      ListTile(
                        title: Text('文件名称加密'.tr()),
                        trailing: Switch(
                          value: _encryptOption["file_name"] ?? false,
                          onChanged: (result) {
                            setState(() {
                              _encryptOption["file_name"] = result;
                              _option["encrypt_option"] = _encryptOption;
                            });

                            widget.form.option = jsonEncode(_option);
                          },
                        ),
                      ),
                      CustomFormField(
                        type: CustomFormFieldType.option,
                        options: [
                          CustomFormFieldOption(
                            label: "密码反馈模式".tr(),
                            value: "CFB",
                          ),
                          CustomFormFieldOption(
                            label: "输出反馈模式".tr(),
                            value: "OFB",
                          ),
                          CustomFormFieldOption(
                            label: "计数器模式".tr(),
                            value: "CTR",
                          ),
                        ],
                        label: "加密模式".tr(),
                        value: _encryptOption["mode"] ?? "CFB",
                        isRequired: true,
                        onTap: (result) {
                          setState(() {
                            _encryptOption["mode"] = result;
                            _option["encrypt_option"] = _encryptOption;
                          });

                          widget.form.option = jsonEncode(_option);
                        },
                      ),
                      CustomFormField(
                        type: CustomFormFieldType.option,
                        options: [
                          CustomFormFieldOption(
                            label: "v1",
                            value: "v1",
                          ),
                          CustomFormFieldOption(
                            label: "v2",
                            value: "v2",
                          ),
                        ],
                        label: "加密版本".tr(),
                        value: _encryptOption["version"] ?? "v1",
                        onTap: (result) {
                          setState(() {
                            _encryptOption["version"] = result;
                            _option["encrypt_option"] = _encryptOption;
                          });

                          widget.form.option = jsonEncode(_option);
                        },
                      ),
                    ],
                  ),
              ],
            ),
          ),
          Card(
            child: Column(
              children: [
                ListTile(
                  title: Text('文件压缩'.tr()),
                  subtitle: Text(
                    "文件压缩创建后不可更改压缩配置".tr(),
                    style: themeData.textTheme.bodySmall,
                  ),
                  trailing: Switch(
                    value: _option["compress"] ?? false,
                    onChanged: (result) {
                      setState(() {
                        _option["compress"] = result;
                        if (!result) {
                          _compressOption = {};
                          _option.remove("compress");
                          _option.remove("compress_option");
                        }
                      });

                      widget.form.option = jsonEncode(_option);
                    },
                  ),
                ),
                if (_option["compress"] ?? false)
                  CustomFormField(
                    label: "压缩水平".tr(),
                    value: _compressValue(_compressOption['level']),
                    type: CustomFormFieldType.option,
                    options: CompressLevel.values.map((v) {
                      return CustomFormFieldOption(
                          label: v.label(), value: v.name);
                    }).toList(),
                    isRequired: true,
                    onTap: (result) {
                      setState(() {
                        _compressOption["level"] =
                            CompressLevel.values.byName(result).value();
                        _option["compress_option"] = _compressOption;
                      });

                      widget.form.option = jsonEncode(_option);
                    },
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String? _compressValue(int? value) {
    if (value == null) {
      return null;
    }
    if (value == 1) {
      return CompressLevel.fast.name;
    }
    if (value == 9) {
      return CompressLevel.best.name;
    }
    return CompressLevel.normal.name;
  }
}
