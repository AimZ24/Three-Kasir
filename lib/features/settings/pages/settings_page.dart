import 'package:flutter/material.dart';
import 'package:kasirsuper/features/settings/pages/printer/page.dart';
import 'package:kasirsuper/features/settings/services/printer_service.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  static const String routeName = '/settings';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.print),
            title: const Text('Printer Setup'),
            subtitle: FutureBuilder<bool>(
              future: PrinterService.isConnected(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Text('Checking printer status...');
                }
                return Text(
                  snapshot.data == true
                      ? 'Printer connected'
                      : 'No printer connected',
                );
              },
            ),
            onTap: () {
              Navigator.pushNamed(context, PrinterSetupPage.routeName);
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.info),
            title: const Text('About'),
            subtitle: const Text('Kasir Super v1.0.0'),
            onTap: () {
              showAboutDialog(
                context: context,
                applicationName: 'Kasir Super',
                applicationVersion: '1.0.0',
                applicationIcon: Image.asset(
                  'assets/images/logo.png',
                  width: 50,
                  height: 50,
                ),
                children: const [
                  Text('A simple point of sale application for small businesses.'),
                  SizedBox(height: 8),
                  Text('© 2024 Kasir Super. All rights reserved.'),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}