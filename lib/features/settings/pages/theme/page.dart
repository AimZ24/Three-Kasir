import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kasirsuper/features/settings/blocs/blocs.dart';

class ThemeSettingsPage extends StatelessWidget {
  const ThemeSettingsPage({super.key});

  static const String routeName = '/settings/theme';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Theme Mode'),
      ),
      body: BlocBuilder<ThemeBloc, ThemeState>(
        builder: (context, state) {
          return ListView(
            children: [
              RadioListTile<ThemeMode>(
                title: const Text('Light Mode'),
                subtitle: const Text('Use light theme'),
                value: ThemeMode.light,
                groupValue: state.themeMode,
                onChanged: (ThemeMode? value) {
                  if (value != null) {
                    context.read<ThemeBloc>().add(ChangeThemeEvent(value));
                  }
                },
              ),
              RadioListTile<ThemeMode>(
                title: const Text('Dark Mode'),
                subtitle: const Text('Use dark theme'),
                value: ThemeMode.dark,
                groupValue: state.themeMode,
                onChanged: (ThemeMode? value) {
                  if (value != null) {
                    context.read<ThemeBloc>().add(ChangeThemeEvent(value));
                  }
                },
              ),
              RadioListTile<ThemeMode>(
                title: const Text('System Default'),
                subtitle: const Text('Follow system theme settings'),
                value: ThemeMode.system,
                groupValue: state.themeMode,
                onChanged: (ThemeMode? value) {
                  if (value != null) {
                    context.read<ThemeBloc>().add(ChangeThemeEvent(value));
                  }
                },
              ),
            ],
          );
        },
      ),
    );
  }
}
