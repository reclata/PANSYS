import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';

class MainShell extends StatelessWidget {
  final Widget child;
  const MainShell({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final isDesktop = MediaQuery.of(context).size.width > 800;
    
    // Lista de Navegação (Modularizada)
    final menuItems = [
      _MenuItem(Icons.dashboard_rounded, 'Dashboard', '/dashboard'),
      _MenuItem(Icons.people_alt_rounded, 'Funcionários', '/employees'),
      _MenuItem(Icons.schedule_rounded, 'Escalas', '/scales'), // placeholders
      _MenuItem(Icons.bakery_dining_rounded, 'Produção', '/production'),
      _MenuItem(Icons.inventory_2_rounded, 'Estoque', '/inventory'),
      _MenuItem(Icons.point_of_sale_rounded, 'Caixa', '/cash_register'),
    ];

    return Scaffold(
      appBar: isDesktop ? null : AppBar(
        title: const Text('PanSys'),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      drawer: isDesktop ? null : _SideMenu(items: menuItems, auth: auth),
      body: Row(
        children: [
          if (isDesktop) 
            SizedBox(
              width: 250,
              child: _SideMenu(items: menuItems, auth: auth),
            ),
          Expanded(child: child),
        ],
      ),
    );
  }
}

class _SideMenu extends StatelessWidget {
  final List<_MenuItem> items;
  final AuthProvider auth;

  const _SideMenu({required this.items, required this.auth});

  @override
  Widget build(BuildContext context) {
    final router = GoRouter.of(context);
    final currentPath = router.routerDelegate.currentConfiguration.matches.last.matchedLocation;

    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: Column(
        children: [
          // Logo / Branding Header
          Container(
            padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
            width: double.infinity,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
              borderRadius: const BorderRadius.only(bottomRight: Radius.circular(24)),
            ),
            child: Column(
              children: [
                const Icon(Icons.bakery_dining_rounded, size: 60, color: Colors.white),
                const SizedBox(height: 12),
                Text(
                  "PanSys",
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (auth.userModel != null) ...[
                  const SizedBox(height: 8),
                  Text("Olá, \${auth.userModel!.name}", overflow: TextOverflow.ellipsis,
                      style: const TextStyle(color: Colors.white70)),
                ]
              ],
            ),
          ),
          const SizedBox(height: 16),
          // Links de Navegação
          Expanded(
            child: ListView.builder(
              itemCount: items.length,
              itemBuilder: (context, index) {
                final item = items[index];
                final isSelected = currentPath.startsWith(item.route);

                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  child: ListTile(
                    leading: Icon(
                      item.icon,
                      color: isSelected ? Colors.white : Theme.of(context).colorScheme.secondary.withOpacity(0.6),
                    ),
                    title: Text(
                      item.title,
                      style: TextStyle(
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                        color: isSelected ? Colors.white : Theme.of(context).colorScheme.secondary.withOpacity(0.8),
                      ),
                    ),
                    tileColor: isSelected ? Theme.of(context).colorScheme.primary : Colors.transparent,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    onTap: () {
                      if (!isSelected) {
                        context.go(item.route); // Navigate
                        if (Scaffold.of(context).isDrawerOpen) {
                          Navigator.pop(context); // Close mobile drawer
                        }
                      }
                    },
                  ),
                );
              },
            ),
          ),
          // Botão Logout (Footer)
          const Divider(),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: ListTile(
              leading: Icon(Icons.logout_rounded, color: Colors.red.shade400),
              title: Text('Sair do Sistema', style: TextStyle(color: Colors.red.shade400, fontWeight: FontWeight.bold)),
              onTap: () => auth.logout(),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}

class _MenuItem {
  final IconData icon;
  final String title;
  final String route;
  _MenuItem(this.icon, this.title, this.route);
}
