import 'package:flutter/material.dart';
import 'package:protestersoath/l10n/app_localizations.dart';

class SettingsContainer extends StatefulWidget {
  @override
  State<SettingsContainer> createState() => _SettingsContainerState();
}

class _SettingsContainerState extends State<SettingsContainer> {
  String _drawerValue = 'home';
  String _storiesValue = 'pages';

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        ListTile(
          title: Text(AppLocalizations.of(context)!.settings),
          tileColor: Colors.grey[200],
        ),
        ListTile(
          title: Text(AppLocalizations.of(context)!.about),
        ),
        Divider(),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Text('Menu Drawer', style: TextStyle(fontWeight: FontWeight.bold)),
        ),
        _buildRadioGroup(
          groupValue: _drawerValue,
          onChanged: (value) => setState(() => _drawerValue = value),
          options: const [
            {'label': 'Home', 'value': 'home'},
            {'label': 'All', 'value': 'all'},
            {'label': 'None', 'value': 'none'},
          ],
        ),
        Divider(),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Text('Stories View', style: TextStyle(fontWeight: FontWeight.bold)),
        ),
        _buildRadioGroup(
          groupValue: _storiesValue,
          onChanged: (value) => setState(() => _storiesValue = value),
          options: const [
            {'label': 'Pages', 'value': 'pages'},
            {'label': 'Feeds', 'value': 'feeds'},
          ],
        ),
      ],
    );
  }

  Widget _buildRadioGroup({
    required String groupValue,
    required void Function(String) onChanged,
    required List<Map<String, String>> options,
  }) {
    return Column(
      children: options.map((option) {
        return RadioListTile<String>(
          title: Text(option['label']!),
          value: option['value']!,
          groupValue: groupValue,
          onChanged: (value) {
            if (value != null) onChanged(value);
          },
        );
      }).toList(),
    );
  }
}
