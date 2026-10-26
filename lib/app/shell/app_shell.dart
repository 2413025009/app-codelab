import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Sinyal global "tab bottom-nav baru saja diaktifkan" (nilai = index tab;
/// -1 artinya belum ada aktivitas). IndexedStack dari StatefulShellRoute
/// menjaga halaman tiap tab tetap hidup di memori sehingga initState TIDAK
/// dijalankan ulang saat user kembali ke tab - halaman root memakai sinyal
/// ini untuk refresh latar belakang (stale-while-revalidate) tanpa skeleton
/// dan tanpa "refresh manual" di halaman Tantangan maupun Profil.
final ValueNotifier<int> appShellTabActivated = ValueNotifier<int>(-1);

/// Minggu 9 (owner): LESSON yang dipilih di katalog — peta bab di dashboard
/// memuat SEMUA bab lesson itu (selesai maupun belum). null = track aktif
/// natural siswa; menekan tab Belajar ulang melepas fokus (listener
/// DashboardPage).
final ValueNotifier<String?> appShellFocusTopic = ValueNotifier<String?>(null);

class AppShell extends StatelessWidget {
  const AppShell({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: NavigationBar(
        selectedIndex: navigationShell.currentIndex,
        onDestinationSelected: (index) {
          // Kabari seluruh app bahwa tab ini baru diaktifkan (termasuk tap
          // ulang pada tab yang sama) - pemicu refresh di latar belakang.
          appShellTabActivated.value = index;
          navigationShell.goBranch(
            index,
            initialLocation: index == navigationShell.currentIndex,
          );
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.school_outlined),
            selectedIcon: Icon(Icons.school_rounded),
            label: 'Belajar',
          ),
          NavigationDestination(
            icon: Icon(Icons.emoji_events_outlined),
            selectedIcon: Icon(Icons.emoji_events_rounded),
            label: 'Tantangan',
          ),
          NavigationDestination(
            icon: Icon(Icons.terminal_outlined),
            selectedIcon: Icon(Icons.terminal_rounded),
            label: 'Playground',
          ),
          NavigationDestination(
            icon: Icon(Icons.account_circle_outlined),
            selectedIcon: Icon(Icons.account_circle_rounded),
            label: 'Profil',
          ),
        ],
      ),
    );
  }
}
