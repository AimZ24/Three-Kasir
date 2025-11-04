import 'package:flutter/material.dart';
import 'package:kasirsuper/core/core.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:kasirsuper/features/settings/pages/printer/page.dart';
import 'package:kasirsuper/features/settings/settings.dart';
import 'package:kasirsuper/features/settings/pages/sales/page.dart';

part 'sections/profile_section.dart';

class SettingPage extends StatelessWidget {
  const SettingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lainnya'),
      ),
      body: ListView(
        children: [
          const _ProfileSection(),
          
          
          // Profile section above is the account area. Removed duplicate
          // 'Informasi Usaha' and 'API Key Xendit' as requested.
          const Divider(
            thickness: Dimens.dp8,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(Dimens.dp16),
                child: RegularText.semiBold('Perangkat Tambahan'),
              ),
              ItemMenuSetting(
                title: 'Printer Setup',
                icon: Icons.print,
                onTap: () {
                  Navigator.pushNamed(context, PrinterSetupPage.routeName);
                },
              ),
              const Divider(height: 0),
              ItemMenuSetting(
                title: 'Data Penjualan',
                icon: Icons.bar_chart,
                onTap: () {
                  Navigator.pushNamed(context, SalesDataPage.routeName);
                },
              ),
              const Divider(height: 0),
              ItemMenuSetting(
                title: 'Receipt Settings',
                icon: AppIcons.coupon,
                onTap: () {
                  Navigator.pushNamed(context, '/settings/receipt');
                },
              ),
            ],
          ),
          const Divider(
            thickness: Dimens.dp8,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(Dimens.dp16),
                child: RegularText.semiBold('Info Lainnya'),
              ),
              ItemMenuSetting(
                title: 'Kebijakan Privasi',
                icon: AppIcons.verified,
                onTap: () {
                  Navigator.pushNamed(context, '/settings/privacy');
                },
              ),
              const Divider(height: 0),
              ItemMenuSetting(
                title: 'Beri Rating',
                icon: AppIcons.star,
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Beri Rating'),
                      content: const Text(
                          'https://github.com/AimZ24'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('Tutup'),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
          // Removed logout button per request
        ],
      ),
    );
  }
}
