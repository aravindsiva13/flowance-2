// lib/presentation/views/common/main_navigation_screen.dart
// COMPLETE UPDATED VERSION WITH TEAM TIME INTEGRATION

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../dashboard/dashboard_screen.dart';
import '../projects/projects_list_screen.dart';
import '../tasks/tasks_list_screen.dart';
import '../time/timesheet_screen.dart';
import '../time/team_time_dashboard_screen.dart';
import '../profile/profile_screen.dart';
import '../../viewmodels/auth_viewmodel.dart';
import '../../viewmodels/dashboard_viewmodel.dart';
import '../../viewmodels/time_tracking_viewmodel.dart';
import '../../viewmodels/team_time_viewmodel.dart';
import '../../../routes/app_routes.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/enums/user_role.dart';
import '../../../core/enums/permission.dart';

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({Key? key}) : super(key: key);

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _selectedIndex = 0;
  
  late List<Widget> _screens;
  late List<BottomNavigationBarItem> _navItems;
  
  @override
  void initState() {
    super.initState();
    
    // Load initial data after the widget is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadInitialData();
      _setupScreensAndNavItems();
    });
  }

  void _loadInitialData() {
    final dashboardVM = context.read<DashboardViewModel>();
    final timeTrackingVM = context.read<TimeTrackingViewModel>();
    
    dashboardVM.loadDashboard();
    timeTrackingVM.loadTimeEntries();
    timeTrackingVM.loadSupportingData();
  }

  void _setupScreensAndNavItems() {
    final authVM = context.read<AuthViewModel>();
    final isManager = authVM.currentUser?.role == UserRole.manager ||
                      authVM.currentUser?.role == UserRole.admin;

    setState(() {
      // Setup screens based on user role
      if (isManager) {
        _screens = [
          const DashboardScreen(),
          const ProjectsListScreen(),
          const TasksListScreen(),
          const TimesheetScreen(),
          const TeamTimeDashboardScreen(), // Manager only
          const ProfileScreen(),
        ];

        _navItems = const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard_rounded),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.folder_rounded),
            label: 'Projects',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.task_alt_rounded),
            label: 'Tasks',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.access_time_rounded),
            label: 'My Time',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.groups_rounded),
            label: 'Team Time',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_rounded),
            label: 'Profile',
          ),
        ];
      } else {
        // Team member screens (no Team Time tab)
        _screens = [
          const DashboardScreen(),
          const ProjectsListScreen(),
          const TasksListScreen(),
          const TimesheetScreen(),
          const ProfileScreen(),
        ];

        _navItems = const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard_rounded),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.folder_rounded),
            label: 'Projects',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.task_alt_rounded),
            label: 'Tasks',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.access_time_rounded),
            label: 'Time',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_rounded),
            label: 'Profile',
          ),
        ];
      }
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    
    final authVM = context.read<AuthViewModel>();
    final isManager = authVM.currentUser?.role == UserRole.manager ||
                      authVM.currentUser?.role == UserRole.admin;
    
    // Load specific data when switching tabs
    if (isManager) {
      // Manager tab indices
      if (index == 3) {
        // My Time tab
        final timeTrackingVM = context.read<TimeTrackingViewModel>();
        timeTrackingVM.loadTimeEntries();
      } else if (index == 4) {
        // Team Time tab
        final teamTimeVM = context.read<TeamTimeViewModel>();
        teamTimeVM.loadTeamTime();
      }
    } else {
      // Team member tab indices
      if (index == 3) {
        // Time tab
        final timeTrackingVM = context.read<TimeTrackingViewModel>();
        timeTrackingVM.loadTimeEntries();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // If screens haven't been initialized yet, show loading
    if (_screens.isEmpty || _navItems.isEmpty) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      appBar: _buildAppBar(),
      body: IndexedStack(
        index: _selectedIndex,
        children: _screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: AppColors.primaryBlue,
        unselectedItemColor: AppColors.textSecondary,
        items: _navItems,
      ),
      floatingActionButton: _buildFloatingActionButton(),
    );
  }

  PreferredSizeWidget? _buildAppBar() {
    final authVM = context.watch<AuthViewModel>();
    final isManager = authVM.currentUser?.role == UserRole.manager ||
                      authVM.currentUser?.role == UserRole.admin;

    // Only show app bar on screens that need it (not Dashboard)
    if (_selectedIndex == 0) return null; // Dashboard has its own app bar
    
    String title = '';
    List<Widget> actions = [];
    
    if (isManager) {
      // Manager tab indices
      switch (_selectedIndex) {
        case 1:
          title = 'Projects';
          actions = [_buildSearchButton()];
          break;
        case 2:
          title = 'Tasks';
          actions = [_buildSearchButton()];
          break;
        case 3:
          title = 'My Time';
          actions = [
            IconButton(
              onPressed: () {
                Navigator.pushNamed(context, AppRoutes.timeReports);
              },
              icon: const Icon(Icons.analytics_rounded),
              tooltip: 'Reports',
            ),
          ];
          break;
        case 4:
          title = 'Team Time';
          actions = [
            IconButton(
              onPressed: () {
                Navigator.pushNamed(context, AppRoutes.teamTimesheet);
              },
              icon: const Icon(Icons.list_alt_rounded),
              tooltip: 'Full Timesheet',
            ),
          ];
          break;
        case 5:
          title = 'Profile';
          actions = [_buildNotificationButton()];
          break;
      }
    } else {
      // Team member tab indices
      switch (_selectedIndex) {
        case 1:
          title = 'Projects';
          actions = [_buildSearchButton()];
          break;
        case 2:
          title = 'Tasks';
          actions = [_buildSearchButton()];
          break;
        case 3:
          title = 'Time Tracking';
          actions = [
            IconButton(
              onPressed: () {
                Navigator.pushNamed(context, AppRoutes.timeReports);
              },
              icon: const Icon(Icons.analytics_rounded),
              tooltip: 'Reports',
            ),
          ];
          break;
        case 4:
          title = 'Profile';
          actions = [_buildNotificationButton()];
          break;
      }
    }

    return AppBar(
      title: Text(title),
      backgroundColor: AppColors.primaryBlue,
      foregroundColor: Colors.white,
      actions: actions,
    );
  }

  Widget _buildSearchButton() {
    return IconButton(
      onPressed: () {
        Navigator.pushNamed(context, AppRoutes.search);
      },
      icon: const Icon(Icons.search_rounded),
      tooltip: 'Search',
    );
  }

  Widget _buildNotificationButton() {
    return Consumer<DashboardViewModel>(
      builder: (context, dashboardVM, child) {
        final unreadCount = dashboardVM.unreadNotificationsCount;
        
        return Stack(
          children: [
            IconButton(
              onPressed: () {
                Navigator.pushNamed(context, AppRoutes.notifications);
              },
              icon: const Icon(Icons.notifications_rounded),
              tooltip: 'Notifications',
            ),
            if (unreadCount > 0)
              Positioned(
                right: 8,
                top: 8,
                child: Container(
                  padding: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    color: AppColors.error,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  constraints: const BoxConstraints(
                    minWidth: 16,
                    minHeight: 16,
                  ),
                  child: Text(
                    unreadCount > 99 ? '99+' : unreadCount.toString(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
          ],
        );
      },
    );
  }

  Widget? _buildFloatingActionButton() {
    final authViewModel = context.watch<AuthViewModel>();
    final isManager = authViewModel.currentUser?.role == UserRole.manager ||
                      authViewModel.currentUser?.role == UserRole.admin;
    
    // Show FAB based on current tab and user permissions
    if (isManager) {
      // Manager tab indices
      switch (_selectedIndex) {
        case 1: // Projects tab
          if (authViewModel.hasPermission(Permission.createProject)) {
            return FloatingActionButton(
              heroTag: "main_nav_create_project_fab",
              onPressed: () {
                Navigator.pushNamed(context, AppRoutes.createProject);
              },
              backgroundColor: AppColors.primaryBlue,
              child: const Icon(Icons.add, color: Colors.white),
            );
          }
          break;
        case 2: // Tasks tab
          return FloatingActionButton(
            heroTag: "main_nav_create_task_fab",
            onPressed: () {
              Navigator.pushNamed(context, AppRoutes.createTask);
            },
            backgroundColor: AppColors.primaryBlue,
            child: const Icon(Icons.add_task, color: Colors.white),
          );
        case 3: // My Time tab
          return FloatingActionButton(
            heroTag: "main_nav_add_time_fab",
            onPressed: () {
              Navigator.pushNamed(context, AppRoutes.timeEntry);
            },
            backgroundColor: AppColors.primaryBlue,
            child: const Icon(Icons.add, color: Colors.white),
          );
      }
    } else {
      // Team member tab indices
      switch (_selectedIndex) {
        case 1: // Projects tab
          if (authViewModel.hasPermission(Permission.createProject)) {
            return FloatingActionButton(
              heroTag: "main_nav_create_project_fab",
              onPressed: () {
                Navigator.pushNamed(context, AppRoutes.createProject);
              },
              backgroundColor: AppColors.primaryBlue,
              child: const Icon(Icons.add, color: Colors.white),
            );
          }
          break;
        case 2: // Tasks tab
          return FloatingActionButton(
            heroTag: "main_nav_create_task_fab",
            onPressed: () {
              Navigator.pushNamed(context, AppRoutes.createTask);
            },
            backgroundColor: AppColors.primaryBlue,
            child: const Icon(Icons.add_task, color: Colors.white),
          );
        case 3: // Time tab
          return FloatingActionButton(
            heroTag: "main_nav_add_time_fab",
            onPressed: () {
              Navigator.pushNamed(context, AppRoutes.timeEntry);
            },
            backgroundColor: AppColors.primaryBlue,
            child: const Icon(Icons.add, color: Colors.white),
          );
      }
    }
    
    return null;
  }
}