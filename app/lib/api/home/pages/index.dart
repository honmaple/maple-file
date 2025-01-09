import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:maple_file/app/app.dart';
import 'package:maple_file/app/i18n.dart';
import 'package:maple_file/common/utils/util.dart';
import 'package:maple_file/common/widgets/tree.dart';
import 'package:maple_file/common/widgets/dialog.dart';
import 'package:maple_file/common/widgets/custom.dart';
import 'package:maple_file/api/file/pages/file_list.dart';
import 'package:maple_file/api/file/widgets/file_tree.dart';
import 'package:maple_file/api/file/providers/file.dart';
import 'package:maple_file/api/setting/pages/setting.dart';

class Index extends ConsumerStatefulWidget {
  const Index({super.key});

  @override
  ConsumerState<Index> createState() => _IndexState();
}

class _IndexState extends ConsumerState<Index> {
  int _selectedIndex = 0;

  final List<Widget> _widgets = <Widget>[
    const FileList(),
    const Setting(),
  ];

  @override
  Widget build(BuildContext context) {
    final fileSelection = ref.watch(
      fileSelectionProvider.select((state) => state.enabled),
    );
    return Scaffold(
      body: _widgets.elementAt(_selectedIndex),
      bottomNavigationBar: !fileSelection
          ? BottomNavigationBar(
              items: <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                  icon: const Icon(Icons.business),
                  label: '文件'.tr(),
                  backgroundColor: Colors.white,
                ),
                BottomNavigationBarItem(
                  icon: const Icon(Icons.settings),
                  label: '设置'.tr(),
                  backgroundColor: Colors.white,
                ),
              ],
              currentIndex: _selectedIndex,
              onTap: (index) {
                setState(() {
                  _selectedIndex = index;
                });
              },
            )
          : null,
    );
  }
}

class DesktopIndex extends ConsumerStatefulWidget {
  final String? initialRoute;
  final RouteFactory? onGenerateRoute;

  const DesktopIndex({
    super.key,
    this.initialRoute,
    this.onGenerateRoute,
  });

  @override
  ConsumerState<DesktopIndex> createState() => _DesktopIndexState();
}

class _DesktopIndexState extends ConsumerState<DesktopIndex> {
  final _navigatorKey = GlobalKey<NavigatorState>();
  final _navigatorKey1 = GlobalKey<NavigatorState>();

  int _selectedIndex = 0;
  bool _showFileTree = false;

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) async {
        if (didPop) return;
      },
      child: Scaffold(
        body: Row(
          children: <Widget>[
            NavigationRail(
              minExtendedWidth: 200,
              extended: false,
              labelType: NavigationRailLabelType.all,
              selectedIndex: _selectedIndex,
              onDestinationSelected: _onDestinationSelected,
              destinations: <NavigationRailDestination>[
                NavigationRailDestination(
                  icon: const Icon(Icons.school),
                  label: Text('文件'.tr()),
                ),
                NavigationRailDestination(
                  icon: const Icon(Icons.swap_vert_circle),
                  label: Text('任务'.tr()),
                ),
              ],
              leading: Util.isWindows ? null : const SizedBox(height: 16),
              trailing: Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Spacer(),
                    IconButton(
                      icon: const Icon(Icons.settings),
                      onPressed: () {
                        showListDialog2(
                          context,
                          child: const DesktopSetting(),
                        );
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.help),
                      onPressed: () {
                        showListDialog2(
                          context,
                          child: const DesktopHelp(),
                        );
                      },
                    ),
                    if (_selectedIndex == 0)
                      IconButton(
                        icon: Icon(
                          _showFileTree ? Icons.menu_open : Icons.menu,
                        ),
                        onPressed: () {
                          setState(() {
                            _showFileTree = !_showFileTree;
                          });
                        },
                      ),
                    const SizedBox(height: 8)
                  ],
                ),
              ),
            ),
            if (_selectedIndex == 0 && _showFileTree)
              const VerticalDivider(thickness: 1, width: 0.5),
            AnimatedSize(
              duration: const Duration(milliseconds: 200),
              child: SizedBox(
                width: (_selectedIndex == 0 && _showFileTree) ? 200 : 0,
                child: CustomScrollView(
                  slivers: [
                    FileTree(navigatorKey: _navigatorKey),
                  ],
                ),
              ),
            ),
            const VerticalDivider(thickness: 1, width: 0.5),
            Expanded(
              child: [
                Navigator(
                  key: _navigatorKey,
                  initialRoute: "/file/list",
                  onGenerateRoute: widget.onGenerateRoute,
                ),
                Navigator(
                  key: _navigatorKey1,
                  initialRoute: "/task/list",
                  onGenerateRoute: widget.onGenerateRoute,
                ),
              ].elementAt(_selectedIndex),
            ),
          ],
        ),
      ),
    );
  }

  _onDestinationSelected(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
}

class DesktopHelp extends StatefulWidget {
  const DesktopHelp({
    super.key,
  });

  @override
  State<DesktopHelp> createState() => _DesktopHelpState();
}

class _DesktopHelpState extends State<DesktopHelp> {
  final _navigatorKey = GlobalKey<NavigatorState>();

  _navigatorPush(String name) {
    final state = _navigatorKey.currentState ?? Navigator.of(context);
    state.pushReplacementNamed(name);
  }

  @override
  Widget build(BuildContext context) {
    final menu = [
      CustomTreeMenu(
        icon: Icons.help,
        label: "帮助".tr(),
        onTap: () {
          _navigatorPush('/help');
        },
      ),
      CustomTreeMenu(
        icon: Icons.person,
        label: "关于".tr(),
        onTap: () {
          _navigatorPush('/about');
        },
      ),
    ];
    return CustomLayout(
      menu: menu,
      navigatorKey: _navigatorKey,
      initialRoute: "/about",
      onGenerateRoute: App.router.replaceRoute(replace: {
        "/": null,
      }),
    );
  }
}
