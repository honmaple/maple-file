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

  static const List<Widget> _widgets = <Widget>[
    FileList(),
    Setting(),
  ];

  @override
  Widget build(BuildContext context) {
    final fileSelection = ref.watch(
      fileSelectionProvider.select((state) => state.enabled),
    );
    return Scaffold(
      body: Center(
        child: _widgets.elementAt(_selectedIndex),
      ),
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
  final Widget? child;
  final String? initialRoute;
  final RouteFactory? onGenerateRoute;

  const DesktopIndex({
    super.key,
    this.child,
    this.initialRoute,
    this.onGenerateRoute,
  });

  @override
  ConsumerState<DesktopIndex> createState() => _DesktopIndexState();
}

class _DesktopIndexState extends ConsumerState<DesktopIndex> {
  final _navigatorKey = GlobalKey<NavigatorState>();

  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) async {
        if (didPop) return;
      },
      child: Scaffold(
        body: Row(
          // mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(height: 30),
                Expanded(
                  child: NavigationRail(
                    // minExtendedWidth: 200,
                    extended: false,
                    labelType: NavigationRailLabelType.all,
                    selectedIndex: _selectedIndex,
                    // groupAlignment: groupAlignment,
                    onDestinationSelected: _onDestinationSelected,
                    destinations: const <NavigationRailDestination>[
                      NavigationRailDestination(
                        icon: Icon(Icons.school),
                        label: Text('文件'),
                      ),
                      NavigationRailDestination(
                        icon: Icon(Icons.settings),
                        label: Text('设置'),
                      ),
                      NavigationRailDestination(
                        icon: Icon(Icons.info),
                        label: Text('关于'),
                      ),
                    ],
                  ),
                ),
                // IconButton(
                //   icon: Icon(Icons.settings),
                //   onPressed: () {
                //     _navigatorKey.currentState?.pushNamed('/setting');
                //   },
                // ),
              ],
            ),
            VerticalDivider(thickness: 1, width: 1, color: Colors.grey[300]),
            Expanded(
              child: Center(
                child: widget.child ??
                    Navigator(
                      key: _navigatorKey,
                      initialRoute: widget.initialRoute,
                      onGenerateRoute: widget.onGenerateRoute,
                    ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _onDestinationSelected(int index) {
    if (index != _selectedIndex) {
      switch (index) {
        case 0:
          _navigatorKey.currentState?.pushNamed('/file/list');
          break;
        case 1:
          _navigatorKey.currentState?.pushNamed('/setting');
          break;
        case 2:
          _navigatorKey.currentState?.pushNamed('/about');
          break;
      }
      setState(() {
        _selectedIndex = index;
      });
    }
  }
}
