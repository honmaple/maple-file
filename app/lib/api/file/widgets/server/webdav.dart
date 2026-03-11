import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';

import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:maple_file/app/i18n.dart';
import 'package:maple_file/common/utils/util.dart';
import 'package:maple_file/common/utils/color.dart';
import 'package:maple_file/common/widgets/custom.dart';
import 'package:maple_file/common/widgets/form.dart';
import 'package:maple_file/common/widgets/platform.dart';

import 'package:maple_file/api/setting/providers/setting.dart';
import 'package:maple_file/api/file/providers/server.dart';

part 'webdav.g.dart';
part 'webdav.freezed.dart';

@freezed
class WebdavOption with _$WebdavOption {
  const factory WebdavOption({
    @Default(false) bool enabled,
    @Default("") String host,
    @Default(0) int port,
    @Default("") String username,
    @Default("") String password,
  }) = _WebdavOption;

  factory WebdavOption.fromJson(Map<String, Object?> json) =>
      _$WebdavOptionFromJson(json);
}

final webdavSettingProvider = newSettingNotifier(
  "app.file.server.webdav",
  const WebdavOption(),
  WebdavOption.fromJson,
);

class WebdavServer extends ConsumerStatefulWidget {
  const WebdavServer({super.key});

  @override
  ConsumerState<WebdavServer> createState() => _WebdavServerState();
}

class _WebdavServerState extends ConsumerState<WebdavServer> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    final option = ref.watch(webdavSettingProvider);
    return PlatformScaffold(
      iosContentPadding: true,
      backgroundColor: ColorUtil.scaffoldBackgroundColor(context),
      appBar: PlatformAppBar(
        title: Text("Webdav"),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            CustomAsyncValue(
              value: ref.watch(serverNotifierProvider("webdav")),
              builder: (server) {
                if (server.running) {
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CustomListSection(
                        hasLeading: false,
                        dividerMargin: 20,
                        children: [
                          Container(
                            padding: EdgeInsets.fromLTRB(0, 16, 0, 16),
                            alignment: Alignment.center,
                            child: Column(
                              children: [
                                Text(
                                  "服务正在运行".tr(),
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 8),
                                SelectionArea(
                                  child: Text.rich(
                                    TextSpan(
                                      children: [
                                        TextSpan(text: "访问地址".tr()),
                                        TextSpan(text: ": "),
                                        TextSpan(
                                            text: "http://${server.addr}/dav"),
                                      ],
                                    ),
                                    style:
                                        Theme.of(context).textTheme.bodySmall,
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 16),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const SizedBox(height: 4),
                            SizedBox(
                              width: double.infinity,
                              child: FilledButton(
                                style: FilledButton.styleFrom(
                                  foregroundColor:
                                      themeData.colorScheme.primary,
                                  backgroundColor:
                                      ColorUtil.backgroundColor(context),
                                ),
                                child: Text("关闭服务".tr()),
                                onPressed: () {
                                  _handleDisable(option);
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                }
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CustomListSection(
                      hasLeading: false,
                      dividerMargin: 20,
                      children: [
                        CustomListTileTextField(
                          label: "用户名".tr(),
                          value: option.username,
                          isRequired: true,
                          onChanged: (result) {
                            ref
                                .read(webdavSettingProvider.notifier)
                                .update((state) {
                              return state.copyWith(username: result);
                            });
                          },
                        ),
                        CustomListTileTextField(
                          type: CustomListTileTextFieldType.password,
                          label: "密码".tr(),
                          value: option.password,
                          isRequired: true,
                          onChanged: (result) {
                            ref
                                .read(webdavSettingProvider.notifier)
                                .update((state) {
                              return state.copyWith(password: result);
                            });
                          },
                        ),
                        CustomListTileTextField(
                          type: CustomListTileTextFieldType.number,
                          label: "端口".tr(),
                          value: "${option.port}",
                          subtitle: Text("端口为 0 时将使用随机端口".tr()),
                          isRequired: true,
                          onChanged: (result) {
                            ref
                                .read(webdavSettingProvider.notifier)
                                .update((state) {
                              return state.copyWith(port: int.parse(result));
                            });
                          },
                        ),
                      ],
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const SizedBox(height: 4),
                          SizedBox(
                            width: double.infinity,
                            child: FilledButton(
                              child: Text("开启服务".tr()),
                              onPressed: () {
                                _handleEnable(option);
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  _handleEnable(WebdavOption option) async {
    if (_formKey.currentState!.validate()) {
      final ip = await Util.localIP();

      if (ip == null || ip == "") {
        SmartDialog.showNotify(
          msg: "无法启动服务，请连接WIFI后再试".tr(),
          notifyType: NotifyType.error,
        );
        return;
      }
      final opt = option.copyWith(host: ip).toJson();
      ExternalServerService.instance.start("webdav", option: opt).then((_) {
        ref.read(webdavSettingProvider.notifier).update((state) {
          return state.copyWith(enabled: true);
        });
        ref.invalidate(serverNotifierProvider("webdav"));
      });
    }
  }

  _handleDisable(WebdavOption option) {
    ExternalServerService.instance.stop("webdav").then((_) {
      ref.read(webdavSettingProvider.notifier).update((state) {
        return state.copyWith(enabled: false);
      });
      ref.invalidate(serverNotifierProvider("webdav"));
    });
  }
}
