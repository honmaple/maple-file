import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:maple_file/app/i18n.dart';
import 'package:maple_file/api/file/pages/file_list.dart';
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
                  label: '文件'.tr(context),
                  backgroundColor: Colors.white,
                ),
                BottomNavigationBarItem(
                  icon: const Icon(Icons.settings),
                  label: '设置'.tr(context),
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
  final _navigatorKey2 = GlobalKey<NavigatorState>();

  int _selectedIndex = 0;
  bool _extended = false;

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
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _extended ? _buildMenu() : const SizedBox(height: 32),
                Expanded(
                  child: NavigationRail(
                    minExtendedWidth: 200,
                    extended: _extended,
                    labelType: _extended ? null : NavigationRailLabelType.all,
                    selectedIndex: _selectedIndex,
                    onDestinationSelected: _onDestinationSelected,
                    destinations: <NavigationRailDestination>[
                      NavigationRailDestination(
                        icon: const Icon(Icons.school),
                        label: Text('文件'.tr(context)),
                      ),
                      NavigationRailDestination(
                        icon: const Icon(Icons.swap_vert_circle),
                        label: Text('任务'.tr(context)),
                      ),
                      NavigationRailDestination(
                        icon: const Icon(Icons.settings),
                        label: Text('设置'.tr(context)),
                      ),
                    ],
                  ),
                ),
                if (!_extended) _buildMenu(),
                if (!_extended) const SizedBox(height: 8)
              ],
            ),
            VerticalDivider(thickness: 1, width: 1, color: Colors.grey[300]),
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
                Navigator(
                  key: _navigatorKey2,
                  initialRoute: "/setting",
                  onGenerateRoute: widget.onGenerateRoute,
                ),
              ].elementAt(_selectedIndex),
            ),
          ],
        ),
      ),
    );
  }

  _buildMenu() {
    return IconButton(
      icon: Icon(_extended ? Icons.menu_open : Icons.menu),
      onPressed: () {
        setState(() {
          _extended = !_extended;
        });
      },
    );
  }

  _onDestinationSelected(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
}
