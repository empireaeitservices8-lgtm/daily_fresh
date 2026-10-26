import 'package:flutter/material.dart';
import '../providers/app_state.dart';
import '../widgets/app_drawer.dart';
import '../widgets/bottom_nav_bar.dart';
import 'all_tasks_screen.dart';
import 'checklist_screen.dart';
import 'dashboard_screen.dart';
import 'gm_task_creation_screen.dart';
import 'more_screen.dart';
import 'sections_screen.dart';
import 'sm_hub_screen.dart';

class HomeShell extends StatefulWidget {
  final AppState state;

  const HomeShell({super.key, required this.state});

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  void _openDrawer() {
    _scaffoldKey.currentState?.openDrawer();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: widget.state,
      builder: (context, _) {
        final currentIndex = widget.state.currentNavIndex;
        final isGM = widget.state.isGeneralManager;
        final isSM = widget.state.isStoreManager;

        Widget currentScreen;
        switch (currentIndex) {
          case 0:
            if (isGM) {
              currentScreen = GmTaskCreationScreen(
                state: widget.state,
                onOpenDrawer: _openDrawer,
              );
            } else if (isSM) {
              currentScreen = SmHubScreen(
                state: widget.state,
                onOpenDrawer: _openDrawer,
              );
            } else {
              currentScreen = DashboardScreen(
                state: widget.state,
                onOpenDrawer: _openDrawer,
                onNavigateTab: (index) => widget.state.setNavIndex(index),
              );
            }
            break;
          case 1:
            currentScreen = AllTasksScreen(
              state: widget.state,
              showBottomNav: false,
            );
            break;
          case 2:
            currentScreen = ChecklistScreen(
              state: widget.state,
              onOpenDrawer: _openDrawer,
            );
            break;
          case 3:
            currentScreen = SectionsScreen(
              state: widget.state,
              onOpenDrawer: _openDrawer,
            );
            break;
          case 4:
            currentScreen = MoreScreen(
              state: widget.state,
              onOpenDrawer: _openDrawer,
            );
            break;
          default:
            if (isGM) {
              currentScreen = GmTaskCreationScreen(
                state: widget.state,
                onOpenDrawer: _openDrawer,
              );
            } else if (isSM) {
              currentScreen = SmHubScreen(
                state: widget.state,
                onOpenDrawer: _openDrawer,
              );
            } else {
              currentScreen = DashboardScreen(
                state: widget.state,
                onOpenDrawer: _openDrawer,
                onNavigateTab: (index) => widget.state.setNavIndex(index),
              );
            }
        }

        return Scaffold(
          key: _scaffoldKey,
          drawer: AppDrawer(
            state: widget.state,
            onNavigate: (index) {
              widget.state.setNavIndex(index);
            },
          ),
          body: currentScreen,
          bottomNavigationBar: DayFreshBottomNav(
            currentIndex: currentIndex,
            isGeneralManager: isGM,
            isStoreManager: isSM,
            onTabSelected: (index) {
              widget.state.setNavIndex(index);
            },
          ),
        );
      },
    );
  }
}
