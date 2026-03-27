import 'package:flutter/material.dart';
import 'package:lost_app_management/admin/screens/admin_dashboard.dart';
import 'package:lost_app_management/admin/screens/admin_profile_screen.dart';
import 'package:lost_app_management/admin/screens/admin_settings_screen.dart';
import 'package:lost_app_management/admin/screens/manage_items_screen.dart';

class AdminBottomNav extends StatefulWidget {
  const AdminBottomNav({super.key, required this.currentIndex});

  final int currentIndex;

  @override
  State<AdminBottomNav> createState() => _AdminBottomNavState();
}

class _AdminBottomNavState extends State<AdminBottomNav> {
  void _openIndex(int index) {
    if (index == widget.currentIndex) {
      return;
    }

    Widget screen;
    switch (index) {
      case 1:
        screen = const ManageItemsScreen();
        break;
      case 2:
        screen = const AdminProfileScreen();
        break;
      case 3:
        screen = const AdminSettingsScreen();
        break;
      case 0:
      default:
        screen = const AdminDashboard();
        break;
    }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => screen),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: widget.currentIndex,
      selectedItemColor: const Color(0xFF0F3D56),
      unselectedItemColor: Colors.grey,
      onTap: _openIndex,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.dashboard_customize_rounded),
          label: 'Dashboard',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.inventory_outlined),
          label: 'Items',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.people_outline_rounded),
          label: 'Users',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.settings_outlined),
          label: 'Settings',
        ),
      ],
    );
  }
}
